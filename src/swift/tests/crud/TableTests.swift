/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import XCTest
#if TEST_WCDB_SWIFT
import WCDBSwift
#else
import WCDB
#endif

class TableTests: DatabaseTestCase {

    final class BaselineObject: TableCodable, Named {
        var anInt32: Int32 = -1
        var anInt64: Int64 = 17626545782784
        var aString: String = "string"
        var aData: Data = "data".data(using: .ascii)!
        var aDouble: Double = 0.001

        enum CodingKeys: String, CodingTableKey {
            typealias Root = BaselineObject
            case anInt32
            case anInt64
            case aString
            case aData
            case aDouble
            nonisolated(unsafe) static let objectRelationalMapping = TableBinding(CodingKeys.self) {
                BindColumnConstraint(anInt32, isPrimary: true, orderBy: .ascending, isAutoIncrement: true)
            }
        }

        var isAutoIncrement: Bool = false
        var lastInsertedRowID: Int64 = 0
    }
    func testCreateTable() {
        // Give
        let tableName = BaselineObject.name
        var expected = Master()
        expected.sql = """
        CREATE TABLE \(tableName)\
        (anInt32 INTEGER PRIMARY KEY ASC AUTOINCREMENT, \
        anInt64 INTEGER, \
        aString TEXT, \
        aData BLOB, \
        aDouble REAL)
        """
        // When
        XCTAssertNoThrow(try database.create(table: tableName, of: BaselineObject.self))
        // Then
        let optionalObject: Master? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: Master.builtinTableName, where: Master.Properties.name==tableName)
        )
        XCTAssertNotNil(optionalObject)
        let object = optionalObject!
        XCTAssertEqual(
            object.sql!,
            expected.sql
        )
    }

    final class SkipColumnObject: TableCodable, Named {
        var anInt32: Int32 = -1

        enum CodingKeys: String, CodingTableKey {
            typealias Root = SkipColumnObject
            case anInt32
            nonisolated(unsafe) static let objectRelationalMapping = TableBinding(CodingKeys.self) {
                BindColumnConstraint(anInt32, isPrimary: true, orderBy: .ascending, isAutoIncrement: true)
            }
        }

        var isAutoIncrement: Bool = false
        var lastInsertedRowID: Int64 = 0
    }

    func testCreateTableSkipColumns() {
        // Give
        let tableName = BaselineObject.name
        XCTAssertNoThrow(try database.create(table: tableName, of: BaselineObject.self))
        // Then
        XCTAssertNoThrow(try database.create(table: tableName, of: SkipColumnObject.self))
    }

    final class IndexObject: TableCodable, Named {
        var variable: Int32 = 0
        enum CodingKeys: String, CodingTableKey {
            typealias Root = IndexObject
            case variable
            nonisolated(unsafe) static let objectRelationalMapping = TableBinding(CodingKeys.self) {
                BindIndex(variable, namedWith: "_index")
            }
        }
    }
    func testCreateTableWithIndex() {
        // Give
        let tableName = IndexObject.name
        let indexName = tableName+"_index"
        // When
        XCTAssertNoThrow(try database.create(table: tableName, of: IndexObject.self))
        // Then
        let optionalObject: Master? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: Master.builtinTableName, where: Master.Properties.name==indexName)
        )
        XCTAssertNotNil(optionalObject)
        let object = optionalObject!
        XCTAssertEqual(object.sql!, "CREATE INDEX \(indexName) ON IndexObject(variable)")
    }

    final class ConstraintObject: TableCodable, Named {
        var variable1: Int32 = 0
        var variable2: Int32 = 0

        enum CodingKeys: String, CodingTableKey {
            typealias Root = ConstraintObject
            case variable1
            case variable2
            nonisolated(unsafe) static let objectRelationalMapping = TableBinding(CodingKeys.self) {
                BindMultiUnique(variable1, variable2)
            }
        }
    }
    func testCreateTableWithConstraint() {
        // Give
        let tableName = ConstraintObject.name
        // When
        XCTAssertNoThrow(try database.create(table: tableName, of: ConstraintObject.self))
        // Then
        let optionalObject: Master? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: Master.builtinTableName, where: Master.Properties.name==tableName)
        )
        XCTAssertNotNil(optionalObject)
        let object = optionalObject!
        XCTAssertEqual(
            object.sql!,
            """
            CREATE TABLE \(tableName)\
            (variable1 INTEGER, variable2 INTEGER, \
            UNIQUE(variable1, variable2))
            """)
    }

    final class FTS3Object: TableCodable, Named {
        var id: Int32 = 0
        var content: String = ""

        enum CodingKeys: String, CodingTableKey {
            typealias Root = FTS3Object
            case id
            case content
            nonisolated(unsafe) static let objectRelationalMapping = TableBinding(CodingKeys.self) {
                BindColumnConstraint(id, isNotIndexed: true)
                BindVirtualTable(withModule: .FTS3, and: BuiltinTokenizer.OneOrBinary, BuiltinTokenizer.Parameter.NeedSymbol)
            }
        }
    }
    func testCreateFTS3VirtualTable() {
        // Give
        let tableName = FTS3Object.name
        database.add(tokenizer: BuiltinTokenizer.OneOrBinary)
        // When
        XCTAssertNoThrow(try database.create(virtualTable: tableName, of: FTS3Object.self))
        // Then
        let optionalObject: Master? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: Master.builtinTableName, where: Master.Properties.name==tableName)
        )
        XCTAssertNotNil(optionalObject)
        let object = optionalObject!
        XCTAssertEqual(
            object.sql!,
            """
            CREATE VIRTUAL TABLE FTS3Object USING fts3\
            (tokenize = WCDB need_symbol, id INTEGER, content TEXT, notindexed=id)
            """
        )
    }

    final class FTS5Object: TableCodable, Named {
        var id: Int32 = 0
        var content: String = ""

        enum CodingKeys: String, CodingTableKey {
            typealias Root = FTS5Object
            case id
            case content
            nonisolated(unsafe) static let objectRelationalMapping = TableBinding(CodingKeys.self) {
                BindColumnConstraint(id, isNotIndexed: true)
                BindVirtualTable(withModule: .FTS5,
                                 and: BuiltinTokenizer.Verbatim, BuiltinTokenizer.Parameter.SkipStemming,
                                 withExternalContent: "contentTable")
            }
        }
    }
    func testCreateFTS5VirtualTable() {
        // Give
        let tableName = FTS5Object.name
        database.add(tokenizer: BuiltinTokenizer.Verbatim)
        // When
        XCTAssertNoThrow(try database.create(virtualTable: tableName, of: FTS5Object.self))
        // Then
        let optionalObject: Master? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: Master.builtinTableName, where: Master.Properties.name==tableName)
        )
        XCTAssertNotNil(optionalObject)
        let object = optionalObject!
        XCTAssertEqual(
            object.sql!,
            """
            CREATE VIRTUAL TABLE FTS5Object USING fts5\
            (tokenize = 'wcdb_verbatim skip_stemming', content='contentTable', id UNINDEXED, content)
            """
        )
    }

    final class AutoFitBaseLineObject: TableCodable, Named {
        var anInt32: Int32 = -1
        var anInt64: Int64 = 17626545782784
        var aString: String = "string"
        var aData: Data = "data".data(using: .ascii)!
        var aDouble: Double = 0.001
        var newColumn: Int = 0

        var isAutoIncrement: Bool = false
        var lastInsertedRowID: Int64 = 0
        enum CodingKeys: String, CodingTableKey {
            typealias Root = AutoFitBaseLineObject
            case anInt32
            case anInt64
            case aString
            case aData
            case aDouble
            case newColumn
            nonisolated(unsafe) static let objectRelationalMapping = TableBinding(CodingKeys.self) {
                BindColumnConstraint(anInt32, isPrimary: true, orderBy: .ascending, isAutoIncrement: true)
            }
        }
    }
    func testCreateTableAutoFitORM() {
        // Give
        let tableName = AutoFitBaseLineObject.name
        XCTAssertNoThrow(try database.create(table: tableName, of: BaselineObject.self))
        // Then
        XCTAssertNoThrow(try database.create(table: tableName, of: AutoFitBaseLineObject.self))
        let optionalObject: Master? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: Master.builtinTableName, where: Master.Properties.name==tableName)
        )
        XCTAssertNotNil(optionalObject)
        let object = optionalObject!
        XCTAssertEqual(
            object.sql!,
            """
            CREATE TABLE \(tableName)\
            (anInt32 INTEGER PRIMARY KEY ASC AUTOINCREMENT, \
            anInt64 INTEGER, \
            aString TEXT, \
            aData BLOB, \
            aDouble REAL, \
            newColumn INTEGER)
            """
        )
    }

    func testDropTable() {
        // Give
        let tableName = BaselineObject.name
        // When
        XCTAssertNoThrow(try database.create(table: tableName, of: BaselineObject.self))
        XCTAssertNoThrow(try database.drop(table: tableName))
        // Then
        let optionalObject: Master? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: Master.builtinTableName, where: Master.Properties.name==tableName)
        )
        XCTAssertNil(optionalObject)
    }

    func testDropIndex() {
        // Give
        let tableName = IndexObject.name
        let indexName = tableName+"_index"
        // When
        XCTAssertNoThrow(try database.create(table: tableName, of: IndexObject.self))
        XCTAssertNoThrow(try database.drop(index: indexName))
        // Then
        let optionalObject: Master? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: Master.builtinTableName, where: Master.Properties.name==indexName)
        )
        XCTAssertNil(optionalObject)
    }

    func testManuallyCreateTable() {
        // Give
        let tableName = BaselineObject.name
        let tableConstraint = TableConstraint(named: "BaselineObjectConstraint")
        tableConstraint.check((BaselineObject.Properties.anInt32)>0)
        let def1 = (BaselineObject.Properties.anInt32).asDef(with: .integer32)
        let def2 = (BaselineObject.Properties.anInt64).asDef(with: .integer64)
        // When
        XCTAssertNoThrow(try database.create(table: tableName, with: def1, def2, and: [tableConstraint]))
        let optionalObject: Master? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: Master.builtinTableName, where: Master.Properties.name==tableName)
        )
        XCTAssertNotNil(optionalObject)
        let object = optionalObject!
        XCTAssertEqual(
            object.sql!,
            """
            CREATE TABLE \(tableName)\
            (anInt32 INTEGER, anInt64 INTEGER, \
            CONSTRAINT BaselineObjectConstraint CHECK(anInt32 > 0))
            """
        )
    }

    func testManuallyAddColumn() {
        // Give
        let tableName = BaselineObject.name
        let def = Column(named: "newColumn").asDef(with: .integer32)
        // When
        XCTAssertNoThrow(try database.create(table: tableName, of: BaselineObject.self))
        XCTAssertNoThrow(try database.addColumn(with: def, forTable: tableName))
        // Then
        let optionalObject: Master? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: Master.builtinTableName, where: Master.Properties.name==tableName)
        )
        XCTAssertNotNil(optionalObject)
        let object = optionalObject!
        XCTAssertEqual(
            object.sql!,
            """
            CREATE TABLE \(tableName)\
            (anInt32 INTEGER PRIMARY KEY ASC AUTOINCREMENT, \
            anInt64 INTEGER, \
            aString TEXT, \
            aData BLOB, \
            aDouble REAL, \
            newColumn INTEGER)
            """
        )
    }

    func testManuallyCreateIndex() {
        // Give
        let tableName = BaselineObject.name
        let indexName = tableName+"_index"
        let index1 = (BaselineObject.Properties.aString).asIndex()
        let index2 = (BaselineObject.Properties.aDouble).asIndex()
        // When
        XCTAssertNoThrow(try database.create(table: tableName, of: BaselineObject.self))
        XCTAssertNoThrow(try database.create(index: indexName, with: index1, index2, forTable: tableName))
        // Then
        let optionalObject: Master? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: Master.builtinTableName, where: Master.Properties.name==indexName)
        )
        XCTAssertNotNil(optionalObject)
        let object = optionalObject!
        XCTAssertEqual(object.sql!, "CREATE INDEX \(indexName) ON \(tableName)(aString, aDouble)")
    }
}
