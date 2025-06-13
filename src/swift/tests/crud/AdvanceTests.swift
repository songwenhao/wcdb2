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

class AdvanceTests: CRUDTestCase, @unchecked Sendable {

    func testHandleStatement() {
        let statement = StatementSelect().select(Column.all()).from(Master.builtinTableName)
        let handle = WCDBAssertNoThrowReturned(try database.getHandle())!

        WCDBAssertNoThrowReturned(try handle.prepare(statement))
        handle.finalize()
    }

    func testHandleStatementRead() {
        // Give
        let statement = StatementSelect().select(Column.all()).from(TestObject.name)
        let handle = WCDBAssertNoThrowReturned(try database.getHandle())!
        XCTAssertNoThrow(try handle.prepare(statement))

        let expectedVariable1: Int32 = 1
        let expectedVariable2 = "object1"
        // When
        XCTAssertNoThrow(try handle.step())
        // Then
        XCTAssertEqual(handle.columnCount(), 2)

        XCTAssertEqual(handle.columnName(atIndex: 0), "variable1")
        XCTAssertEqual(handle.columnName(atIndex: 1), "variable2")

        XCTAssertEqual(handle.columnTableName(atIndex: 0), TestObject.name)
        XCTAssertEqual(handle.columnTableName(atIndex: 1), TestObject.name)

        XCTAssertEqual(handle.index(byName: "variable1"), 0)
        XCTAssertEqual(handle.index(byName: "variable2"), 1)
        XCTAssertNil(handle.index(byName: "nonexistent"))

        XCTAssertEqual(handle.columnType(atIndex: 0), ColumnType.integer64)
        XCTAssertEqual(handle.columnType(atIndex: 1), ColumnType.text)
        XCTAssertEqual(handle.columnType(byName: "variable1"), ColumnType.integer64)
        XCTAssertEqual(handle.columnType(byName: "variable2"), ColumnType.text)
        XCTAssertEqual(handle.columnType(byName: "nonexistent"), ColumnType.null)

        do {
            let variable1: Int32? = handle.value(atIndex: 0)
            XCTAssertNotNil(variable1)
            XCTAssertEqual(variable1!, expectedVariable1)
            let variable2: String? = handle.value(atIndex: 1)
            XCTAssertNotNil(variable2)
            XCTAssertEqual(variable2!, expectedVariable2)
        }

        do {
            let variable1: Int32? = handle.value(byName: "variable1")
            XCTAssertNotNil(variable1)
            XCTAssertEqual(variable1!, expectedVariable1)
            let variable2: String? = handle.value(byName: "variable2")
            XCTAssertNotNil(variable2)
            XCTAssertEqual(variable2!, expectedVariable2)
            let nonexistent: Int32? = handle.value(byName: "nonexistent")
            XCTAssertNil(nonexistent)
        }

        handle.finalize()
    }

    func testHandleStatementWrite() {
        // Give
        let bindParameters = BindParameter.bindParameters(2)
        let statement = StatementInsert().insert(intoTable: TestObject.name).values(bindParameters)
        let handle = WCDBAssertNoThrowReturned(try database.getHandle())!
        XCTAssertNoThrow(try handle.prepare(statement))

        let expectedVariable1: Int32 = 3
        let expectedVariable2 = "object3"
        // When
        handle.bind(nil, toIndex: 1)
        handle.bind(expectedVariable2, toIndex: 2)
        XCTAssertNoThrow(try handle.step())
        // Then
        XCTAssertEqual(handle.lastInsertedRowID, 3)
        XCTAssertEqual(handle.changes, 1)
        // When
        handle.reset()
        let expectedObject = TestObject()
        expectedObject.variable1 = 4
        expectedObject.variable2 = "object4"
        XCTAssertNoThrow(try handle.bind([TestObject.Properties.variable1], of: expectedObject))
        XCTAssertNoThrow(try handle.bind(TestObject.Properties.variable2, of: expectedObject, toIndex: 2))
        XCTAssertNoThrow(try handle.step())

        handle.finalize()
        // Then
        do {
            let condition = TestObject.Properties.variable1 == expectedVariable1
            let result: TestObject? = WCDBAssertNoThrowReturned(
                try database.getObject(fromTable: TestObject.name, where: condition)
            )
            XCTAssertNotNil(result)
            XCTAssertEqual(result!.variable2, expectedVariable2)
        }
        do {
            let condition = TestObject.Properties.variable1 == expectedObject.variable1!
            let result: TestObject? = WCDBAssertNoThrowReturned(
                try database.getObject(fromTable: TestObject.name, where: condition)
            )
            XCTAssertNotNil(result)
            XCTAssertEqual(result!, expectedObject)
        }
    }

    final class HandleStatementTypedObject: TableCodable, Named {
        var int32: Int32 = 1
        var int64: Int64 = 2
        var double: Double = 3.0
        var string: String = "4"
        var data: Data = "5".data(using: .ascii)!
        enum CodingKeys: String, CodingTableKey {
            typealias Root = HandleStatementTypedObject
            case int32
            case int64
            case double
            case string
            case data
            nonisolated(unsafe) static let objectRelationalMapping = TableBinding(CodingKeys.self)
        }
    }

    func testHandleStatementType() {
        let tableName = HandleStatementTypedObject.name

        XCTAssertNoThrow(try database.create(table: tableName, of: HandleStatementTypedObject.self))
        XCTAssertNoThrow(try database.insert(HandleStatementTypedObject(), intoTable: tableName))

        let statement = StatementSelect().select(Column.all()).from(tableName)
        let handle = WCDBAssertNoThrowReturned(try database.getHandle())!
        XCTAssertNoThrow(try handle.prepare(statement))
        XCTAssertNoThrow(try handle.step())

        do {
            let v1: Int32? = handle.value(atIndex: 0)
            XCTAssertNotNil(v1)
            XCTAssertEqual(v1!, 1)

            let v2: Int64? = handle.value(atIndex: 1)
            XCTAssertNotNil(v2)
            XCTAssertEqual(v2!, 2)

            let v3: Double? = handle.value(atIndex: 2)
            XCTAssertNotNil(v3)
            XCTAssertEqual(v3!, 3.0)

            let v4: String? = handle.value(atIndex: 3)
            XCTAssertNotNil(v4)
            XCTAssertEqual(v4!, "4")

            let v5: Data? = handle.value(atIndex: 4)
            XCTAssertNotNil(v5)
            XCTAssertEqual(v5!, "5".data(using: .ascii)!)

            let v6: Data? = handle.value(atIndex: 5)
            XCTAssertNil(v6)
        }
        do {
            let v1: Value = handle.value(atIndex: 0)
            XCTAssertEqual(v1.int32Value, 1)

            let v2: Value = handle.value(atIndex: 1)
            XCTAssertEqual(v2.int64Value, 2)

            let v3: Value = handle.value(atIndex: 2)
            XCTAssertEqual(v3.doubleValue, 3.0)

            let v4: Value = handle.value(atIndex: 3)
            XCTAssertEqual(v4.stringValue, "4")

            let v5: Value = handle.value(atIndex: 4)
            XCTAssertEqual(v5.dataValue, "5".data(using: .ascii)!)

            let v6: Value = handle.value(atIndex: 5)
            XCTAssertEqual(v6.type, .null)
        }
        handle.finalize()
    }

    func testFundamentalValue() {
        // Give
        let int32Value: Int32 = 1
        let int32FundamentalValue = Value(int32Value)
        XCTAssertEqual(int32FundamentalValue.int32Value, 1)
        XCTAssertEqual(int32FundamentalValue.int64Value, 1)
        XCTAssertEqual(int32FundamentalValue.doubleValue, 1.0)
        XCTAssertEqual(int32FundamentalValue.stringValue, "1")
        XCTAssertEqual(int32FundamentalValue.dataValue, "1".data(using: .ascii)!)
        XCTAssertEqual(int32FundamentalValue.type, .integer32)

        let int64Value: Int64 = 2
        let int64FundamentalValue = Value(int64Value)
        XCTAssertEqual(int64FundamentalValue.int32Value, 2)
        XCTAssertEqual(int64FundamentalValue.int64Value, 2)
        XCTAssertEqual(int64FundamentalValue.doubleValue, 2.0)
        XCTAssertEqual(int64FundamentalValue.stringValue, "2")
        XCTAssertEqual(int64FundamentalValue.dataValue, "2".data(using: .ascii)!)
        XCTAssertEqual(int64FundamentalValue.type, .integer64)

        let doubleValue: Double = 3.0
        let doubleFundamentalValue = Value(doubleValue)
        XCTAssertEqual(doubleFundamentalValue.int32Value, 3)
        XCTAssertEqual(doubleFundamentalValue.int64Value, 3)
        XCTAssertEqual(doubleFundamentalValue.doubleValue, 3.0)
        XCTAssertEqual(doubleFundamentalValue.stringValue, "3.0")
        XCTAssertEqual(doubleFundamentalValue.dataValue, "3.0".data(using: .ascii)!)
        XCTAssertEqual(doubleFundamentalValue.type, .float)

        let stringValue: String = "4"
        let stringFundamentalValue = Value(stringValue)
        XCTAssertEqual(stringFundamentalValue.int32Value, 4)
        XCTAssertEqual(stringFundamentalValue.int64Value, 4)
        XCTAssertEqual(stringFundamentalValue.doubleValue, 4.0)
        XCTAssertEqual(stringFundamentalValue.stringValue, "4")
        XCTAssertEqual(stringFundamentalValue.dataValue, "4".data(using: .ascii)!)
        XCTAssertEqual(stringFundamentalValue.type, .text)

        let dataValue: Data = "5".data(using: .ascii)!
        let dataFundamentalValue = Value(dataValue)
        XCTAssertEqual(dataFundamentalValue.int32Value, 0)
        XCTAssertEqual(dataFundamentalValue.int64Value, 0)
        XCTAssertEqual(dataFundamentalValue.doubleValue, 0)
        XCTAssertEqual(dataFundamentalValue.stringValue, "5")
        XCTAssertEqual(dataFundamentalValue.dataValue, "5".data(using: .ascii)!)
        XCTAssertEqual(dataFundamentalValue.type, .BLOB)

        let nullFundamentalValue = Value(nil)
        XCTAssertEqual(nullFundamentalValue.int32Value, 0)
        XCTAssertEqual(nullFundamentalValue.int64Value, 0)
        XCTAssertEqual(nullFundamentalValue.doubleValue, 0)
        XCTAssertEqual(nullFundamentalValue.stringValue, "")
        XCTAssertEqual(nullFundamentalValue.dataValue, "".data(using: .ascii)!)
        XCTAssertEqual(nullFundamentalValue.type, .null)
    }

    func testStepFailed() {
        // Give
        let bindParameters = BindParameter.bindParameters(2)
        let statement = StatementInsert().insert(intoTable: TestObject.name).values(bindParameters)
        let handle = WCDBAssertNoThrowReturned(try database.getHandle())!
        XCTAssertNoThrow(try handle.prepare(statement))

        let expectedVariable2 = "object3"
        // When
        handle.bind(nil, toIndex: 1)
        handle.bind(expectedVariable2, toIndex: 2)
        XCTAssertNoThrow(try handle.step())
        XCTAssertNoThrow(try handle.step())
        handle.finalize()
    }

    func testExecFailed() {
        let statement = StatementSelect().select(Column.all()).from("nonexistentTable")
        XCTAssertThrowsError(try database.exec(statement))
    }

    func testCipher() {
        // Give
        XCTAssertNoThrow(try database.close {
            try self.database.removeFiles()
        })
        let password = "password".data(using: .ascii)!
        let wrongPassword = "wrongPassword".data(using: .ascii)!
        // When
        database.setCipher(key: password)
        XCTAssertNoThrow(try database.create(table: TestObject.name, of: TestObject.self))
        // Then
        database.close()
        database.setCipher(key: wrongPassword)
        XCTAssertThrowsError(try database.isTableExists(TestObject.name))

        database.close()
        database.setCipher(key: nil)
        XCTAssertThrowsError(try database.isTableExists(TestObject.name))

        database.close()
        database.setCipher(key: password)
        let exists = WCDBAssertNoThrowReturned(try database.isTableExists(TestObject.name))
        XCTAssertNotNil(exists)
        XCTAssertTrue(exists!)
    }

    func testCipherFailed() {
        // Give
        XCTAssertNoThrow(try database.close {
            try self.database.removeFiles()
            })
        let emptyPassword = Data()
        // When
        database.setCipher(key: emptyPassword)
        XCTAssertFalse(database.canOpen)
    }

    func testConfig() {
        // Then
        do {
            let handle = WCDBAssertNoThrowReturned(try database.getHandle())!
            XCTAssertNoThrow(try handle.prepare(StatementPragma().pragma(.secureDelete)))
            XCTAssertNoThrow(try handle.step())
            let isSecureDelete: Int32? = handle.value(atIndex: 0)
            XCTAssertNotNil(isSecureDelete)
            XCTAssertEqual(isSecureDelete!, 0)
            handle.finalize()
        }
        // Give
        database.close()
        database.setConfig(named: "SecureDelete") { (handle) throws in
            let statement = StatementPragma().pragma(.secureDelete).to(true)
            try handle.exec(statement)
        }
        // When
        XCTAssertTrue(database.canOpen)
        // Then
        do {
            let handle = WCDBAssertNoThrowReturned(try database.getHandle())!
            XCTAssertNoThrow(try handle.prepare(StatementPragma().pragma(.secureDelete)))
            XCTAssertNoThrow(try handle.step())
            let isSecureDelete: Int32? = handle.value(atIndex: 0)
            XCTAssertNotNil(isSecureDelete)
            XCTAssertEqual(isSecureDelete!, 1)
            handle.finalize()
        }
    }

    func testDefaultCipherConfiguration() {
        // Give
        XCTAssertNoThrow(try database.close {
            try self.database.removeFiles()
        })
        let password = "password".data(using: .ascii)!
        let pageSize = 4096
        // When
        database.setCipher(key: password, pageSize: pageSize, cipherVersion: .version3)
        // Then
        XCTAssertTrue(database.canOpen)

        // When
        database.close()
        database.setCipher(key: password, pageSize: pageSize)
        // Then
        XCTAssertFalse(database.canOpen)

        // When
        Database.setDefaultCipherConfiguration(.version3)
        // Then
        XCTAssertTrue(database.canOpen)

        XCTAssertNoThrow(try database.removeFiles())
        database.setCipher(key: password, pageSize: pageSize, cipherVersion: .version4)
        // Then
        XCTAssertTrue(database.canOpen)

        // When
        database.close()
        database.setCipher(key: password, pageSize: pageSize)
        // Then
        XCTAssertFalse(database.canOpen)
        // When
        Database.setDefaultCipherConfiguration(.version4)
        // Then
        XCTAssertTrue(database.canOpen)
    }

    func testOrderedConfig() {
        // Then
        do {
            let handle = WCDBAssertNoThrowReturned(try database.getHandle())!
            XCTAssertNoThrow(try handle.prepare(StatementPragma().pragma(.secureDelete)))
            XCTAssertNoThrow(try handle.step())
            let isSecureDelete: Int32? = handle.value(atIndex: 0)
            XCTAssertNotNil(isSecureDelete)
            XCTAssertEqual(isSecureDelete!, 0)
            handle.finalize()
        }
        // Give
        database.close()
        database.setConfig(named: "SecureDelete", withInvocation: { (handle) throws in
            let statement = StatementPragma().pragma(.secureDelete).to(true)
            try handle.exec(statement)
        }, withPriority: .high)
        var tested = false
        database.setConfig(named: "test") { (handle) throws in
            XCTAssertNoThrow(try handle.prepare(StatementPragma().pragma(.secureDelete)))
            XCTAssertNoThrow(try handle.step())
            let isSecureDelete: Int32 = handle.columnValue(atIndex: 0)
            XCTAssertEqual(isSecureDelete, 1)
            handle.finalize()

            tested = true
        }
        // When
        XCTAssertTrue(database.canOpen)
        XCTAssertTrue(tested)
    }

    func testConfigChangeOrder() {
        // Give
        database.close()
        database.setConfig(named: "SecureDelete", withInvocation: { (_) throws in
            XCTFail("should not reach")
        })
        var tested = false
        database.setConfig(named: "test", withInvocation: { (handle) throws in
            // Then
            XCTAssertNoThrow(try handle.prepare(StatementPragma().pragma(.secureDelete)))
            XCTAssertNoThrow(try handle.step())
            let isSecureDelete: Int32 = handle.columnValue(atIndex: 0)
            XCTAssertEqual(isSecureDelete, 0)
            handle.finalize()

            tested = true
        }, withPriority: .high)
        database.setConfig(named: "SecureDelete", withInvocation: { (handle) throws in
            let statement = StatementPragma().pragma(.secureDelete).to(true)
            try handle.exec(statement)
        }, withPriority: .high)
        // When
        XCTAssertTrue(database.canOpen)
        XCTAssertTrue(tested)
    }

    func testConfigFailed() {
        // Give
        database.close()
        database.setConfig(named: "testConfigFailed", withInvocation: { (handle) throws in
            try handle.exec(StatementSelect().select(Column.all()).from("nonexistentTable"))
        })
        // When
        XCTAssertFalse(database.canOpen)
    }

    func testRedirect() {
        let property = TestObject.Properties.any.count().as(TestObject.Properties.variable1)
        let optionalObject: TestObject? = WCDBAssertNoThrowReturned(
            try database.getObject(on: property, fromTable: TestObject.name)
        )
        XCTAssertNotNil(optionalObject)
        XCTAssertEqual(optionalObject!.variable1, preInsertedObjects.count)
    }

    func testRedirectCodingKey() {
        let property = TestObject.Properties.variable1.as(TestObject.Properties.variable1)
        let optionalObject: TestObject? = WCDBAssertNoThrowReturned(
            try database.getObject(on: property, fromTable: TestObject.name)
        )
        XCTAssertNotNil(optionalObject)
        XCTAssertEqual(optionalObject!.variable1, preInsertedObjects[0].variable1)
    }

    var identifier = 0
    var pauseTimes = -1
    func testPausableTransaction() {
        XCTAssertNoThrow(try database.drop(table: TestObject.name))
        XCTAssertNoThrow(try database.create(table: TestObject.name, of: TestObject.self))

        let group = DispatchGroup()
        let queue = DispatchQueue(label: String(recommendTag), attributes: .concurrent)
        queue.async(group: group, execute: {
            var i = 0
            var write1Begin = Date()
            let transaction: TransactionInterface.PausableTransactionClosure = { handle, stop, isNewTransaction in
                XCTAssertTrue(handle.isInTransaction)
                if isNewTransaction {
                    self.pauseTimes += 1
                }
                let beginInterval = Date().timeIntervalSince(write1Begin)
                XCTAssertTrue(beginInterval < 1)

                let handleStatement = WCDBAssertNoThrowReturned(try handle.getOrCreatePreparedStatement(with: StatementInsert().insert(intoTable: TestObject.name).columns(TestObject.Properties.all).values(BindParameter.bindParameters(TestObject.Properties.all.count))))
                handleStatement!.reset()

                self.identifier += 1
                let obj = TestObject()
                obj.variable1 = self.identifier
                obj.variable2 = "testObject"
                XCTAssertNoThrow(try handleStatement!.bind(TestObject.Properties.all, of: obj))
                XCTAssertNoThrow(try handleStatement!.step())

                Thread.sleep(forTimeInterval: 0.1)
                i += 1
                stop = i > 30
                write1Begin = Date()
            }
            do {
                return try self.database.run(pausableTransaction: transaction)
            } catch let error as WCDBError {
                XCTFail(error.description)
            } catch {
                XCTFail(error.localizedDescription)
            }
        })
        Thread.sleep(forTimeInterval: 0.5)
        var i = 0
        var write2Begin = Date()
        repeat {
            write2Begin = Date()
            XCTAssertNoThrow(try self.database.begin())
            XCTAssertTrue(self.database.isInTransaction)
            let beginInterval = Date().timeIntervalSince(write2Begin)
            XCTAssertTrue(beginInterval < 1)
            identifier += 1
            let obj = TestObject()
            obj.variable1 = identifier
            obj.variable2 = "testObject"
            XCTAssertNoThrow(try self.database.insert(obj, intoTable: TestObject.name))
            Thread.sleep(forTimeInterval: 0.1)
            XCTAssertNoThrow(try self.database.commit())
            i += 1
        } while(i < 10)
        group.wait()
        let count = WCDBAssertNoThrowReturned(try self.database.getValue(on: TestObject.Properties.any.count(), fromTable: TestObject.name))!
        XCTAssertTrue(count.int32Value == identifier)
        XCTAssertTrue(pauseTimes > 1)
    }

    final class FTS3Object: TestObjectBase, TableCodable {
        var variable1: Int = 0
        var variable2: String = ""

        enum CodingKeys: String, CodingTableKey {
            typealias Root = FTS3Object
            case variable1
            case variable2
            nonisolated(unsafe) static let objectRelationalMapping = TableBinding(CodingKeys.self) {
                BindVirtualTable(withModule: .FTS3, and: BuiltinTokenizer.OneOrBinary)
            }
        }

        override var hashValue: Int {
            return (String(variable1)+variable2).hashValue
        }
    }
    func testFTS3() {
        // Give
        XCTAssertNoThrow(try database.close {
            try self.database.removeFiles()
        })
        database.add(tokenizer: BuiltinTokenizer.OneOrBinary)
        XCTAssertNoThrow(try database.create(virtualTable: FTS3Object.name, of: FTS3Object.self))

        let preInsertedEnglishFTS3Object: FTS3Object = {
            let object = FTS3Object()
            object.variable1 = 1
            object.variable2 = "This is English test content"
            return object
        }()
        let preInsertedChineseFTS3Object: FTS3Object = {
            let object = FTS3Object()
            object.variable1 = 2
            object.variable2 = "这是中文测试内容"
            return object
        }()
        let preInsertedNumbericFTS3Object: FTS3Object = {
            let object = FTS3Object()
            object.variable1 = 1
            object.variable2 = "123456"
            return object
        }()
        let preInsertedSymbolicFTS3Object: FTS3Object = {
            let object = FTS3Object()
            object.variable1 = 1
            object.variable2 = "abc..def"
            return object
        }()
        let objects = [preInsertedEnglishFTS3Object,
                       preInsertedChineseFTS3Object,
                       preInsertedNumbericFTS3Object,
                       preInsertedSymbolicFTS3Object]
        XCTAssertNoThrow(try database.insert(objects, intoTable: FTS3Object.name))

        // English
        do {
            // When
            let condition = FTS3Object.Properties.variable2.match("Engl*")
            let objects = WCDBAssertNoThrowReturned(
                try database.getObjects(fromTable: FTS3Object.name, where: condition),
                whenFailed: [FTS3Object]()
            )
            // Then
            XCTAssertEqual(objects.count, 1)
            XCTAssertEqual(objects[0], preInsertedEnglishFTS3Object)
        }
        // Chinese
        do {
            // When
            let condition = FTS3Object.Properties.variable2.match("中文*")
            let objects = WCDBAssertNoThrowReturned(
                try database.getObjects(fromTable: FTS3Object.name, where: condition),
                whenFailed: [FTS3Object]()
            )
            // Then
            XCTAssertEqual(objects.count, 1)
            XCTAssertEqual(objects[0], preInsertedChineseFTS3Object)
        }
        // Numberic
        do {
            // When
            let condition = FTS3Object.Properties.variable2.match("123*")
            let objects = WCDBAssertNoThrowReturned(
                try database.getObjects(fromTable: FTS3Object.name, where: condition),
                whenFailed: [FTS3Object]()
            )
            // Then
            XCTAssertEqual(objects.count, 1)
            XCTAssertEqual(objects[0], preInsertedNumbericFTS3Object)
        }
        // Symbolic
        do {
            // When
            let condition = FTS3Object.Properties.variable2.match("def")
            let objects = WCDBAssertNoThrowReturned(
                try database.getObjects(fromTable: FTS3Object.name, where: condition),
                whenFailed: [FTS3Object]()
            )
            // Then
            XCTAssertEqual(objects.count, 1)
            XCTAssertEqual(objects[0], preInsertedSymbolicFTS3Object)
        }

        // Find Chinese
        do {
            // When
            let condition = FTS3Object.Properties.variable2.match("文测")
            let objects = WCDBAssertNoThrowReturned(
                try database.getObjects(fromTable: FTS3Object.name, where: condition),
                whenFailed: [FTS3Object]()
            )
            // Then
            XCTAssertEqual(objects.count, 1)
            XCTAssertEqual(objects[0], preInsertedChineseFTS3Object)
        }
    }

    final class FTS5Object: TestObjectBase, TableCodable {
        var variable1: Int = 0
        var variable2: String = ""

        enum CodingKeys: String, CodingTableKey {
            typealias Root = FTS5Object
            case variable1
            case variable2
            nonisolated(unsafe) static let objectRelationalMapping = TableBinding(CodingKeys.self) {
                BindVirtualTable(withModule: .FTS5, and: BuiltinTokenizer.Verbatim)
            }
        }

        override var hashValue: Int {
            return (String(variable1)+variable2).hashValue
        }
    }
    func testFTS5() {
        // Give
        XCTAssertNoThrow(try database.close {
            try self.database.removeFiles()
        })
        database.add(tokenizer: BuiltinTokenizer.Verbatim)
        XCTAssertNoThrow(try database.create(virtualTable: FTS5Object.name, of: FTS5Object.self))

        let preInsertedEnglishFTS5Object: FTS5Object = {
            let object = FTS5Object()
            object.variable1 = 1
            object.variable2 = "This is English test content"
            return object
        }()
        let preInsertedChineseFTS5Object: FTS5Object = {
            let object = FTS5Object()
            object.variable1 = 2
            object.variable2 = "这是中文测试内容"
            return object
        }()
        let preInsertedNumbericFTS5Object: FTS5Object = {
            let object = FTS5Object()
            object.variable1 = 1
            object.variable2 = "123456"
            return object
        }()
        let preInsertedSymbolicFTS5Object: FTS5Object = {
            let object = FTS5Object()
            object.variable1 = 1
            object.variable2 = "abc..def"
            return object
        }()
        let objects = [preInsertedEnglishFTS5Object,
                       preInsertedChineseFTS5Object,
                       preInsertedNumbericFTS5Object,
                       preInsertedSymbolicFTS5Object]
        XCTAssertNoThrow(try database.insert(objects, intoTable: FTS5Object.name))

        // English
        do {
            // When
            let condition = FTS5Object.Properties.variable2.match("Engl*")
            let objects = WCDBAssertNoThrowReturned(
                try database.getObjects(fromTable: FTS5Object.name, where: condition),
                whenFailed: [FTS5Object]()
            )
            // Then
            XCTAssertEqual(objects.count, 1)
            XCTAssertEqual(objects[0], preInsertedEnglishFTS5Object)
        }
        // Chinese
        do {
            // When
            let condition = FTS5Object.Properties.variable2.match("中文*")
            let objects = WCDBAssertNoThrowReturned(
                try database.getObjects(fromTable: FTS5Object.name, where: condition),
                whenFailed: [FTS5Object]()
            )
            // Then
            XCTAssertEqual(objects.count, 1)
            XCTAssertEqual(objects[0], preInsertedChineseFTS5Object)
        }
        // Numberic
        do {
            // When
            let condition = FTS5Object.Properties.variable2.match("123*")
            let objects = WCDBAssertNoThrowReturned(
                try database.getObjects(fromTable: FTS5Object.name, where: condition),
                whenFailed: [FTS5Object]()
            )
            // Then
            XCTAssertEqual(objects.count, 1)
            XCTAssertEqual(objects[0], preInsertedNumbericFTS5Object)
        }
        // Symbolic
        do {
            // When
            let condition = FTS5Object.Properties.variable2.match("def")
            let objects = WCDBAssertNoThrowReturned(
                try database.getObjects(fromTable: FTS5Object.name, where: condition),
                whenFailed: [FTS5Object]()
            )
            // Then
            XCTAssertEqual(objects.count, 1)
            XCTAssertEqual(objects[0], preInsertedSymbolicFTS5Object)
        }

        // Find Chinese
        do {
            // When
            let condition = FTS5Object.Properties.variable2.match("文测")
            let objects = WCDBAssertNoThrowReturned(
                try database.getObjects(fromTable: FTS5Object.name, where: condition),
                whenFailed: [FTS5Object]()
            )
            // Then
            XCTAssertEqual(objects.count, 1)
            XCTAssertEqual(objects[0], preInsertedChineseFTS5Object)
        }
    }

    final class PinyinObject: TableCodable {
        var content: String = ""

        enum CodingKeys: String, CodingTableKey {
            typealias Root = PinyinObject
            case content
            nonisolated(unsafe) static let objectRelationalMapping = TableBinding(CodingKeys.self) {
                BindVirtualTable(withModule: .FTS5, and: BuiltinTokenizer.Pinyin)
            }
        }
    }

    func testPinyin() {
        Database.config(pinyinDict: [
            "单": [ "shan", "dan", "chan" ],
            "于": [ "yu" ],
            "骑": [ "qi" ],
            "模": [ "mo", "mu" ],
            "具": [ "ju" ],
            "车": [ "che" ]
        ])
        database.add(tokenizer: BuiltinTokenizer.Pinyin)
        XCTAssertNoThrow(try database.create(virtualTable: "pinyinTable", of: PinyinObject.self))

        let obj = PinyinObject()
        obj.content = "单于骑模具单车"
        XCTAssertNoThrow(try database.insert(obj, intoTable: "pinyinTable"))

        let querys = [
            "\"shan yu qi mu ju dan che\"",
            "\"chan yu qi mo ju shan che\"",
            "\"dan yu qi mo ju chan che\"",
            "\"dan yu qi mu ju ch\"*",
            "\"dan yu qi mo ju d\"*",
            "\"s y q m j d c\"",
            "\"c y q m j s c\"",
            "\"c y q m j\""
        ]

        for query in querys {
            let objs: [PinyinObject] = WCDBAssertNoThrowReturned(try database.getObjects(fromTable: "pinyinTable", where: PinyinObject.Properties.content.match(query)))
            XCTAssertEqual(objs.count, 1)
            XCTAssertEqual(objs[0].content, obj.content)
        }
    }

    final class TraditionalChineseObject: TableCodable {
        var content: String = ""

        enum CodingKeys: String, CodingTableKey {
            typealias Root = TraditionalChineseObject
            case content
            nonisolated(unsafe) static let objectRelationalMapping = TableBinding(CodingKeys.self) {
                BindVirtualTable(withModule: .FTS5, and: BuiltinTokenizer.Verbatim, BuiltinTokenizer.Parameter.SimplifyChinese)
            }
        }
    }

    func testTraditionalChinese() {
        Database.config(traditionalChineseDict: [
            "們": "们",
            "員": "员"
        ])
        database.add(tokenizer: BuiltinTokenizer.Verbatim)
        XCTAssertNoThrow(try database.create(virtualTable: "traditionalChineseTable", of: TraditionalChineseObject.self))

        let obj = TraditionalChineseObject()
        obj.content = "我們是程序員"
        XCTAssertNoThrow(try database.insert(obj, intoTable: "traditionalChineseTable"))

        let matchObjects1: [TraditionalChineseObject] = WCDBAssertNoThrowReturned(try database.getObjects(fromTable: "traditionalChineseTable", where: TraditionalChineseObject.Properties.content.match("我們是程序員")))
        XCTAssertEqual(matchObjects1.count, 1)
        XCTAssertEqual(matchObjects1[0].content, obj.content)

        let matchObjects2: [TraditionalChineseObject] = WCDBAssertNoThrowReturned(try database.getObjects(fromTable: "traditionalChineseTable", where: TraditionalChineseObject.Properties.content.match("我们是程序员")))
        XCTAssertEqual(matchObjects2.count, 1)
        XCTAssertEqual(matchObjects2[0].content, obj.content)
    }

    func testMigration() {
        let oldObject1 = TestObject()
        oldObject1.variable1 = 1
        oldObject1.variable2 = "oldContent1"
        let oldObject2 = TestObject()
        oldObject2.variable1 = 2
        oldObject2.variable2 = "oldContent2"
        let oldObject3 = TestObject()
        oldObject3.variable1 = 3
        oldObject3.variable2 = "oldContent3"

        let sourceCipher = Random.data(withLength: 100)
        let targetCipher = Random.data(withLength: 100, andSeed: 1)

        let sourceDatabase = Database(at: recommendedDirectory.appendingPathComponent("sourceDB.sqlite3"))
        sourceDatabase.setCipher(key: sourceCipher)

        let sourceTableName = "sourceTable"
        XCTAssertNoThrow(try sourceDatabase.create(table: sourceTableName, of: TestObject.self))
        let sourceTable = sourceDatabase.getTable(named: sourceTableName, of: TestObject.self)

        XCTAssertNoThrow(try sourceTable.insert(oldObject1, oldObject2, oldObject3))

        let targetDatabase = Database(at: recommendedDirectory.appendingPathComponent("targetDB.sqlite3"))
        targetDatabase.setCipher(key: targetCipher)
        let targetTableName = "targetTable"

        targetDatabase.addMigration(sourcePath: sourceDatabase.path, sourceCipher: sourceCipher) { info in
            if info.table == targetTableName {
                info.sourceTable = sourceTableName
                info.filterCondition = TestObject.Properties.variable1 > 2
            }
        }

        XCTAssertNoThrow(try targetDatabase.create(table: targetTableName, of: TestObject.self))
        let targetTable = targetDatabase.getTable(named: targetTableName, of: TestObject.self)

        XCTAssertEqual(try? targetTable.getValue(on: Column.all().count()).int64Value, 1)

        XCTAssertNoThrow(try targetTable.delete(where: TestObject.Properties.variable1 == 2))
        XCTAssertEqual(try? sourceTable.getValue(on: Column.all().count()).int64Value, 3)

        XCTAssertNoThrow(try targetTable.update(on: TestObject.Properties.variable2, with: ["newContent"], where: TestObject.Properties.variable1 == 3))

        XCTAssertEqual(try? targetTable.getValue(on: TestObject.Properties.variable2, where: TestObject.Properties.variable1 == 3).stringValue, "newContent")

        XCTAssertNoThrow(try targetTable.delete(where: TestObject.Properties.variable1 == 3))
        XCTAssertEqual(try? sourceTable.getValue(on: Column.all().count()).int64Value, 2)
        XCTAssertEqual(try? targetTable.getValue(on: Column.all().count()).int64Value, 0)

        let newObject = TestObject()
        newObject.variable1 = 4
        newObject.variable2 = "d"
        XCTAssertNoThrow(try targetTable.insert(newObject))

        let dbNewObject = WCDBAssertNoThrowReturned(try targetTable.getObject(on: TestObject.Properties.all, where: TestObject.Properties.variable1 == 4))
        XCTAssertTrue(dbNewObject != nil && dbNewObject!.variable2 == "d")
        XCTAssertEqual(try? sourceTable.getValue(on: Column.all().count()).int64Value, 2)
        XCTAssertEqual(try? targetTable.getValue(on: Column.all().count()).int64Value, 1)

        targetDatabase.close()
        XCTAssertEqual(targetDatabase.isMigrated(), false)

        var migratedTable: String?
        targetDatabase.setNotificationWhenMigrated { _, info in
            if let sourceTable = info?.sourceTable {
                migratedTable = sourceTable
            }
        }

        repeat {
            XCTAssertNoThrow(try targetDatabase.stepMigration())
        } while !targetDatabase.isMigrated()

        XCTAssertEqual(targetDatabase.isMigrated(), true)

        XCTAssertEqual(migratedTable ?? "", sourceTableName)
    }

    func testDefaultTemporaryDirectory() {
        XCTAssertFalse(Database.setDefaultTemporaryDirectory("wrongDir"))

        let tempDir = NSTemporaryDirectory().appending("/dbTempDir")
        XCTAssertTrue(Database.setDefaultTemporaryDirectory(tempDir))

        let getDirStatement = StatementPragma().pragma(Pragma(named: "temp_store_directory"))
        var dir = WCDBAssertNoThrowReturned(try database.getValue(from: getDirStatement))
        XCTAssertTrue(dir != nil && dir!.stringValue == tempDir)

        XCTAssertTrue(Database.setDefaultTemporaryDirectory(""))
        dir = WCDBAssertNoThrowReturned(try database.getValue(from: getDirStatement))
        XCTAssertTrue(dir != nil && dir!.stringValue == "")
    }

    func testNormalCompress() {
        Random.useEnglishString = true
        XCTAssertNoThrow(try table.delete())
        var preInsertObjects = Random.testObjects(startWith: 1, count: 2)
        XCTAssertNoThrow(try table.insert(preInsertObjects))

        database.setCompression { info in
            info.addZSTDNormalCompress(to: TestObject.Properties.variable2)
        }
        var tableCompressed = false
        var databaseCompressed = false
        database.setNotificationWhenCompressed { database, table in
            XCTAssertEqual(database.tag, self.database.tag)
            XCTAssertEqual(database.path, self.database.path)
            if let table = table {
                if table == self.table.name {
                    tableCompressed = true
                }
            } else {
                databaseCompressed = true
            }
        }

        XCTAssertFalse(database.isCompressed())
        XCTAssertNoThrow(try database.stepCompression())
        XCTAssertNoThrow(try database.stepCompression())
        XCTAssertTrue(database.isCompressed())
        XCTAssertTrue(tableCompressed && databaseCompressed)

        let newInsertObjects = Random.testObjects(startWith: 3, count: 2)
        XCTAssertNoThrow(try table.insert(newInsertObjects))

        let count = WCDBAssertNoThrowReturned(try database.getValue(from: StatementSelect().select(Column.all().count()).from(table.name).where(Column(named: "WCDB_CT_variable2") == 4)))
        XCTAssertTrue(count != nil && count!.intValue == 4)

        preInsertObjects.append(contentsOf: newInsertObjects)

        let allObjects = WCDBAssertNoThrowReturned(try table.getObjects())
        XCTAssertTrue(allObjects.elementsEqual(preInsertObjects))
        Random.useEnglishString = false
    }

    func testDictCompress() {
        Random.useEnglishString = true
        XCTAssertNoThrow(try table.delete())
        var preInsertObjects = Random.testObjects(startWith: 1, count: 2)
        XCTAssertNoThrow(try table.insert(preInsertObjects))

        var samples: [Data] = []
        for _ in 0..<1000 {
            samples.append(Random.englishString(withLength: 100).data(using: .utf8) ?? Data())
        }
        let dict = WCDBAssertNoThrowReturned(try Database.trainDict(with: samples, and: 1))
        XCTAssertNotNil(dict)
        XCTAssertNoThrow(try Database.register(dict: dict!, with: 1))

        database.setCompression { info in
            info.addZSTDDictCompress(to: TestObject.Properties.variable2, withDict: 1)
        }

        XCTAssertFalse(database.isCompressed())
        XCTAssertNoThrow(try database.stepCompression())
        XCTAssertNoThrow(try database.stepCompression())
        XCTAssertTrue(database.isCompressed())

        let newInsertObjects = Random.testObjects(startWith: 3, count: 2)
        XCTAssertNoThrow(try table.insert(newInsertObjects))

        let count = WCDBAssertNoThrowReturned(try database.getValue(from: StatementSelect().select(Column.all().count()).from(table.name).where(Column(named: "WCDB_CT_variable2") == 2)))
        XCTAssertTrue(count != nil && count!.intValue == 4)

        preInsertObjects.append(contentsOf: newInsertObjects)

        let allObjects = WCDBAssertNoThrowReturned(try table.getObjects())
        XCTAssertTrue(allObjects.elementsEqual(preInsertObjects))
        Random.useEnglishString = false
    }

    func testMultiDictCompress() {
        Random.useEnglishString = true
        XCTAssertNoThrow(try table.delete())
        var preInsertObjects = Random.testObjects(startWith: 1, count: 2)
        XCTAssertNoThrow(try table.insert(preInsertObjects))

        var samples: [String] = []
        for _ in 0..<1000 {
            samples.append(Random.englishString(withLength: 100))
        }
        let dict1 = WCDBAssertNoThrowReturned(try Database.trainDict(with: samples, and: 2))
        XCTAssertNotNil(dict1)
        XCTAssertNoThrow(try Database.register(dict: dict1!, with: 2))

        samples.removeAll()
        for _ in 0..<1000 {
            samples.append(Random.englishString(withLength: 100))
        }
        let dict2 = WCDBAssertNoThrowReturned(try Database.trainDict(with: samples, and: 3))
        XCTAssertNotNil(dict2)
        XCTAssertNoThrow(try Database.register(dict: dict2!, with: 3))

        samples.removeAll()
        for _ in 0..<1000 {
            samples.append(Random.englishString(withLength: 100))
        }
        let dict3 = WCDBAssertNoThrowReturned(try Database.trainDict(with: samples, and: 4))
        XCTAssertNotNil(dict3)
        XCTAssertNoThrow(try Database.register(dict: dict3!, with: 4))

        database.setCompression { info in
            info.addZSTDMultiDictCompress(to: TestObject.Properties.variable2,
                                          withMatchProperty: TestObject.Properties.variable1,
                                          andDicts: [
                1: 2,
                2: 3,
                Database.DictDefaultMatchValue: 4
            ])
        }

        XCTAssertFalse(database.isCompressed())
        XCTAssertNoThrow(try database.stepCompression())
        XCTAssertNoThrow(try database.stepCompression())
        XCTAssertTrue(database.isCompressed())

        let newInsertObjects = Random.testObjects(startWith: 3, count: 2)
        XCTAssertNoThrow(try table.insert(newInsertObjects))

        let count = WCDBAssertNoThrowReturned(try database.getValue(from: StatementSelect().select(Column.all().count()).from(table.name).where(Column(named: "WCDB_CT_variable2") == 2)))
        XCTAssertTrue(count != nil && count!.intValue == 4)

        preInsertObjects.append(contentsOf: newInsertObjects)

        let allObjects = WCDBAssertNoThrowReturned(try table.getObjects())
        XCTAssertTrue(allObjects.elementsEqual(preInsertObjects))
        Random.useEnglishString = false
    }
}
