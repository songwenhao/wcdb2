//
// Created by qiuwenchen on 2022/9/5.
//

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

#import "CPPAllTypesObject.h"
#import "CPPColumnConstraintAutoIncrement.hpp"
#import "CPPColumnConstraintAutoIncrementAsc.hpp"
#import "CPPColumnConstraintDefault.hpp"
#import "CPPColumnConstraintEnablePrimaryAutoIncrement.hpp"
#import "CPPColumnConstraintPrimary.hpp"
#import "CPPColumnConstraintPrimaryAsc.hpp"
#import "CPPColumnConstraintPrimaryDesc.hpp"
#import "CPPColumnConstraintUnique.hpp"
#import "CPPDropIndexObject.hpp"
#import "CPPFieldObject.h"
#import "CPPIndexObject.hpp"
#import "CPPInheritObject.hpp"
#import "CPPNewFieldObject.h"
#import "CPPNewRemapObject.hpp"
#import "CPPNewlyCreatedTableIndexObject.hpp"
#import "CPPOldRemapObject.hpp"
#import "CPPSTDOptionalAllTypesObject.h"
#import "CPPSharedPtrAllTypesObject.h"
#import "CPPTableConstraintObject.hpp"
#import "CPPTestCase.h"
#import "CPPVirtualTableFTS4Object.hpp"
#import "CPPVirtualTableFTS5Object.hpp"
#import "CPPWCDBOptionalAllTypesObject.h"
#import <Foundation/Foundation.h>

@interface CPPORMTests : CPPCRUDTestCase

@end

@implementation CPPORMTests

- (void)setUp
{
    [super setUp];
    self.expectMode = DatabaseTestCaseExpectSomeSQLs;
}

- (void)doTestCreateTableAndIndexSQLsAsExpected:(NSArray<NSString*>*)expected inOperation:(BOOL (^)())block
{
    TestCaseAssertTrue(expected != nil);
    NSMutableArray* sqls = [NSMutableArray array];
    [sqls addObject:@"BEGIN IMMEDIATE"];
    [sqls addObjectsFromArray:expected];
    [sqls addObject:@"COMMIT"];
    [self doTestSQLs:sqls inOperation:block];
}

#pragma mark - field
- (void)test_field
{
    NSArray<NSString*>* expected = @[ @"CREATE TABLE IF NOT EXISTS testTable(field INTEGER, differentName INTEGER)" ];
    [self doTestCreateTableAndIndexSQLsAsExpected:expected
                                      inOperation:^BOOL {
                                          return CPPTestTableCreate<CPPFieldObject>(self);
                                      }];
}

#pragma mark - table constraint
- (void)test_table_constraint
{
    NSArray<NSString*>* expected = @[ @"CREATE TABLE IF NOT EXISTS testTable(multiPrimary INTEGER, multiPrimaryAsc INTEGER, multiPrimaryDesc INTEGER, multiUnique INTEGER, multiUniqueAsc INTEGER, multiUniqueDesc INTEGER, CONSTRAINT multi_primary PRIMARY KEY(multiPrimary, multiPrimaryAsc ASC, multiPrimaryDesc DESC), CONSTRAINT multi_unique UNIQUE(multiUnique, multiUniqueAsc ASC, multiUniqueDesc DESC))" ];
    [self doTestCreateTableAndIndexSQLsAsExpected:expected
                                      inOperation:^BOOL {
                                          return CPPTestTableCreate<CPPTableConstraintObject>(self);
                                      }];
}

- (void)test_all_types
{
    NSArray<NSString*>* expected = @[ @"CREATE TABLE IF NOT EXISTS testTable(type TEXT, enumValue INTEGER, enumClassValue INTEGER, literalEnumValue INTEGER, trueOrFalseValue INTEGER, charValue INTEGER, unsignedCharValue INTEGER, shortValue INTEGER, unsignedShortValue INTEGER, intValue INTEGER, unsignedIntValue INTEGER, int32Value INTEGER, int64Value INTEGER, uint32Value INTEGER, uint64Value INTEGER, floatValue REAL, doubleValue REAL, constCharpValue TEXT, charpValue TEXT, constCharArrValue TEXT, charArrValue TEXT, stdStringValue TEXT, unsafeStringViewValue TEXT, stringViewValue TEXT, blobValue BLOB, unsafeDataValue BLOB, dataValue BLOB, constUnsignedCharArrValue BLOB, unsignedCharArrValue BLOB)" ];
    [self doTestCreateTableAndIndexSQLsAsExpected:expected
                                      inOperation:^BOOL {
                                          return CPPTestTableCreate<CPPAllTypesObject>(self);
                                      }];

    WCDB::Table<CPPAllTypesObject> table = self.database->getTable<CPPAllTypesObject>(self.tableName.UTF8String);

    CPPAllTypesObject maxObject = CPPAllTypesObject::maxObject();
    TestCaseAssertTrue(table.insertObjects(maxObject));

    CPPAllTypesObject minObject = CPPAllTypesObject::minObject();
    TestCaseAssertTrue(table.insertObjects(minObject));

    CPPAllTypesObject emptyObject = CPPAllTypesObject::emptyObject();
    TestCaseAssertTrue(table.insertObjects(emptyObject));

    CPPAllTypesObject randomObject = CPPAllTypesObject::randomObject();
    TestCaseAssertTrue(table.insertObjects(randomObject));

    XCTAssertTrue(table.insertRows({ "null" }, WCDB_FIELD(CPPAllTypesObject::type)));

    CPPAllTypesObject selectedMaxObject = table.getFirstObject(WCDB_FIELD(CPPAllTypesObject::type) == maxObject.type).value();
    TestCaseAssertTrue(selectedMaxObject == maxObject);

    CPPAllTypesObject selectedMinObject = table.getFirstObject(WCDB_FIELD(CPPAllTypesObject::type) == minObject.type).value();
    TestCaseAssertTrue(selectedMinObject == minObject);

    CPPAllTypesObject selectedEmptyObject = table.getFirstObject(WCDB_FIELD(CPPAllTypesObject::type) == emptyObject.type).value();
    TestCaseAssertTrue(selectedEmptyObject == emptyObject);

    CPPAllTypesObject selectedRandomObject = table.getFirstObject(WCDB_FIELD(CPPAllTypesObject::type) == randomObject.type).value();
    TestCaseAssertTrue(selectedRandomObject == randomObject);

    TestCaseAssertTrue(table.getValueFromStatement(WCDB::StatementSelect().select(WCDB_FIELD(CPPAllTypesObject::constCharArrValue)).from(self.tableName.UTF8String)).value() == maxObject.constCharArrValue);

    TestCaseAssertTrue(table.getValueFromStatement(WCDB::StatementSelect().select(WCDB_FIELD(CPPAllTypesObject::constUnsignedCharArrValue)).from(self.tableName.UTF8String)).value() == maxObject.constUnsignedCharArrValue);

    CPPAllTypesObject selectedNullObject = table.getFirstObject(WCDB_FIELD(CPPAllTypesObject::type) == "null").value();
    TestCaseAssertTrue(selectedNullObject == emptyObject);
}

- (void)test_all_shared_ptr_types
{
    NSArray<NSString*>* expected = @[ @"CREATE TABLE IF NOT EXISTS testTable(type TEXT, enumValue INTEGER, enumClassValue INTEGER, literalEnumValue INTEGER, trueOrFalseValue INTEGER, charValue INTEGER, unsignedCharValue INTEGER, shortValue INTEGER, unsignedShortValue INTEGER, intValue INTEGER, unsignedIntValue INTEGER, int32Value INTEGER, int64Value INTEGER, uint32Value INTEGER, uint64Value INTEGER, floatValue REAL, doubleValue REAL, constCharpValue TEXT, charpValue TEXT, stdStringValue TEXT, unsafeStringViewValue TEXT, stringViewValue TEXT, blobValue BLOB, unsafeDataValue BLOB, dataValue BLOB)" ];
    [self doTestCreateTableAndIndexSQLsAsExpected:expected
                                      inOperation:^BOOL {
                                          return CPPTestTableCreate<CPPSharedPtrAllTypesObject>(self);
                                      }];

    WCDB::Table<CPPSharedPtrAllTypesObject> table = self.database->getTable<CPPSharedPtrAllTypesObject>(self.tableName.UTF8String);

    CPPSharedPtrAllTypesObject maxObject = CPPSharedPtrAllTypesObject::maxObject();
    TestCaseAssertTrue(table.insertObjects(maxObject));

    CPPSharedPtrAllTypesObject minObject = CPPSharedPtrAllTypesObject::minObject();
    TestCaseAssertTrue(table.insertObjects(minObject));

    CPPSharedPtrAllTypesObject emptyObject = CPPSharedPtrAllTypesObject::emptyObject();
    TestCaseAssertTrue(table.insertObjects(emptyObject));

    CPPSharedPtrAllTypesObject randomObject = CPPSharedPtrAllTypesObject::randomObject();
    TestCaseAssertTrue(table.insertObjects(randomObject));

    XCTAssertTrue(table.insertRows({ "null" }, WCDB_FIELD(CPPSharedPtrAllTypesObject::type)));

    CPPSharedPtrAllTypesObject selectedMaxObject = table.getFirstObject(WCDB_FIELD(CPPSharedPtrAllTypesObject::type) == maxObject.type).value();
    TestCaseAssertTrue(selectedMaxObject == maxObject);

    CPPSharedPtrAllTypesObject selectedMinObject = table.getFirstObject(WCDB_FIELD(CPPSharedPtrAllTypesObject::type) == minObject.type).value();
    TestCaseAssertTrue(selectedMinObject == minObject);

    CPPSharedPtrAllTypesObject selectedEmptyObject = table.getFirstObject(WCDB_FIELD(CPPSharedPtrAllTypesObject::type) == emptyObject.type).value();
    TestCaseAssertTrue(selectedEmptyObject == emptyObject);

    CPPSharedPtrAllTypesObject selectedRandomObject = table.getFirstObject(WCDB_FIELD(CPPSharedPtrAllTypesObject::type) == randomObject.type).value();
    TestCaseAssertTrue(selectedRandomObject == randomObject);

    CPPSharedPtrAllTypesObject selectedNullObject = table.getFirstObject(WCDB_FIELD(CPPSharedPtrAllTypesObject::type) == "null").value();
    TestCaseAssertTrue(selectedNullObject == emptyObject);
}

#if defined(__cplusplus) && __cplusplus > 201402L

- (void)test_all_std_optional_types
{
    NSArray<NSString*>* expected = @[ @"CREATE TABLE IF NOT EXISTS testTable(type TEXT, enumValue INTEGER, enumClassValue INTEGER, literalEnumValue INTEGER, trueOrFalseValue INTEGER, charValue INTEGER, unsignedCharValue INTEGER, shortValue INTEGER, unsignedShortValue INTEGER, intValue INTEGER, unsignedIntValue INTEGER, int32Value INTEGER, int64Value INTEGER, uint32Value INTEGER, uint64Value INTEGER, floatValue REAL, doubleValue REAL, constCharpValue TEXT, charpValue TEXT, stdStringValue TEXT, unsafeStringViewValue TEXT, stringViewValue TEXT, blobValue BLOB, unsafeDataValue BLOB, dataValue BLOB)" ];
    [self doTestCreateTableAndIndexSQLsAsExpected:expected
                                      inOperation:^BOOL {
                                          return CPPTestTableCreate<CPPSTDOptionalAllTypesObject>(self);
                                      }];

    WCDB::Table<CPPSTDOptionalAllTypesObject> table = self.database->getTable<CPPSTDOptionalAllTypesObject>(self.tableName.UTF8String);

    CPPSTDOptionalAllTypesObject maxObject = CPPSTDOptionalAllTypesObject::maxObject();
    TestCaseAssertTrue(table.insertObjects(maxObject));

    CPPSTDOptionalAllTypesObject minObject = CPPSTDOptionalAllTypesObject::minObject();
    TestCaseAssertTrue(table.insertObjects(minObject));

    CPPSTDOptionalAllTypesObject emptyObject = CPPSTDOptionalAllTypesObject::emptyObject();
    TestCaseAssertTrue(table.insertObjects(emptyObject));

    CPPSTDOptionalAllTypesObject randomObject = CPPSTDOptionalAllTypesObject::randomObject();
    TestCaseAssertTrue(table.insertObjects(randomObject));

    XCTAssertTrue(table.insertRows({ "null" }, WCDB_FIELD(CPPSTDOptionalAllTypesObject::type)));

    CPPSTDOptionalAllTypesObject selectedMaxObject = table.getFirstObject(WCDB_FIELD(CPPSTDOptionalAllTypesObject::type) == maxObject.type).value();
    TestCaseAssertTrue(selectedMaxObject == maxObject);

    CPPSTDOptionalAllTypesObject selectedMinObject = table.getFirstObject(WCDB_FIELD(CPPSTDOptionalAllTypesObject::type) == minObject.type).value();
    TestCaseAssertTrue(selectedMinObject == minObject);

    CPPSTDOptionalAllTypesObject selectedEmptyObject = table.getFirstObject(WCDB_FIELD(CPPSTDOptionalAllTypesObject::type) == emptyObject.type).value();
    TestCaseAssertTrue(selectedEmptyObject == emptyObject);

    CPPSTDOptionalAllTypesObject selectedRandomObject = table.getFirstObject(WCDB_FIELD(CPPSTDOptionalAllTypesObject::type) == randomObject.type).value();
    TestCaseAssertTrue(selectedRandomObject == randomObject);

    CPPSTDOptionalAllTypesObject selectedNullObject = table.getFirstObject(WCDB_FIELD(CPPSTDOptionalAllTypesObject::type) == "null").value();
    TestCaseAssertTrue(selectedNullObject == emptyObject);
}

#endif

- (void)test_all_wcdb_optional_types
{
    NSArray<NSString*>* expected = @[ @"CREATE TABLE IF NOT EXISTS testTable(type TEXT, enumValue INTEGER, enumClassValue INTEGER, literalEnumValue INTEGER, trueOrFalseValue INTEGER, charValue INTEGER, unsignedCharValue INTEGER, shortValue INTEGER, unsignedShortValue INTEGER, intValue INTEGER, unsignedIntValue INTEGER, int32Value INTEGER, int64Value INTEGER, uint32Value INTEGER, uint64Value INTEGER, floatValue REAL, doubleValue REAL, constCharpValue TEXT, charpValue TEXT, stdStringValue TEXT, unsafeStringViewValue TEXT, stringViewValue TEXT, blobValue BLOB, unsafeDataValue BLOB, dataValue BLOB)" ];
    [self doTestCreateTableAndIndexSQLsAsExpected:expected
                                      inOperation:^BOOL {
                                          return CPPTestTableCreate<CPPWCDBOptionalAllTypesObject>(self);
                                      }];

    WCDB::Table<CPPWCDBOptionalAllTypesObject> table = self.database->getTable<CPPWCDBOptionalAllTypesObject>(self.tableName.UTF8String);

    CPPWCDBOptionalAllTypesObject maxObject = CPPWCDBOptionalAllTypesObject::maxObject();
    TestCaseAssertTrue(table.insertObjects(maxObject));

    CPPWCDBOptionalAllTypesObject minObject = CPPWCDBOptionalAllTypesObject::minObject();
    TestCaseAssertTrue(table.insertObjects(minObject));

    CPPWCDBOptionalAllTypesObject emptyObject = CPPWCDBOptionalAllTypesObject::emptyObject();
    TestCaseAssertTrue(table.insertObjects(emptyObject));

    CPPWCDBOptionalAllTypesObject randomObject = CPPWCDBOptionalAllTypesObject::randomObject();
    TestCaseAssertTrue(table.insertObjects(randomObject));

    XCTAssertTrue(table.insertRows({ "null" }, WCDB_FIELD(CPPWCDBOptionalAllTypesObject::type)));

    CPPWCDBOptionalAllTypesObject selectedMaxObject = table.getFirstObject(WCDB_FIELD(CPPWCDBOptionalAllTypesObject::type) == maxObject.type).value();
    TestCaseAssertTrue(selectedMaxObject == maxObject);

    CPPWCDBOptionalAllTypesObject selectedMinObject = table.getFirstObject(WCDB_FIELD(CPPWCDBOptionalAllTypesObject::type) == minObject.type).value();
    TestCaseAssertTrue(selectedMinObject == minObject);

    CPPWCDBOptionalAllTypesObject selectedEmptyObject = table.getFirstObject(WCDB_FIELD(CPPWCDBOptionalAllTypesObject::type) == emptyObject.type).value();
    TestCaseAssertTrue(selectedEmptyObject == emptyObject);

    CPPWCDBOptionalAllTypesObject selectedRandomObject = table.getFirstObject(WCDB_FIELD(CPPWCDBOptionalAllTypesObject::type) == randomObject.type).value();
    TestCaseAssertTrue(selectedRandomObject == randomObject);

    CPPWCDBOptionalAllTypesObject selectedNullObject = table.getFirstObject(WCDB_FIELD(CPPWCDBOptionalAllTypesObject::type) == "null").value();
    TestCaseAssertTrue(selectedNullObject == emptyObject);
}

- (void)test_all_properties
{
    TestCaseAssertEqual(2, CPPFieldObject::allFields().size());
    TestCaseAssertSQLEqual(CPPFieldObject::allFields(), @"field, differentName");
}

#pragma mark - column constraint
- (void)test_column_constraint_primary
{
    NSArray<NSString*>* expected = @[
        @"CREATE TABLE IF NOT EXISTS testTable(value INTEGER PRIMARY KEY)",
    ];
    [self doTestCreateTableAndIndexSQLsAsExpected:expected
                                      inOperation:^BOOL {
                                          return CPPTestTableCreate<CPPColumnConstraintPrimary>(self);
                                      }];
}

- (void)test_column_constraint_primary_asc
{
    NSArray<NSString*>* expected = @[
        @"CREATE TABLE IF NOT EXISTS testTable(value INTEGER PRIMARY KEY ASC)",
    ];
    [self doTestCreateTableAndIndexSQLsAsExpected:expected
                                      inOperation:^BOOL {
                                          return CPPTestTableCreate<CPPColumnConstraintPrimaryAsc>(self);
                                      }];
}

- (void)test_column_constraint_primary_desc
{
    NSArray<NSString*>* expected = @[
        @"CREATE TABLE IF NOT EXISTS testTable(value INTEGER PRIMARY KEY DESC)",
    ];
    [self doTestCreateTableAndIndexSQLsAsExpected:expected
                                      inOperation:^BOOL {
                                          return CPPTestTableCreate<CPPColumnConstraintPrimaryDesc>(self);
                                      }];
}

- (void)test_column_constraint_auto_increment
{
    NSArray<NSString*>* expected = @[
        @"CREATE TABLE IF NOT EXISTS testTable(value INTEGER PRIMARY KEY AUTOINCREMENT)",
    ];
    [self doTestCreateTableAndIndexSQLsAsExpected:expected
                                      inOperation:^BOOL {
                                          return CPPTestTableCreate<CPPColumnConstraintAutoIncrement>(self);
                                      }];
}

- (void)test_column_constraint_auto_increment_asc
{
    NSArray<NSString*>* expected = @[
        @"CREATE TABLE IF NOT EXISTS testTable(value INTEGER PRIMARY KEY ASC AUTOINCREMENT)",
    ];
    [self doTestCreateTableAndIndexSQLsAsExpected:expected
                                      inOperation:^BOOL {
                                          return CPPTestTableCreate<CPPColumnConstraintAutoIncrementAsc>(self);
                                      }];
}

- (void)test_column_constraint_unique
{
    NSArray<NSString*>* expected = @[
        @"CREATE TABLE IF NOT EXISTS testTable(value INTEGER UNIQUE)",
    ];
    [self doTestCreateTableAndIndexSQLsAsExpected:expected
                                      inOperation:^BOOL {
                                          return CPPTestTableCreate<CPPColumnConstraintUnique>(self);
                                      }];
}

- (void)test_column_constraint_default
{
    NSArray<NSString*>* expected = @[
        @"CREATE TABLE IF NOT EXISTS testTable(value INTEGER DEFAULT 1)",
    ];
    [self doTestCreateTableAndIndexSQLsAsExpected:expected
                                      inOperation:^BOOL {
                                          return CPPTestTableCreate<CPPColumnConstraintDefault>(self);
                                      }];
}

- (void)test_column_constraint_primary_enable_auto_increment_for_existing_table
{
    TestCaseAssertTrue(self.database->createTable<CPPColumnConstraintPrimaryNotAutoIncrement>(self.tableName.UTF8String));
    CPPColumnConstraintPrimaryNotAutoIncrement obj;
    obj.id = 1;
    obj.isAutoIncrement = true;
    TestCaseAssertTrue(self.database->insertObjects<CPPColumnConstraintPrimaryNotAutoIncrement>(obj, self.tableName.UTF8String));
    TestCaseAssertTrue(*obj.lastInsertedRowID == 1LL);

    TestCaseAssertTrue(self.database->createTable<CPPColumnConstraintEnablePrimaryAutoIncrement>(self.tableName.UTF8String));

    TestCaseAssertTrue(self.database->deleteObjects(self.tableName.UTF8String));

    CPPColumnConstraintEnablePrimaryAutoIncrement obj2;
    obj2.isAutoIncrement = true;
    TestCaseAssertTrue(self.database->insertObjects<CPPColumnConstraintEnablePrimaryAutoIncrement>(obj2, self.tableName.UTF8String));
    TestCaseAssertTrue(*obj2.lastInsertedRowID == 2LL);
}

#pragma mark - index
- (void)test_index
{
    NSArray<NSString*>* expected = @[
        @"CREATE TABLE IF NOT EXISTS testTable(index_ INTEGER, indexAsc INTEGER, indexDesc INTEGER, uniqueIndex INTEGER, uniqueIndexAsc INTEGER, uniqueIndexDesc INTEGER, multiIndex INTEGER, multiIndexAsc INTEGER, multiIndexDesc INTEGER)",
        @"CREATE INDEX IF NOT EXISTS testTable_index ON testTable(index_)",
        @"CREATE INDEX IF NOT EXISTS testTable_index_asc ON testTable(indexAsc ASC)",
        @"CREATE INDEX IF NOT EXISTS testTable_index_desc ON testTable(indexDesc DESC)",
        @"CREATE INDEX IF NOT EXISTS testTable_multi_index ON testTable(multiIndex, multiIndexAsc ASC, multiIndexDesc DESC)",
        @"CREATE UNIQUE INDEX IF NOT EXISTS testTable_unique_index ON testTable(uniqueIndex)",
        @"CREATE UNIQUE INDEX IF NOT EXISTS testTable_unique_index_asc ON testTable(uniqueIndexAsc ASC)",
        @"CREATE UNIQUE INDEX IF NOT EXISTS testTable_unique_index_desc ON testTable(uniqueIndexDesc DESC)",
    ];
    [self doTestCreateTableAndIndexSQLsAsExpected:expected
                                      inOperation:^BOOL {
                                          return CPPTestTableCreate<CPPIndexObject>(self);
                                      }];
}

#pragma mark - remap
- (void)test_remap
{
    {
        NSArray<NSString*>* expected = @[ @"CREATE TABLE IF NOT EXISTS testTable(value INTEGER)" ];
        [self doTestCreateTableAndIndexSQLsAsExpected:expected
                                          inOperation:^BOOL {
                                              return CPPTestTableCreate<CPPOldRemapObject>(self);
                                          }];
    }
    // remap
    {
        NSArray<NSString*>* expected = @[ @"PRAGMA main.table_info('testTable')", @"ALTER TABLE main.testTable ADD COLUMN newValue INTEGER", @"CREATE INDEX IF NOT EXISTS testTable_index ON testTable(value)" ];
        [self doTestCreateTableAndIndexSQLsAsExpected:expected
                                          inOperation:^BOOL {
                                              return CPPTestTableCreate<CPPNewRemapObject>(self);
                                          }];
    }
}

- (void)test_remap_with_extra_actions
{
    {
        NSArray<NSString*>* expected = @[ @"CREATE TABLE IF NOT EXISTS testTable(value INTEGER)" ];
        [self doTestCreateTableAndIndexSQLsAsExpected:expected
                                          inOperation:^BOOL {
                                              return CPPTestTableCreate<CPPOldRemapObject>(self);
                                          }];
    }
    // remap
    {
        NSArray<NSString*>* expected = @[ @"PRAGMA main.table_info('testTable')", @"ALTER TABLE main.testTable ADD COLUMN newValue INTEGER" ];
        [self doTestCreateTableAndIndexSQLsAsExpected:expected
                                          inOperation:^BOOL {
                                              return CPPTestTableCreate<CPPNewlyCreatedTableIndexObject>(self);
                                          }];
    }
    TestCaseAssertTrue([self dropTable]);
    // newly create
    {
        NSArray<NSString*>* expected = @[ @"CREATE TABLE IF NOT EXISTS testTable(value INTEGER, newValue INTEGER)", @"CREATE INDEX IF NOT EXISTS testTable_index ON testTable(value)" ];
        [self doTestCreateTableAndIndexSQLsAsExpected:expected
                                          inOperation:^BOOL {
                                              return CPPTestTableCreate<CPPNewlyCreatedTableIndexObject>(self);
                                          }];
    }
    // drop index
    {
        NSArray<NSString*>* expected = @[ @"PRAGMA main.table_info('testTable')", @"DROP INDEX IF EXISTS testTable_index" ];
        [self doTestCreateTableAndIndexSQLsAsExpected:expected
                                          inOperation:^BOOL {
                                              return CPPTestTableCreate<CPPDropIndexObject>(self);
                                          }];
    }
}

#pragma mark - virtual table
- (void)test_virtual_table_fts3
{
    self.database->addTokenizer(WCDB::BuiltinTokenizer::OneOrBinary);
    NSString* expected = @"CREATE VIRTUAL TABLE IF NOT EXISTS testTable USING fts4(tokenize = wcdb_one_or_binary, content='contentTable', identifier INTEGER, content TEXT, notindexed=identifier)";
    [self doTestSQLs:@[ expected ]
         inOperation:^BOOL {
             return CPPTestVirtualTableCreate<CPPVirtualTableFTS4Object>(self);
         }];
}

- (void)test_virtual_table_fts5
{
    NSString* expected = @"CREATE VIRTUAL TABLE IF NOT EXISTS testTable USING fts5(tokenize = 'porter', content='contentTable', identifier UNINDEXED, content)";
    [self doTestSQLs:@[ expected ]
         inOperation:^BOOL {
             return CPPTestVirtualTableCreate<CPPVirtualTableFTS5Object>(self);
         }];
}

#pragma mark - auto add column
- (void)test_auto_add_column
{
    NSString* fakeTable = @"fakeTable";
    TestCaseAssertTrue(self.database->createTable<CPPNewFieldObject>(fakeTable.UTF8String));

    [self testAutoAddColumn:WCDB_FIELD(CPPNewFieldObject::insertValue)
                  isSucceed:YES
                  byExecute:^bool {
                      return self.database->insertObjects<CPPNewFieldObject>(CPPNewFieldObject(), self.tableName.UTF8String);
                  }];

    [self testAutoAddColumn:WCDB_FIELD(CPPNewFieldObject::updateValue)
                  isSucceed:YES
                  byExecute:^bool {
                      return self.database->updateRow(1, WCDB_FIELD(CPPNewFieldObject::updateValue), self.tableName.UTF8String);
                  }];

    [self testAutoAddColumn:WCDB_FIELD(CPPNewFieldObject::deleteValue)
                  isSucceed:YES
                  byExecute:^bool {
                      return self.database->deleteObjects(self.tableName.UTF8String, WCDB_FIELD(CPPNewFieldObject::deleteValue) == 1);
                  }];

    [self testAutoAddColumn:WCDB_FIELD(CPPNewFieldObject::deleteValue)
                  isSucceed:YES
                  byExecute:^bool {
                      return self.database->deleteObjects(self.tableName.UTF8String, WCDB_FIELD(CPPNewFieldObject::deleteValue).table(self.tableName.UTF8String) == 1);
                  }];

    [self testAutoAddColumn:WCDB_FIELD(CPPNewFieldObject::deleteValue)
                  isSucceed:NO
                  byExecute:^bool {
                      return self.database->deleteObjects(self.tableName.UTF8String, WCDB_FIELD(CPPNewFieldObject::deleteValue).table(fakeTable.UTF8String) == 1);
                  }];

    [self testAutoAddColumn:WCDB_FIELD(CPPNewFieldObject::deleteValue)
                  isSucceed:NO
                  byExecute:^bool {
                      return self.database->deleteObjects(self.tableName.UTF8String, WCDB_FIELD(CPPNewFieldObject::deleteValue).table(self.tableName.UTF8String).schema("notExistSchema") == 1);
                  }];

    [self testAutoAddColumn:WCDB_FIELD(CPPNewFieldObject::selectValue)
                  isSucceed:YES
                  byExecute:^bool {
                      return self.database->selectOneColumn(WCDB_FIELD(CPPNewFieldObject::selectValue), self.tableName.UTF8String).succeed();
                  }];

    [self testAutoAddColumn:WCDB_FIELD(CPPNewFieldObject::selectValue)
                  isSucceed:YES
                  byExecute:^bool {
                      return self.database->selectOneColumn(WCDB_FIELD(CPPNewFieldObject::insertValue), self.tableName.UTF8String, WCDB_FIELD(CPPNewFieldObject::selectValue) == 1).succeed();
                  }];

    [self testAutoAddColumn:WCDB_FIELD(CPPNewFieldObject::selectValue)
                  isSucceed:YES
                  byExecute:^bool {
                      return self.database->selectOneColumn(WCDB_FIELD(CPPNewFieldObject::insertValue), self.tableName.UTF8String, WCDB::Expression(), WCDB_FIELD(CPPNewFieldObject::selectValue).asOrder()).succeed();
                  }];

    [self testAutoAddColumn:WCDB_FIELD(CPPNewFieldObject::selectValue)
                  isSucceed:YES
                  byExecute:^bool {
                      return self.database->selectOneColumn(WCDB_FIELD(CPPNewFieldObject::insertValue), self.tableName.UTF8String, WCDB::Expression(), WCDB_FIELD(CPPNewFieldObject::selectValue).table(self.tableName.UTF8String).asOrder()).succeed();
                  }];

    [self testAutoAddColumn:WCDB_FIELD(CPPNewFieldObject::selectValue)
                  isSucceed:NO
                  byExecute:^bool {
                      return self.database->selectOneColumn(WCDB_FIELD(CPPNewFieldObject::insertValue), self.tableName.UTF8String, WCDB::Expression(), WCDB_FIELD(CPPNewFieldObject::selectValue).table(fakeTable.UTF8String).asOrder()).succeed();
                  }];

    [self testAutoAddColumn:WCDB_FIELD(CPPNewFieldObject::selectValue)
                  isSucceed:NO
                  byExecute:^bool {
                      return self.database->selectOneColumn(WCDB_FIELD(CPPNewFieldObject::insertValue), self.tableName.UTF8String, WCDB::Expression(), WCDB_FIELD(CPPNewFieldObject::selectValue).table(self.tableName.UTF8String).schema("notExistSchema").asOrder()).succeed();
                  }];

    [self testAutoAddColumn:WCDB_FIELD(CPPNewFieldObject::multiSelectValue)
                  isSucceed:YES
                  byExecute:^bool {
                      WCDB::MultiSelect multiSelect = self.database->prepareMultiSelect();
                      multiSelect.onResultFields({ WCDB_FIELD(CPPNewFieldObject::multiSelectValue).table(self.tableName.UTF8String), WCDB_FIELD(CPPNewFieldObject::multiSelectValue).table(fakeTable.UTF8String) }).fromTables({ self.tableName.UTF8String, fakeTable.UTF8String });
                      return multiSelect.allMultiObjects().succeed();
                  }];

    [self testAutoAddColumn:WCDB_FIELD(CPPNewFieldObject::multiSelectValue)
                  isSucceed:NO
                  byExecute:^bool {
                      WCDB::MultiSelect multiSelect = self.database->prepareMultiSelect();
                      multiSelect.onResultFields({ WCDB_FIELD(CPPNewFieldObject::multiSelectValue).table(self.tableName.UTF8String).schema("notExistSchema"), WCDB_FIELD(CPPNewFieldObject::multiSelectValue).table(fakeTable.UTF8String) }).fromTables({ self.tableName.UTF8String, fakeTable.UTF8String });
                      return multiSelect.allMultiObjects().succeed();
                  }];

    [self testAutoAddColumn:WCDB_FIELD(CPPNewFieldObject::primaryValue)
                  isSucceed:NO
                  byExecute:^bool {
                      return self.database->selectOneColumn(WCDB_FIELD(CPPNewFieldObject::insertValue), self.tableName.UTF8String, WCDB_FIELD(CPPNewFieldObject::primaryValue) == 1).succeed();
                  }];

    [self testAutoAddColumn:WCDB_FIELD(CPPNewFieldObject::uniqueValue)
                  isSucceed:NO
                  byExecute:^bool {
                      return self.database->selectOneColumn(WCDB_FIELD(CPPNewFieldObject::insertValue), self.tableName.UTF8String, WCDB_FIELD(CPPNewFieldObject::uniqueValue) == 1).succeed();
                  }];
}

- (void)testAutoAddColumn:(const WCDB::Field&)newField isSucceed:(BOOL)isSucceed byExecute:(bool (^)())block
{
    auto createTable = WCDB::StatementCreateTable().createTable(self.tableName.UTF8String);
    auto binding = const_cast<WCDB::Binding*>(&CPPNewFieldObject::getObjectRelationBinding());
    auto fields = CPPNewFieldObject::allFields().fieldsByRemovingFields(newField);
    for (const WCDB::Field& field : fields) {
        createTable.define(*binding->getColumnDef(field.getDescription()));
    }
    NSString* propertyName = [NSString stringWithUTF8String:newField.getDescription().data()];
    TestCaseAssertTrue(self.database->execute(createTable));
    bool autoAdded = false;
    self.database->traceError([&](const WCDB::Error& error) {
        if (error.getMessage().compare("Auto add column") != 0) {
            return;
        }
        autoAdded = YES;
        TestCaseAssertTrue(error.infos.at("Table").textValue().compare(self.tableName.UTF8String) == 0);
        TestCaseAssertTrue(error.infos.at("Column").textValue().compare(propertyName.UTF8String) == 0);
    });
    TestCaseAssertTrue(block() == isSucceed);
    TestCaseAssertTrue(autoAdded || !isSucceed);
    TestCaseAssertTrue(self.database->dropTable(self.tableName.UTF8String));
    self.database->traceError(nullptr);
}

- (void)test_redirect_field
{
    [self insertPresetObjects];
    auto object = self.table.getFirstObjectWithFields(WCDB_FIELD(CPPTestCaseObject::identifier).redirect(WCDB_FIELD(CPPTestCaseObject::identifier).max()));
    XCTAssertTrue(object.valueOrDefault().identifier == self.objects[1].identifier);
}

#pragma mark - inherit
- (void)test_inherit
{
    NSArray<NSString*>* expected = @[
        @"CREATE TABLE IF NOT EXISTS testTable(value1 INTEGER PRIMARY KEY, value2 REAL, value3 INTEGER, value4 TEXT, value5 BLOB UNIQUE)",
        @"CREATE INDEX IF NOT EXISTS testTable_value2 ON testTable(value2)",
        @"CREATE INDEX IF NOT EXISTS testTable_value3_value4 ON testTable(value3, value4)"
    ];
    [self doTestCreateTableAndIndexSQLsAsExpected:expected
                                      inOperation:^BOOL {
                                          return CPPTestTableCreate<CPPInheritObject>(self);
                                      }];

    CPPInheritObject object;
    object.value1 = 1;
    object.value2 = 2.0;
    object.value3 = 3;
    object.value4 = "abc";
    NSData* data = Random.shared.data;
    object.value5 = WCDB::Data((const unsigned char*) data.bytes, data.length);
    [self doTestSQLs:@[ @"INSERT INTO testTable(value1, value2, value3, value4, value5) VALUES(?1, ?2, ?3, ?4, ?5)",
                        @"UPDATE testTable SET value4 = ?1 WHERE value1 == 1",
                        @"SELECT value1, value2, value3, value4, value5 FROM testTable WHERE value2 == 2 ORDER BY rowid ASC LIMIT 1",
                        @"DELETE FROM testTable WHERE value3 == 3" ]
         inOperation:^BOOL {
             XCTAssertTrue(self.database->insertObject<CPPInheritBase1>(object, self.tableName.UTF8String, CPPInheritObject::allFields()));
             CPPInheritObject object2;
             object2.value4 = "def";
             XCTAssertTrue(self.database->updateObject<CPPInheritBase1>(object2, { WCDB_FIELD(CPPInheritObject::value4) }, self.tableName.UTF8String, WCDB_FIELD(CPPInheritBase1::value1) == 1));
             auto ret = self.database->getFirstObject<CPPInheritObject>(self.tableName.UTF8String, WCDB_FIELD(CPPInheritObject::value2) == 2);
             XCTAssertTrue(ret.succeed());
             XCTAssertTrue(ret.value().value2 == 2.0 && ret.value().value3 == 3 && ret.value().value4 == "def");
             XCTAssertTrue(memcmp((const void*) ret.value().value5.buffer(), data.bytes, data.length) == 0);
             XCTAssertTrue(self.database->deleteObjects(self.tableName.UTF8String, WCDB_FIELD(CPPInheritBase2::value3) == 3));
             return true;
         }];

    auto count = self.database->selectValue(WCDB::Column::all().count(), self.tableName.UTF8String);
    XCTAssertTrue(count.succeed() && count.value() == 0);
}

@end
