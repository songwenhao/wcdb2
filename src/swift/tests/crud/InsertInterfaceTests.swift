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

class InsertInterfaceTests: CRUDTestCase {

    func testInsert() {
        // Give
        let object = TestObject()
        object.variable1 = preInsertedObjects.count + 1
        object.variable2 = self.name
        // When
        XCTAssertNoThrow(try database.insert(object, intoTable: TestObject.name))
        // Then
        let condition = TestObject.Properties.variable1 == object.variable1!
        let result: TestObject? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: TestObject.name, where: condition)
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, object)
    }

    func testAutoIncrementInsert() {
        // Give
        let object = TestObject()
        let expectedRowID = preInsertedObjects.count + 1
        object.isAutoIncrement = true
        object.variable2 = self.name
        // When
        XCTAssertNoThrow(try database.insert(object, intoTable: TestObject.name))
        // Then
        XCTAssertEqual(object.lastInsertedRowID, Int64(expectedRowID))
        let condition = TestObject.Properties.variable1 == expectedRowID
        let result: TestObject? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: TestObject.name, where: condition)
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.variable1, expectedRowID)
        XCTAssertEqual(result!.variable2, object.variable2)
    }

    func testInsertOrReplace() {
        // Give
        let object = TestObject()
        let expectedReplacedRowID = 1
        object.variable1 = expectedReplacedRowID
        object.variable2 = self.name
        // When
        XCTAssertNoThrow(try database.insertOrReplace(object, intoTable: TestObject.name))
        // Then
        let condition = TestObject.Properties.variable1 == expectedReplacedRowID
        let result: TestObject? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: TestObject.name, where: condition)
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.variable2, self.name)
    }

    func testInsertOrIgnore() {
        // Give
        let object = TestObject()
        let expectedReplacedRowID = 1
        object.variable1 = expectedReplacedRowID
        object.variable2 = self.name
        // When
        XCTAssertNoThrow(try database.insertOrIgnore(object, intoTable: TestObject.name))
        // Then
        let condition = TestObject.Properties.variable1 == expectedReplacedRowID
        let result: TestObject? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: TestObject.name, where: condition)
        )
        XCTAssertNotNil(result)
        XCTAssertNotEqual(result!.variable2, self.name)
    }

    func testPartialInsert() {
        // Give
        let object = TestObject()
        object.variable1 = preInsertedObjects.count + 1
        object.variable2 = self.name
        // When
        XCTAssertNoThrow(try database.insert(object,
                                             on: [TestObject.Properties.variable1],
                                             intoTable: TestObject.name))
        // Then
        let result: TestObject? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: TestObject.name,
                                   where: TestObject.Properties.variable1 == object.variable1!)
        )
        XCTAssertNotNil(result)
        XCTAssertNil(result!.variable2)
    }

    func testTableInsert() {
        // Give
        let object = TestObject()
        object.variable1 = preInsertedObjects.count + 1
        object.variable2 = self.name
        // When
        XCTAssertNoThrow(try table.insert(object))
        // Then
        let result = WCDBAssertNoThrowReturned(
            try table.getObject(where: TestObject.Properties.variable1 == object.variable1!)
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, object)
    }

    func testTableInsertOrReplace() {
        // Give
        let object = TestObject()
        let expectedReplacedRowID = 1
        object.variable1 = expectedReplacedRowID
        object.variable2 = self.name
        // When
        XCTAssertNoThrow(try table.insertOrReplace(object))
        // Then
        let condition = TestObject.Properties.variable1 == expectedReplacedRowID
        let result: TestObject? = WCDBAssertNoThrowReturned(
            try table.getObject(where: condition)
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.variable2, self.name)
    }

    func testTableInsertOrIgnore() {
        // Give
        let object = TestObject()
        let expectedReplacedRowID = 1
        object.variable1 = expectedReplacedRowID
        object.variable2 = self.name
        // When
        XCTAssertNoThrow(try table.insertOrIgnore(object))
        // Then
        let condition = TestObject.Properties.variable1 == expectedReplacedRowID
        let result: TestObject? = WCDBAssertNoThrowReturned(
            try table.getObject(where: condition)
        )
        XCTAssertNotNil(result)
        XCTAssertNotEqual(result!.variable2, self.name)
    }

}
