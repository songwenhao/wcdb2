//
// Created by sanhuazhang on 2019/05/02
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

#import "CRUDTestCase.h"
#import "TestCase.h"

@interface ConvenientSelectTests : CRUDTestCase

@property (nonatomic, readonly) TestCaseObject *partialObject1;
@property (nonatomic, readonly) TestCaseObject *partialObject2;
@property (nonatomic, readonly) NSArray<TestCaseObject *> *partialObjects;

@property (nonatomic, readonly) WCTOneRow *partialRow1;
@property (nonatomic, readonly) WCTOneRow *partialRow2;
@property (nonatomic, readonly) WCTColumnsXRows *partialRows;

@property (nonatomic, readonly) WCTValue *value1;
@property (nonatomic, readonly) WCTValue *value2;
@property (nonatomic, readonly) WCTOneColumn *column;

@end

@implementation ConvenientSelectTests {
    TestCaseObject *_partialObject1;
    TestCaseObject *_partialObject2;
    NSArray<TestCaseObject *> *_partialObjects;

    WCTOneRow *_partialRow1;
    WCTOneRow *_partialRow2;
    WCTColumnsXRows *_partialRows;

    WCTValue *_value1;
    WCTValue *_value2;
    WCTOneColumn *_column;
}

- (void)setUp
{
    [super setUp];
    [self insertPresetObjects];
}

- (TestCaseObject *)partialObject1
{
    @synchronized(self) {
        if (_partialObject1 == nil) {
            _partialObject1 = [TestCaseObject partialObjectWithIdentifier:1];
        }
        return _partialObject1;
    }
}

- (TestCaseObject *)partialObject2
{
    @synchronized(self) {
        if (_partialObject2 == nil) {
            _partialObject2 = [TestCaseObject partialObjectWithIdentifier:2];
        }
        return _partialObject2;
    }
}

- (NSArray<TestCaseObject *> *)partialObjects
{
    @synchronized(self) {
        if (_partialObjects == nil) {
            _partialObjects = @[ self.partialObject1, self.partialObject2 ];
        }
        return _partialObjects;
    }
}

- (WCTOneRow *)partialRow1
{
    @synchronized(self) {
        if (_partialRow1 == nil) {
            _partialRow1 = @[ @(1) ];
        }
        return _partialRow1;
    }
}

- (WCTOneRow *)partialRow2
{
    @synchronized(self) {
        if (_partialRow2 == nil) {
            _partialRow2 = @[ @(2) ];
        }
        return _partialRow2;
    }
}

- (WCTColumnsXRows *)partialRows
{
    @synchronized(self) {
        if (_partialRows == nil) {
            _partialRows = @[ self.partialRow1, self.partialRow2 ];
        }
        return _partialRows;
    }
}

- (WCTValue *)value1
{
    @synchronized(self) {
        if (_value1 == nil) {
            _value1 = @(1);
        }
        return _value1;
    }
}

- (WCTValue *)value2
{
    @synchronized(self) {
        if (_value2 == nil) {
            _value2 = @(2);
        }
        return _value2;
    }
}

- (WCTOneColumn *)column
{
    @synchronized(self) {
        if (_column == nil) {
            _column = @[ self.value1, self.value2 ];
        }
        return _column;
    }
}

#pragma mark - Database - Get Object
- (void)test_database_get_object
{
    [self doTestObject:self.object1
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.database getObjectOfClass:self.tableClass fromTable:self.tableName] ];
           }];
}

- (void)test_database_get_object_where
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier == 2 ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.database getObjectOfClass:self.tableClass fromTable:self.tableName where:TestCaseObject.identifier == 2] ];
           }];
}

- (void)test_database_get_object_orders
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.database getObjectOfClass:self.tableClass fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)] ];
           }];
}

- (void)test_database_get_object_offset
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.database getObjectOfClass:self.tableClass fromTable:self.tableName offset:1] ];
           }];
}

- (void)test_database_get_object_where_orders
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.database getObjectOfClass:self.tableClass fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)] ];
           }];
}

- (void)test_database_get_object_where_offset
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.database getObjectOfClass:self.tableClass fromTable:self.tableName where:TestCaseObject.identifier > 0 offset:1] ];
           }];
}

- (void)test_database_get_object_orders_offset
{
    [self doTestObject:self.object1
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.database getObjectOfClass:self.tableClass fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1] ];
           }];
}

- (void)test_database_get_object_where_orders_offset
{
    [self doTestObject:self.object1
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.database getObjectOfClass:self.tableClass fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1] ];
           }];
}

#pragma mark - Database - Get Objects
- (void)test_database_get_objects
{
    [self doTestObjects:self.objects
                 andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC"
            bySelecting:^NSArray<TestCaseObject *> * {
                return [self.database getObjectsOfClass:self.tableClass fromTable:self.tableName];
            }];
}

- (void)test_database_get_objects_where
{
    [self doTestObject:self.object1
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier == 1 ORDER BY rowid ASC"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.database getObjectsOfClass:self.tableClass fromTable:self.tableName where:TestCaseObject.identifier == 1];
           }];
}

- (void)test_database_get_objects_orders
{
    [self doTestObjects:self.objects.reversedArray
                 andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC"
            bySelecting:^NSArray<TestCaseObject *> * {
                return [self.database getObjectsOfClass:self.tableClass fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
            }];
}

- (void)test_database_get_objects_limit
{
    [self doTestObject:self.object1
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.database getObjectsOfClass:self.tableClass fromTable:self.tableName limit:1];
           }];
}

- (void)test_database_get_objects_where_orders
{
    [self doTestObjects:self.objects.reversedArray
                 andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC"
            bySelecting:^NSArray<TestCaseObject *> * {
                return [self.database getObjectsOfClass:self.tableClass fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
            }];
}

- (void)test_database_get_objects_where_limit
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 1 ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.database getObjectsOfClass:self.tableClass fromTable:self.tableName where:TestCaseObject.identifier > 1 limit:1];
           }];
}

- (void)test_database_get_objects_orders_limit
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.database getObjectsOfClass:self.tableClass fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
           }];
}

- (void)test_database_get_objects_limit_offset
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.database getObjectsOfClass:self.tableClass fromTable:self.tableName limit:1 offset:1];
           }];
}

- (void)test_database_get_objects_where_orders_limit
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.database getObjectsOfClass:self.tableClass fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
           }];
}

- (void)test_database_get_objects_where_limit_offset
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.database getObjectsOfClass:self.tableClass fromTable:self.tableName where:TestCaseObject.identifier > 0 limit:1 offset:1];
           }];
}

- (void)test_database_get_objects_orders_limit_offset
{
    [self doTestObject:self.object1
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.database getObjectsOfClass:self.tableClass fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
           }];
}

- (void)test_database_get_objects_where_orders_limit_offset
{
    [self doTestObject:self.object1
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.database getObjectsOfClass:self.tableClass fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
           }];
}

#pragma mark - Database - Get Part Of Object
- (void)test_database_get_object_on_result_columns
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.database getObjectOnResultColumns:TestCaseObject.identifier fromTable:self.tableName] ];
           }];
}

- (void)test_database_get_object_on_result_columns_where
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable WHERE identifier == 1 ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.database getObjectOnResultColumns:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier == 1] ];
           }];
}

- (void)test_database_get_object_on_result_columns_orders
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.database getObjectOnResultColumns:TestCaseObject.identifier fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)] ];
           }];
}

- (void)test_database_get_object_on_result_columns_offset
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.database getObjectOnResultColumns:TestCaseObject.identifier fromTable:self.tableName offset:1] ];
           }];
}

- (void)test_database_get_object_on_result_columns_where_orders
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.database getObjectOnResultColumns:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)] ];
           }];
}

- (void)test_database_get_object_on_result_columns_where_offset
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.database getObjectOnResultColumns:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 offset:1] ];
           }];
}

- (void)test_database_get_object_on_result_columns_orders_offset
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.database getObjectOnResultColumns:TestCaseObject.identifier fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1] ];
           }];
}

- (void)test_database_get_object_on_result_columns_where_orders_offset
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.database getObjectOnResultColumns:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1] ];
           }];
}

#pragma mark - Database - Get Part Of Objects
- (void)test_database_get_objects_on_result_columns
{
    [self doTestObjects:self.partialObjects
                 andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC"
            bySelecting:^NSArray<TestCaseObject *> * {
                return [self.database getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName];
            }];
}

- (void)test_database_get_objects_on_result_columns_where
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable WHERE identifier == 1 ORDER BY rowid ASC"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.database getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier == 1];
           }];
}

- (void)test_database_get_objects_on_result_columns_orders
{
    [self doTestObjects:self.partialObjects.reversedArray
                 andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC"
            bySelecting:^NSArray<TestCaseObject *> * {
                return [self.database getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
            }];
}

- (void)test_database_get_objects_on_result_columns_limit
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.database getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName limit:1];
           }];
}

- (void)test_database_get_objects_on_result_columns_where_orders
{
    [self doTestObjects:self.partialObjects.reversedArray
                 andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC"
            bySelecting:^NSArray<TestCaseObject *> * {
                return [self.database getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
            }];
}

- (void)test_database_get_objects_on_result_columns_where_limit
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 1 ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.database getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 1 limit:1];
           }];
}

- (void)test_database_get_objects_on_result_columns_orders_limit
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.database getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
           }];
}

- (void)test_database_get_objects_on_result_columns_limit_offset
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.database getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName limit:1 offset:1];
           }];
}

- (void)test_database_get_objects_on_result_columns_where_orders_limit
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.database getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
           }];
}

- (void)test_database_get_objects_on_result_columns_where_limit_offset
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.database getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 limit:1 offset:1];
           }];
}

- (void)test_database_get_objects_on_result_columns_orders_limit_offset
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.database getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
           }];
}

- (void)test_database_get_objects_on_result_columns_where_orders_limit_offset
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.database getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
           }];
}

#pragma mark - Database - Get Value
- (void)test_database_get_value
{
    [self doTestValue:@(self.object1.identifier)
               andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1"
          bySelecting:^WCTValue * {
              return [self.database getValueOnResultColumn:TestCaseObject.identifier fromTable:self.tableName];
          }];
}

- (void)test_database_get_value_where
{
    [self doTestValue:@(self.object2.identifier)
               andSQL:@"SELECT identifier FROM testTable WHERE identifier == 2 ORDER BY rowid ASC LIMIT 1"
          bySelecting:^WCTValue * {
              return [self.database getValueOnResultColumn:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier == 2];
          }];
}

- (void)test_database_get_value_orders
{
    [self doTestValue:@(self.object2.identifier)
               andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1"
          bySelecting:^WCTValue * {
              return [self.database getValueOnResultColumn:TestCaseObject.identifier fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
          }];
}

- (void)test_database_get_value_offset
{
    [self doTestValue:@(self.object2.identifier)
               andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
          bySelecting:^WCTValue * {
              return [self.database getValueOnResultColumn:TestCaseObject.identifier fromTable:self.tableName offset:1];
          }];
}

- (void)test_database_get_value_where_orders
{
    [self doTestValue:@(self.object2.identifier)
               andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
          bySelecting:^WCTValue * {
              return [self.database getValueOnResultColumn:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
          }];
}

- (void)test_database_get_value_where_offset
{
    [self doTestValue:@(self.object2.identifier)
               andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
          bySelecting:^WCTValue * {
              return [self.database getValueOnResultColumn:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 offset:1];
          }];
}

- (void)test_database_get_value_orders_offset
{
    [self doTestValue:@(self.object1.identifier)
               andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
          bySelecting:^WCTValue * {
              return [self.database getValueOnResultColumn:TestCaseObject.identifier fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1];
          }];
}

- (void)test_database_get_value_where_orders_offset
{
    [self doTestValue:@(self.object1.identifier)
               andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
          bySelecting:^WCTValue * {
              return [self.database getValueOnResultColumn:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1];
          }];
}

#pragma mark - Database - Get Row
- (void)test_database_get_row
{
    [self doTestRow:@[ @(self.object1.identifier), self.object1.content ]
             andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1"
        bySelecting:^WCTOneRow * {
            return [self.database getRowOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName];
        }];
}

- (void)test_database_get_row_where
{
    [self doTestRow:@[ @(self.object2.identifier), self.object2.content ]
             andSQL:@"SELECT identifier, content FROM testTable WHERE identifier == 2 ORDER BY rowid ASC LIMIT 1"
        bySelecting:^WCTOneRow * {
            return [self.database getRowOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName where:TestCaseObject.identifier == 2];
        }];
}

- (void)test_database_get_row_orders
{
    [self doTestRow:@[ @(self.object2.identifier), self.object2.content ]
             andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1"
        bySelecting:^WCTOneRow * {
            return [self.database getRowOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
        }];
}

- (void)test_database_get_row_offset
{
    [self doTestRow:@[ @(self.object2.identifier), self.object2.content ]
             andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
        bySelecting:^WCTOneRow * {
            return [self.database getRowOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName offset:1];
        }];
}

- (void)test_database_get_row_where_orders
{
    [self doTestRow:@[ @(self.object2.identifier), self.object2.content ]
             andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
        bySelecting:^WCTOneRow * {
            return [self.database getRowOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
        }];
}

- (void)test_database_get_row_where_offset
{
    [self doTestRow:@[ @(self.object2.identifier), self.object2.content ]
             andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
        bySelecting:^WCTOneRow * {
            return [self.database getRowOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName where:TestCaseObject.identifier > 0 offset:1];
        }];
}

- (void)test_database_get_row_orders_offset
{
    [self doTestRow:@[ @(self.object1.identifier), self.object1.content ]
             andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
        bySelecting:^WCTOneRow * {
            return [self.database getRowOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1];
        }];
}

- (void)test_database_get_row_where_orders_offset
{
    [self doTestRow:@[ @(self.object1.identifier), self.object1.content ]
             andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
        bySelecting:^WCTOneRow * {
            return [self.database getRowOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1];
        }];
}

#pragma mark - Database - Get Column
- (void)test_database_get_column
{
    [self doTestColumn:@[ @(self.object1.identifier), @(self.object2.identifier) ]
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC"
           bySelecting:^WCTOneColumn * {
               return [self.database getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName];
           }];
}

- (void)test_database_get_column_where
{
    [self doTestColumn:@[ @(self.object1.identifier) ]
                andSQL:@"SELECT identifier FROM testTable WHERE identifier == 1 ORDER BY rowid ASC"
           bySelecting:^WCTOneColumn * {
               return [self.database getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier == 1];
           }];
}

- (void)test_database_get_column_orders
{
    [self doTestColumn:@[ @(self.object2.identifier), @(self.object1.identifier) ]
                andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC"
           bySelecting:^WCTOneColumn * {
               return [self.database getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
           }];
}

- (void)test_database_get_column_limit
{
    [self doTestColumn:@[ @(self.object1.identifier) ]
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1"
           bySelecting:^WCTOneColumn * {
               return [self.database getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName limit:1];
           }];
}

- (void)test_database_get_column_where_orders
{
    [self doTestColumn:@[ @(self.object2.identifier), @(self.object1.identifier) ]
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC"
           bySelecting:^WCTOneColumn * {
               return [self.database getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
           }];
}

- (void)test_database_get_column_where_limit
{
    [self doTestColumn:@[ @(self.object2.identifier) ]
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 1 ORDER BY rowid ASC LIMIT 1"
           bySelecting:^WCTOneColumn * {
               return [self.database getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 1 limit:1];
           }];
}

- (void)test_database_get_column_orders_limit
{
    [self doTestColumn:@[ @(self.object2.identifier) ]
                andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1"
           bySelecting:^WCTOneColumn * {
               return [self.database getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
           }];
}

- (void)test_database_get_column_limit_offset
{
    [self doTestColumn:@[ @(self.object2.identifier) ]
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^WCTOneColumn * {
               return [self.database getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName limit:1 offset:1];
           }];
}

- (void)test_database_get_column_where_orders_limit
{
    [self doTestColumn:@[ @(self.object2.identifier) ]
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
           bySelecting:^WCTOneColumn * {
               return [self.database getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
           }];
}

- (void)test_database_get_column_where_limit_offset
{
    [self doTestColumn:@[ @(self.object2.identifier) ]
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^WCTOneColumn * {
               return [self.database getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 limit:1 offset:1];
           }];
}

- (void)test_database_get_column_orders_limit_offset
{
    [self doTestColumn:@[ @(self.object1.identifier) ]
                andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^WCTOneColumn * {
               return [self.database getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
           }];
}

- (void)test_database_get_column_where_orders_limit_offset
{
    [self doTestColumn:@[ @(self.object1.identifier) ]
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^WCTOneColumn * {
               return [self.database getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
           }];
}

#pragma mark - Database - Get Rows
- (void)test_database_get_rows
{
    [self doTestRows:@[ @[ @(self.object1.identifier), self.object1.content ],
                        @[ @(self.object2.identifier), self.object2.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC"
         bySelecting:^WCTColumnsXRows * {
             return [self.database getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName];
         }];
}

- (void)test_database_get_rows_where
{
    [self doTestRows:@[ @[ @(self.object1.identifier), self.object1.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable WHERE identifier == 1 ORDER BY rowid ASC"
         bySelecting:^WCTColumnsXRows * {
             return [self.database getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName where:TestCaseObject.identifier == 1];
         }];
}

- (void)test_database_get_rows_orders
{
    [self doTestRows:@[ @[ @(self.object2.identifier), self.object2.content ],
                        @[ @(self.object1.identifier), self.object1.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC"
         bySelecting:^WCTColumnsXRows * {
             return [self.database getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
         }];
}

- (void)test_database_get_rows_limit
{
    [self doTestRows:@[ @[ @(self.object1.identifier), self.object1.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1"
         bySelecting:^WCTColumnsXRows * {
             return [self.database getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName limit:1];
         }];
}

- (void)test_database_get_rows_where_orders
{
    [self doTestRows:@[ @[ @(self.object2.identifier), self.object2.content ],
                        @[ @(self.object1.identifier), self.object1.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC"
         bySelecting:^WCTColumnsXRows * {
             return [self.database getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
         }];
}

- (void)test_database_get_rows_where_limit
{
    [self doTestRows:@[ @[ @(self.object2.identifier), self.object2.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 1 ORDER BY rowid ASC LIMIT 1"
         bySelecting:^WCTColumnsXRows * {
             return [self.database getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName where:TestCaseObject.identifier > 1 limit:1];
         }];
}

- (void)test_database_get_rows_orders_limit
{
    [self doTestRows:@[ @[ @(self.object2.identifier), self.object2.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1"
         bySelecting:^WCTColumnsXRows * {
             return [self.database getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
         }];
}

- (void)test_database_get_rows_limit_offset
{
    [self doTestRows:@[ @[ @(self.object2.identifier), self.object2.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
         bySelecting:^WCTColumnsXRows * {
             return [self.database getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName limit:1 offset:1];
         }];
}

- (void)test_database_get_rows_where_orders_limit
{
    [self doTestRows:@[ @[ @(self.object2.identifier), self.object2.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
         bySelecting:^WCTColumnsXRows * {
             return [self.database getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
         }];
}

- (void)test_database_get_rows_where_limit_offset
{
    [self doTestRows:@[ @[ @(self.object2.identifier), self.object2.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
         bySelecting:^WCTColumnsXRows * {
             return [self.database getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName where:TestCaseObject.identifier > 0 limit:1 offset:1];
         }];
}

- (void)test_database_get_rows_orders_limit_offset
{
    [self doTestRows:@[ @[ @(self.object1.identifier), self.object1.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
         bySelecting:^WCTColumnsXRows * {
             return [self.database getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
         }];
}

- (void)test_database_get_rows_where_orders_limit_offset
{
    [self doTestRows:@[ @[ @(self.object1.identifier), self.object1.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
         bySelecting:^WCTColumnsXRows * {
             return [self.database getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
         }];
}

#pragma mark - Database - Get From Statement
- (void)test_database_get_row_from_statement
{
    [self doTestRow:self.partialRow1
             andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1"
        bySelecting:^WCTOneRow * {
            return [self.database getRowFromStatement:WCDB::StatementSelect().select(TestCaseObject.identifier).from(self.tableName).order(WCDB::OrderingTerm::ascendingRowid()).limit(1)];
        }];
}

- (void)test_database_get_column_from_statement
{
    [self doTestColumn:self.column
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC"
           bySelecting:^WCTOneColumn * {
               return [self.database getColumnFromStatement:WCDB::StatementSelect().select(TestCaseObject.identifier).from(self.tableName).order(WCDB::OrderingTerm::ascendingRowid())];
           }];
}

- (void)test_database_get_value_from_statement
{
    [self doTestValue:self.value1
               andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1"
          bySelecting:^WCTValue * {
              return [self.database getValueFromStatement:WCDB::StatementSelect().select(TestCaseObject.identifier).from(self.tableName).order(WCDB::OrderingTerm::ascendingRowid()).limit(1)];
          }];
}

- (void)test_database_get_rows_from_statement
{
    [self doTestRows:self.partialRows
              andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC"
         bySelecting:^WCTColumnsXRows * {
             return [self.database getRowsFromStatement:WCDB::StatementSelect().select(TestCaseObject.identifier).from(self.tableName).order(WCDB::OrderingTerm::ascendingRowid())];
         }];
}

#pragma mark - Table - Get Object
- (void)test_table_get_object
{
    [self doTestObject:self.object1
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.table getObject] ];
           }];
}

- (void)test_table_get_object_where
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier == 2 ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.table getObjectWhere:TestCaseObject.identifier == 2] ];
           }];
}

- (void)test_table_get_object_orders
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.table getObjectOrders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)] ];
           }];
}

- (void)test_table_get_object_offset
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.table getObjectOffset:1] ];
           }];
}

- (void)test_table_get_object_where_orders
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.table getObjectWhere:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)] ];
           }];
}

- (void)test_table_get_object_where_offset
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.table getObjectWhere:TestCaseObject.identifier > 0 offset:1] ];
           }];
}

- (void)test_table_get_object_orders_offset
{
    [self doTestObject:self.object1
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.table getObjectOrders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1] ];
           }];
}

- (void)test_table_get_object_where_orders_offset
{
    [self doTestObject:self.object1
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.table getObjectWhere:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1] ];
           }];
}

#pragma mark - Table - Get Objects
- (void)test_table_get_objects
{
    [self doTestObjects:self.objects
                 andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC"
            bySelecting:^NSArray<TestCaseObject *> * {
                return [self.table getObjects];
            }];
}

- (void)test_table_get_objects_where
{
    [self doTestObject:self.object1
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier == 1 ORDER BY rowid ASC"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.table getObjectsWhere:TestCaseObject.identifier == 1];
           }];
}

- (void)test_table_get_objects_orders
{
    [self doTestObjects:self.objects.reversedArray
                 andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC"
            bySelecting:^NSArray<TestCaseObject *> * {
                return [self.table getObjectsOrders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
            }];
}

- (void)test_table_get_objects_limit
{
    [self doTestObject:self.object1
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.table getObjectsLimit:1];
           }];
}

- (void)test_table_get_objects_where_orders
{
    [self doTestObjects:self.objects.reversedArray
                 andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC"
            bySelecting:^NSArray<TestCaseObject *> * {
                return [self.table getObjectsWhere:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
            }];
}

- (void)test_table_get_objects_where_limit
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 1 ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.table getObjectsWhere:TestCaseObject.identifier > 1 limit:1];
           }];
}

- (void)test_table_get_objects_orders_limit
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.table getObjectsOrders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
           }];
}

- (void)test_table_get_objects_limit_offset
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 2 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.table getObjectsOffset:1 limit:2];
           }];
}

- (void)test_table_get_objects_where_orders_limit
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.table getObjectsWhere:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
           }];
}

- (void)test_table_get_objects_where_limit_offset
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.table getObjectsWhere:TestCaseObject.identifier > 0 limit:1 offset:1];
           }];
}

- (void)test_table_get_objects_orders_limit_offset
{
    [self doTestObject:self.object1
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.table getObjectsOrders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
           }];
}

- (void)test_table_get_objects_where_orders_limit_offset
{
    [self doTestObject:self.object1
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.table getObjectsWhere:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
           }];
}

#pragma mark - Table - Get Part Of Object
- (void)test_table_get_object_on_result_columns
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.table getObjectOnResultColumns:TestCaseObject.identifier] ];
           }];
}

- (void)test_table_get_object_on_result_columns_where
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable WHERE identifier == 1 ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.table getObjectOnResultColumns:TestCaseObject.identifier where:TestCaseObject.identifier == 1] ];
           }];
}

- (void)test_table_get_object_on_result_columns_orders
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.table getObjectOnResultColumns:TestCaseObject.identifier orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)] ];
           }];
}

- (void)test_table_get_object_on_result_columns_offset
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.table getObjectOnResultColumns:TestCaseObject.identifier offset:1] ];
           }];
}

- (void)test_table_get_object_on_result_columns_where_orders
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.table getObjectOnResultColumns:TestCaseObject.identifier where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)] ];
           }];
}

- (void)test_table_get_object_on_result_columns_where_offset
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.table getObjectOnResultColumns:TestCaseObject.identifier where:TestCaseObject.identifier > 0 offset:1] ];
           }];
}

- (void)test_table_get_object_on_result_columns_orders_offset
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.table getObjectOnResultColumns:TestCaseObject.identifier orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1] ];
           }];
}

- (void)test_table_get_object_on_result_columns_where_orders_offset
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [self.table getObjectOnResultColumns:TestCaseObject.identifier where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1] ];
           }];
}

#pragma mark - Table - Get Part Of Objects
- (void)test_table_get_objects_on_result_columns
{
    [self doTestObjects:self.partialObjects
                 andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC"
            bySelecting:^NSArray<TestCaseObject *> * {
                return [self.table getObjectsOnResultColumns:TestCaseObject.identifier];
            }];
}

- (void)test_table_get_objects_on_result_columns_where
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable WHERE identifier == 1 ORDER BY rowid ASC"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.table getObjectsOnResultColumns:TestCaseObject.identifier where:TestCaseObject.identifier == 1];
           }];
}

- (void)test_table_get_objects_on_result_columns_orders
{
    [self doTestObjects:self.partialObjects.reversedArray
                 andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC"
            bySelecting:^NSArray<TestCaseObject *> * {
                return [self.table getObjectsOnResultColumns:TestCaseObject.identifier orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
            }];
}

- (void)test_table_get_objects_on_result_columns_limit
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.table getObjectsOnResultColumns:TestCaseObject.identifier limit:1];
           }];
}

- (void)test_table_get_objects_on_result_columns_where_orders
{
    [self doTestObjects:self.partialObjects.reversedArray
                 andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC"
            bySelecting:^NSArray<TestCaseObject *> * {
                return [self.table getObjectsOnResultColumns:TestCaseObject.identifier where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
            }];
}

- (void)test_table_get_objects_on_result_columns_where_limit
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 1 ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.table getObjectsOnResultColumns:TestCaseObject.identifier where:TestCaseObject.identifier > 1 limit:1];
           }];
}

- (void)test_table_get_objects_on_result_columns_orders_limit
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.table getObjectsOnResultColumns:TestCaseObject.identifier orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
           }];
}

- (void)test_table_get_objects_on_result_columns_limit_offset
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.table getObjectsOnResultColumns:TestCaseObject.identifier limit:1 offset:1];
           }];
}

- (void)test_table_get_objects_on_result_columns_where_orders_limit
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.table getObjectsOnResultColumns:TestCaseObject.identifier where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
           }];
}

- (void)test_table_get_objects_on_result_columns_where_limit_offset
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.table getObjectsOnResultColumns:TestCaseObject.identifier where:TestCaseObject.identifier > 0 limit:1 offset:1];
           }];
}

- (void)test_table_get_objects_on_result_columns_orders_limit_offset
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.table getObjectsOnResultColumns:TestCaseObject.identifier orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
           }];
}

- (void)test_table_get_objects_on_result_columns_where_orders_limit_offset
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [self.table getObjectsOnResultColumns:TestCaseObject.identifier where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
           }];
}

#pragma mark - Table - Get Value
- (void)test_table_get_value
{
    [self doTestValue:@(self.object1.identifier)
               andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1"
          bySelecting:^WCTValue * {
              return [self.table getValueOnResultColumn:TestCaseObject.identifier];
          }];
}

- (void)test_table_get_value_where
{
    [self doTestValue:@(self.object2.identifier)
               andSQL:@"SELECT identifier FROM testTable WHERE identifier == 2 ORDER BY rowid ASC LIMIT 1"
          bySelecting:^WCTValue * {
              return [self.table getValueOnResultColumn:TestCaseObject.identifier where:TestCaseObject.identifier == 2];
          }];
}

- (void)test_table_get_value_orders
{
    [self doTestValue:@(self.object2.identifier)
               andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1"
          bySelecting:^WCTValue * {
              return [self.table getValueOnResultColumn:TestCaseObject.identifier orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
          }];
}

- (void)test_table_get_value_offset
{
    [self doTestValue:@(self.object2.identifier)
               andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
          bySelecting:^WCTValue * {
              return [self.table getValueOnResultColumn:TestCaseObject.identifier offset:1];
          }];
}

- (void)test_table_get_value_where_orders
{
    [self doTestValue:@(self.object2.identifier)
               andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
          bySelecting:^WCTValue * {
              return [self.table getValueOnResultColumn:TestCaseObject.identifier where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
          }];
}

- (void)test_table_get_value_where_offset
{
    [self doTestValue:@(self.object2.identifier)
               andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
          bySelecting:^WCTValue * {
              return [self.table getValueOnResultColumn:TestCaseObject.identifier where:TestCaseObject.identifier > 0 offset:1];
          }];
}

- (void)test_table_get_value_orders_offset
{
    [self doTestValue:@(self.object1.identifier)
               andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
          bySelecting:^WCTValue * {
              return [self.table getValueOnResultColumn:TestCaseObject.identifier orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1];
          }];
}

- (void)test_table_get_value_where_orders_offset
{
    [self doTestValue:@(self.object1.identifier)
               andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
          bySelecting:^WCTValue * {
              return [self.table getValueOnResultColumn:TestCaseObject.identifier where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1];
          }];
}

#pragma mark - Table - Get Row
- (void)test_table_get_row
{
    [self doTestRow:@[ @(self.object1.identifier), self.object1.content ]
             andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1"
        bySelecting:^WCTOneRow * {
            return [self.table getRowOnResultColumns:TestCaseObject.allProperties];
        }];
}

- (void)test_table_get_row_where
{
    [self doTestRow:@[ @(self.object2.identifier), self.object2.content ]
             andSQL:@"SELECT identifier, content FROM testTable WHERE identifier == 2 ORDER BY rowid ASC LIMIT 1"
        bySelecting:^WCTOneRow * {
            return [self.table getRowOnResultColumns:TestCaseObject.allProperties where:TestCaseObject.identifier == 2];
        }];
}

- (void)test_table_get_row_orders
{
    [self doTestRow:@[ @(self.object2.identifier), self.object2.content ]
             andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1"
        bySelecting:^WCTOneRow * {
            return [self.table getRowOnResultColumns:TestCaseObject.allProperties orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
        }];
}

- (void)test_table_get_row_offset
{
    [self doTestRow:@[ @(self.object2.identifier), self.object2.content ]
             andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
        bySelecting:^WCTOneRow * {
            return [self.table getRowOnResultColumns:TestCaseObject.allProperties offset:1];
        }];
}

- (void)test_table_get_row_where_orders
{
    [self doTestRow:@[ @(self.object2.identifier), self.object2.content ]
             andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
        bySelecting:^WCTOneRow * {
            return [self.table getRowOnResultColumns:TestCaseObject.allProperties where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
        }];
}

- (void)test_table_get_row_where_offset
{
    [self doTestRow:@[ @(self.object2.identifier), self.object2.content ]
             andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
        bySelecting:^WCTOneRow * {
            return [self.table getRowOnResultColumns:TestCaseObject.allProperties where:TestCaseObject.identifier > 0 offset:1];
        }];
}

- (void)test_table_get_row_orders_offset
{
    [self doTestRow:@[ @(self.object1.identifier), self.object1.content ]
             andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
        bySelecting:^WCTOneRow * {
            return [self.table getRowOnResultColumns:TestCaseObject.allProperties orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1];
        }];
}

- (void)test_table_get_row_where_orders_offset
{
    [self doTestRow:@[ @(self.object1.identifier), self.object1.content ]
             andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
        bySelecting:^WCTOneRow * {
            return [self.table getRowOnResultColumns:TestCaseObject.allProperties where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1];
        }];
}

#pragma mark - Table - Get Column
- (void)test_table_get_column
{
    [self doTestColumn:@[ @(self.object1.identifier), @(self.object2.identifier) ]
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC"
           bySelecting:^WCTOneColumn * {
               return [self.table getColumnOnResultColumn:TestCaseObject.identifier];
           }];
}

- (void)test_table_get_column_where
{
    [self doTestColumn:@[ @(self.object1.identifier) ]
                andSQL:@"SELECT identifier FROM testTable WHERE identifier == 1 ORDER BY rowid ASC"
           bySelecting:^WCTOneColumn * {
               return [self.table getColumnOnResultColumn:TestCaseObject.identifier where:TestCaseObject.identifier == 1];
           }];
}

- (void)test_table_get_column_orders
{
    [self doTestColumn:@[ @(self.object2.identifier), @(self.object1.identifier) ]
                andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC"
           bySelecting:^WCTOneColumn * {
               return [self.table getColumnOnResultColumn:TestCaseObject.identifier orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
           }];
}

- (void)test_table_get_column_limit
{
    [self doTestColumn:@[ @(self.object1.identifier) ]
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1"
           bySelecting:^WCTOneColumn * {
               return [self.table getColumnOnResultColumn:TestCaseObject.identifier limit:1];
           }];
}

- (void)test_table_get_column_where_orders
{
    [self doTestColumn:@[ @(self.object2.identifier), @(self.object1.identifier) ]
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC"
           bySelecting:^WCTOneColumn * {
               return [self.table getColumnOnResultColumn:TestCaseObject.identifier where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
           }];
}

- (void)test_table_get_column_where_limit
{
    [self doTestColumn:@[ @(self.object2.identifier) ]
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 1 ORDER BY rowid ASC LIMIT 1"
           bySelecting:^WCTOneColumn * {
               return [self.table getColumnOnResultColumn:TestCaseObject.identifier where:TestCaseObject.identifier > 1 limit:1];
           }];
}

- (void)test_table_get_column_orders_limit
{
    [self doTestColumn:@[ @(self.object2.identifier) ]
                andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1"
           bySelecting:^WCTOneColumn * {
               return [self.table getColumnOnResultColumn:TestCaseObject.identifier orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
           }];
}

- (void)test_table_get_column_limit_offset
{
    [self doTestColumn:@[ @(self.object2.identifier) ]
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^WCTOneColumn * {
               return [self.table getColumnOnResultColumn:TestCaseObject.identifier limit:1 offset:1];
           }];
}

- (void)test_table_get_column_where_orders_limit
{
    [self doTestColumn:@[ @(self.object2.identifier) ]
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
           bySelecting:^WCTOneColumn * {
               return [self.table getColumnOnResultColumn:TestCaseObject.identifier where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
           }];
}

- (void)test_table_get_column_where_limit_offset
{
    [self doTestColumn:@[ @(self.object2.identifier) ]
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^WCTOneColumn * {
               return [self.table getColumnOnResultColumn:TestCaseObject.identifier where:TestCaseObject.identifier > 0 limit:1 offset:1];
           }];
}

- (void)test_table_get_column_orders_limit_offset
{
    [self doTestColumn:@[ @(self.object1.identifier) ]
                andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^WCTOneColumn * {
               return [self.table getColumnOnResultColumn:TestCaseObject.identifier orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
           }];
}

- (void)test_table_get_column_where_orders_limit_offset
{
    [self doTestColumn:@[ @(self.object1.identifier) ]
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^WCTOneColumn * {
               return [self.table getColumnOnResultColumn:TestCaseObject.identifier where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
           }];
}

#pragma mark - Table - Get Rows
- (void)test_table_get_rows
{
    [self doTestRows:@[ @[ @(self.object1.identifier), self.object1.content ],
                        @[ @(self.object2.identifier), self.object2.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC"
         bySelecting:^WCTColumnsXRows * {
             return [self.table getRowsOnResultColumns:TestCaseObject.allProperties];
         }];
}

- (void)test_table_get_rows_where
{
    [self doTestRows:@[ @[ @(self.object1.identifier), self.object1.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable WHERE identifier == 1 ORDER BY rowid ASC"
         bySelecting:^WCTColumnsXRows * {
             return [self.table getRowsOnResultColumns:TestCaseObject.allProperties where:TestCaseObject.identifier == 1];
         }];
}

- (void)test_table_get_rows_orders
{
    [self doTestRows:@[ @[ @(self.object2.identifier), self.object2.content ],
                        @[ @(self.object1.identifier), self.object1.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC"
         bySelecting:^WCTColumnsXRows * {
             return [self.table getRowsOnResultColumns:TestCaseObject.allProperties orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
         }];
}

- (void)test_table_get_rows_limit
{
    [self doTestRows:@[ @[ @(self.object1.identifier), self.object1.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1"
         bySelecting:^WCTColumnsXRows * {
             return [self.table getRowsOnResultColumns:TestCaseObject.allProperties limit:1];
         }];
}

- (void)test_table_get_rows_where_orders
{
    [self doTestRows:@[ @[ @(self.object2.identifier), self.object2.content ],
                        @[ @(self.object1.identifier), self.object1.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC"
         bySelecting:^WCTColumnsXRows * {
             return [self.table getRowsOnResultColumns:TestCaseObject.allProperties where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
         }];
}

- (void)test_table_get_rows_where_limit
{
    [self doTestRows:@[ @[ @(self.object2.identifier), self.object2.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 1 ORDER BY rowid ASC LIMIT 1"
         bySelecting:^WCTColumnsXRows * {
             return [self.table getRowsOnResultColumns:TestCaseObject.allProperties where:TestCaseObject.identifier > 1 limit:1];
         }];
}

- (void)test_table_get_rows_orders_limit
{
    [self doTestRows:@[ @[ @(self.object2.identifier), self.object2.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1"
         bySelecting:^WCTColumnsXRows * {
             return [self.table getRowsOnResultColumns:TestCaseObject.allProperties orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
         }];
}

- (void)test_table_get_rows_limit_offset
{
    [self doTestRows:@[ @[ @(self.object2.identifier), self.object2.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
         bySelecting:^WCTColumnsXRows * {
             return [self.table getRowsOnResultColumns:TestCaseObject.allProperties limit:1 offset:1];
         }];
}

- (void)test_table_get_rows_where_orders_limit
{
    [self doTestRows:@[ @[ @(self.object2.identifier), self.object2.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
         bySelecting:^WCTColumnsXRows * {
             return [self.table getRowsOnResultColumns:TestCaseObject.allProperties where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
         }];
}

- (void)test_table_get_rows_where_limit_offset
{
    [self doTestRows:@[ @[ @(self.object2.identifier), self.object2.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
         bySelecting:^WCTColumnsXRows * {
             return [self.table getRowsOnResultColumns:TestCaseObject.allProperties where:TestCaseObject.identifier > 0 limit:1 offset:1];
         }];
}

- (void)test_table_get_rows_orders_limit_offset
{
    [self doTestRows:@[ @[ @(self.object1.identifier), self.object1.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
         bySelecting:^WCTColumnsXRows * {
             return [self.table getRowsOnResultColumns:TestCaseObject.allProperties orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
         }];
}

- (void)test_table_get_rows_where_orders_limit_offset
{
    [self doTestRows:@[ @[ @(self.object1.identifier), self.object1.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
         bySelecting:^WCTColumnsXRows * {
             return [self.table getRowsOnResultColumns:TestCaseObject.allProperties where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
         }];
}

#pragma mark - Handle - Get Object
- (void)test_handle_get_object
{
    [self doTestObject:self.object1
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [[self.database getHandle] getObjectOfClass:self.tableClass fromTable:self.tableName] ];
           }];
}

- (void)test_handle_get_object_where
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier == 2 ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [[self.database getHandle] getObjectOfClass:self.tableClass fromTable:self.tableName where:TestCaseObject.identifier == 2] ];
           }];
}

- (void)test_handle_get_object_orders
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [[self.database getHandle] getObjectOfClass:self.tableClass fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)] ];
           }];
}

- (void)test_handle_get_object_offset
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [[self.database getHandle] getObjectOfClass:self.tableClass fromTable:self.tableName offset:1] ];
           }];
}

- (void)test_handle_get_object_where_orders
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [[self.database getHandle] getObjectOfClass:self.tableClass fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)] ];
           }];
}

- (void)test_handle_get_object_where_offset
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [[self.database getHandle] getObjectOfClass:self.tableClass fromTable:self.tableName where:TestCaseObject.identifier > 0 offset:1] ];
           }];
}

- (void)test_handle_get_object_orders_offset
{
    [self doTestObject:self.object1
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [[self.database getHandle] getObjectOfClass:self.tableClass fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1] ];
           }];
}

- (void)test_handle_get_object_where_orders_offset
{
    [self doTestObject:self.object1
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [[self.database getHandle] getObjectOfClass:self.tableClass fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1] ];
           }];
}

#pragma mark - Handle - Get Objects
- (void)test_handle_get_objects
{
    [self doTestObjects:self.objects
                 andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC"
            bySelecting:^NSArray<TestCaseObject *> * {
                return [[self.database getHandle] getObjectsOfClass:self.tableClass fromTable:self.tableName];
            }];
}

- (void)test_handle_get_objects_where
{
    [self doTestObject:self.object1
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier == 1 ORDER BY rowid ASC"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [[self.database getHandle] getObjectsOfClass:self.tableClass fromTable:self.tableName where:TestCaseObject.identifier == 1];
           }];
}

- (void)test_handle_get_objects_orders
{
    [self doTestObjects:self.objects.reversedArray
                 andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC"
            bySelecting:^NSArray<TestCaseObject *> * {
                return [[self.database getHandle] getObjectsOfClass:self.tableClass fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
            }];
}

- (void)test_handle_get_objects_limit
{
    [self doTestObject:self.object1
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [[self.database getHandle] getObjectsOfClass:self.tableClass fromTable:self.tableName limit:1];
           }];
}

- (void)test_handle_get_objects_where_orders
{
    [self doTestObjects:self.objects.reversedArray
                 andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC"
            bySelecting:^NSArray<TestCaseObject *> * {
                return [[self.database getHandle] getObjectsOfClass:self.tableClass fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
            }];
}

- (void)test_handle_get_objects_where_limit
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 1 ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [[self.database getHandle] getObjectsOfClass:self.tableClass fromTable:self.tableName where:TestCaseObject.identifier > 1 limit:1];
           }];
}

- (void)test_handle_get_objects_orders_limit
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [[self.database getHandle] getObjectsOfClass:self.tableClass fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
           }];
}

- (void)test_handle_get_objects_limit_offset
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [[self.database getHandle] getObjectsOfClass:self.tableClass fromTable:self.tableName limit:1 offset:1];
           }];
}

- (void)test_handle_get_objects_where_orders_limit
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [[self.database getHandle] getObjectsOfClass:self.tableClass fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
           }];
}

- (void)test_handle_get_objects_where_limit_offset
{
    [self doTestObject:self.object2
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [[self.database getHandle] getObjectsOfClass:self.tableClass fromTable:self.tableName where:TestCaseObject.identifier > 0 limit:1 offset:1];
           }];
}

- (void)test_handle_get_objects_orders_limit_offset
{
    [self doTestObject:self.object1
                andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [[self.database getHandle] getObjectsOfClass:self.tableClass fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
           }];
}

- (void)test_handle_get_objects_where_orders_limit_offset
{
    [self doTestObject:self.object1
                andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [[self.database getHandle] getObjectsOfClass:self.tableClass fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
           }];
}

#pragma mark - Handle - Get Part Of Object
- (void)test_handle_get_object_on_result_columns
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [[self.database getHandle] getObjectOnResultColumns:TestCaseObject.identifier fromTable:self.tableName] ];
           }];
}

- (void)test_handle_get_object_on_result_columns_where
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable WHERE identifier == 1 ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [[self.database getHandle] getObjectOnResultColumns:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier == 1] ];
           }];
}

- (void)test_handle_get_object_on_result_columns_orders
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [[self.database getHandle] getObjectOnResultColumns:TestCaseObject.identifier fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)] ];
           }];
}

- (void)test_handle_get_object_on_result_columns_offset
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [[self.database getHandle] getObjectOnResultColumns:TestCaseObject.identifier fromTable:self.tableName offset:1] ];
           }];
}

- (void)test_handle_get_object_on_result_columns_where_orders
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [[self.database getHandle] getObjectOnResultColumns:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)] ];
           }];
}

- (void)test_handle_get_object_on_result_columns_where_offset
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [[self.database getHandle] getObjectOnResultColumns:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 offset:1] ];
           }];
}

- (void)test_handle_get_object_on_result_columns_orders_offset
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [[self.database getHandle] getObjectOnResultColumns:TestCaseObject.identifier fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1] ];
           }];
}

- (void)test_handle_get_object_on_result_columns_where_orders_offset
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return @[ [[self.database getHandle] getObjectOnResultColumns:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1] ];
           }];
}

#pragma mark - Handle - Get Part Of Objects
- (void)test_handle_get_objects_on_result_columns
{
    [self doTestObjects:self.partialObjects
                 andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC"
            bySelecting:^NSArray<TestCaseObject *> * {
                return [[self.database getHandle] getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName];
            }];
}

- (void)test_handle_get_objects_on_result_columns_where
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable WHERE identifier == 1 ORDER BY rowid ASC"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [[self.database getHandle] getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier == 1];
           }];
}

- (void)test_handle_get_objects_on_result_columns_orders
{
    [self doTestObjects:self.partialObjects.reversedArray
                 andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC"
            bySelecting:^NSArray<TestCaseObject *> * {
                return [[self.database getHandle] getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
            }];
}

- (void)test_handle_get_objects_on_result_columns_limit
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [[self.database getHandle] getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName limit:1];
           }];
}

- (void)test_handle_get_objects_on_result_columns_where_orders
{
    [self doTestObjects:self.partialObjects.reversedArray
                 andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC"
            bySelecting:^NSArray<TestCaseObject *> * {
                return [[self.database getHandle] getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
            }];
}

- (void)test_handle_get_objects_on_result_columns_where_limit
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 1 ORDER BY rowid ASC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [[self.database getHandle] getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 1 limit:1];
           }];
}

- (void)test_handle_get_objects_on_result_columns_orders_limit
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [[self.database getHandle] getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
           }];
}

- (void)test_handle_get_objects_on_result_columns_limit_offset
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [[self.database getHandle] getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName limit:1 offset:1];
           }];
}

- (void)test_handle_get_objects_on_result_columns_where_orders_limit
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [[self.database getHandle] getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
           }];
}

- (void)test_handle_get_objects_on_result_columns_where_limit_offset
{
    [self doTestObject:self.partialObject2
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [[self.database getHandle] getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 limit:1 offset:1];
           }];
}

- (void)test_handle_get_objects_on_result_columns_orders_limit_offset
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [[self.database getHandle] getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
           }];
}

- (void)test_handle_get_objects_on_result_columns_where_orders_limit_offset
{
    [self doTestObject:self.partialObject1
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^NSArray<TestCaseObject *> * {
               return [[self.database getHandle] getObjectsOnResultColumns:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
           }];
}

#pragma mark - Handle - Get Value
- (void)test_handle_get_value
{
    [self doTestValue:@(self.object1.identifier)
               andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1"
          bySelecting:^WCTValue * {
              return [[self.database getHandle] getValueOnResultColumn:TestCaseObject.identifier fromTable:self.tableName];
          }];
}

- (void)test_handle_get_value_where
{
    [self doTestValue:@(self.object2.identifier)
               andSQL:@"SELECT identifier FROM testTable WHERE identifier == 2 ORDER BY rowid ASC LIMIT 1"
          bySelecting:^WCTValue * {
              return [[self.database getHandle] getValueOnResultColumn:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier == 2];
          }];
}

- (void)test_handle_get_value_orders
{
    [self doTestValue:@(self.object2.identifier)
               andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1"
          bySelecting:^WCTValue * {
              return [[self.database getHandle] getValueOnResultColumn:TestCaseObject.identifier fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
          }];
}

- (void)test_handle_get_value_offset
{
    [self doTestValue:@(self.object2.identifier)
               andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
          bySelecting:^WCTValue * {
              return [[self.database getHandle] getValueOnResultColumn:TestCaseObject.identifier fromTable:self.tableName offset:1];
          }];
}

- (void)test_handle_get_value_where_orders
{
    [self doTestValue:@(self.object2.identifier)
               andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
          bySelecting:^WCTValue * {
              return [[self.database getHandle] getValueOnResultColumn:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
          }];
}

- (void)test_handle_get_value_where_offset
{
    [self doTestValue:@(self.object2.identifier)
               andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
          bySelecting:^WCTValue * {
              return [[self.database getHandle] getValueOnResultColumn:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 offset:1];
          }];
}

- (void)test_handle_get_value_orders_offset
{
    [self doTestValue:@(self.object1.identifier)
               andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
          bySelecting:^WCTValue * {
              return [[self.database getHandle] getValueOnResultColumn:TestCaseObject.identifier fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1];
          }];
}

- (void)test_handle_get_value_where_orders_offset
{
    [self doTestValue:@(self.object1.identifier)
               andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
          bySelecting:^WCTValue * {
              return [[self.database getHandle] getValueOnResultColumn:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1];
          }];
}

#pragma mark - Handle - Get Row
- (void)test_handle_get_row
{
    [self doTestRow:@[ @(self.object1.identifier), self.object1.content ]
             andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1"
        bySelecting:^WCTOneRow * {
            return [[self.database getHandle] getRowOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName];
        }];
}

- (void)test_handle_get_row_where
{
    [self doTestRow:@[ @(self.object2.identifier), self.object2.content ]
             andSQL:@"SELECT identifier, content FROM testTable WHERE identifier == 2 ORDER BY rowid ASC LIMIT 1"
        bySelecting:^WCTOneRow * {
            return [[self.database getHandle] getRowOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName where:TestCaseObject.identifier == 2];
        }];
}

- (void)test_handle_get_row_orders
{
    [self doTestRow:@[ @(self.object2.identifier), self.object2.content ]
             andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1"
        bySelecting:^WCTOneRow * {
            return [[self.database getHandle] getRowOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
        }];
}

- (void)test_handle_get_row_offset
{
    [self doTestRow:@[ @(self.object2.identifier), self.object2.content ]
             andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
        bySelecting:^WCTOneRow * {
            return [[self.database getHandle] getRowOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName offset:1];
        }];
}

- (void)test_handle_get_row_where_orders
{
    [self doTestRow:@[ @(self.object2.identifier), self.object2.content ]
             andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
        bySelecting:^WCTOneRow * {
            return [[self.database getHandle] getRowOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
        }];
}

- (void)test_handle_get_row_where_offset
{
    [self doTestRow:@[ @(self.object2.identifier), self.object2.content ]
             andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
        bySelecting:^WCTOneRow * {
            return [[self.database getHandle] getRowOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName where:TestCaseObject.identifier > 0 offset:1];
        }];
}

- (void)test_handle_get_row_orders_offset
{
    [self doTestRow:@[ @(self.object1.identifier), self.object1.content ]
             andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
        bySelecting:^WCTOneRow * {
            return [[self.database getHandle] getRowOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1];
        }];
}

- (void)test_handle_get_row_where_orders_offset
{
    [self doTestRow:@[ @(self.object1.identifier), self.object1.content ]
             andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
        bySelecting:^WCTOneRow * {
            return [[self.database getHandle] getRowOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) offset:1];
        }];
}

#pragma mark - Handle - Get Column
- (void)test_handle_get_column
{
    [self doTestColumn:@[ @(self.object1.identifier), @(self.object2.identifier) ]
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC"
           bySelecting:^WCTOneColumn * {
               return [[self.database getHandle] getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName];
           }];
}

- (void)test_handle_get_column_where
{
    [self doTestColumn:@[ @(self.object1.identifier) ]
                andSQL:@"SELECT identifier FROM testTable WHERE identifier == 1 ORDER BY rowid ASC"
           bySelecting:^WCTOneColumn * {
               return [[self.database getHandle] getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier == 1];
           }];
}

- (void)test_handle_get_column_orders
{
    [self doTestColumn:@[ @(self.object2.identifier), @(self.object1.identifier) ]
                andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC"
           bySelecting:^WCTOneColumn * {
               return [[self.database getHandle] getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
           }];
}

- (void)test_handle_get_column_limit
{
    [self doTestColumn:@[ @(self.object1.identifier) ]
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1"
           bySelecting:^WCTOneColumn * {
               return [[self.database getHandle] getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName limit:1];
           }];
}

- (void)test_handle_get_column_where_orders
{
    [self doTestColumn:@[ @(self.object2.identifier), @(self.object1.identifier) ]
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC"
           bySelecting:^WCTOneColumn * {
               return [[self.database getHandle] getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
           }];
}

- (void)test_handle_get_column_where_limit
{
    [self doTestColumn:@[ @(self.object2.identifier) ]
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 1 ORDER BY rowid ASC LIMIT 1"
           bySelecting:^WCTOneColumn * {
               return [[self.database getHandle] getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 1 limit:1];
           }];
}

- (void)test_handle_get_column_orders_limit
{
    [self doTestColumn:@[ @(self.object2.identifier) ]
                andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1"
           bySelecting:^WCTOneColumn * {
               return [[self.database getHandle] getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
           }];
}

- (void)test_handle_get_column_limit_offset
{
    [self doTestColumn:@[ @(self.object2.identifier) ]
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^WCTOneColumn * {
               return [[self.database getHandle] getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName limit:1 offset:1];
           }];
}

- (void)test_handle_get_column_where_orders_limit
{
    [self doTestColumn:@[ @(self.object2.identifier) ]
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
           bySelecting:^WCTOneColumn * {
               return [[self.database getHandle] getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
           }];
}

- (void)test_handle_get_column_where_limit_offset
{
    [self doTestColumn:@[ @(self.object2.identifier) ]
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
           bySelecting:^WCTOneColumn * {
               return [[self.database getHandle] getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 limit:1 offset:1];
           }];
}

- (void)test_handle_get_column_orders_limit_offset
{
    [self doTestColumn:@[ @(self.object1.identifier) ]
                andSQL:@"SELECT identifier FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^WCTOneColumn * {
               return [[self.database getHandle] getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
           }];
}

- (void)test_handle_get_column_where_orders_limit_offset
{
    [self doTestColumn:@[ @(self.object1.identifier) ]
                andSQL:@"SELECT identifier FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
           bySelecting:^WCTOneColumn * {
               return [[self.database getHandle] getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
           }];
}

#pragma mark - Handle - Get Rows
- (void)test_handle_get_rows
{
    [self doTestRows:@[ @[ @(self.object1.identifier), self.object1.content ],
                        @[ @(self.object2.identifier), self.object2.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC"
         bySelecting:^WCTColumnsXRows * {
             return [[self.database getHandle] getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName];
         }];
}

- (void)test_handle_get_rows_where
{
    [self doTestRows:@[ @[ @(self.object1.identifier), self.object1.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable WHERE identifier == 1 ORDER BY rowid ASC"
         bySelecting:^WCTColumnsXRows * {
             return [[self.database getHandle] getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName where:TestCaseObject.identifier == 1];
         }];
}

- (void)test_handle_get_rows_orders
{
    [self doTestRows:@[ @[ @(self.object2.identifier), self.object2.content ],
                        @[ @(self.object1.identifier), self.object1.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC"
         bySelecting:^WCTColumnsXRows * {
             return [[self.database getHandle] getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
         }];
}

- (void)test_handle_get_rows_limit
{
    [self doTestRows:@[ @[ @(self.object1.identifier), self.object1.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1"
         bySelecting:^WCTColumnsXRows * {
             return [[self.database getHandle] getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName limit:1];
         }];
}

- (void)test_handle_get_rows_where_orders
{
    [self doTestRows:@[ @[ @(self.object2.identifier), self.object2.content ],
                        @[ @(self.object1.identifier), self.object1.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC"
         bySelecting:^WCTColumnsXRows * {
             return [[self.database getHandle] getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending)];
         }];
}

- (void)test_handle_get_rows_where_limit
{
    [self doTestRows:@[ @[ @(self.object2.identifier), self.object2.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 1 ORDER BY rowid ASC LIMIT 1"
         bySelecting:^WCTColumnsXRows * {
             return [[self.database getHandle] getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName where:TestCaseObject.identifier > 1 limit:1];
         }];
}

- (void)test_handle_get_rows_orders_limit
{
    [self doTestRows:@[ @[ @(self.object2.identifier), self.object2.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1"
         bySelecting:^WCTColumnsXRows * {
             return [[self.database getHandle] getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
         }];
}

- (void)test_handle_get_rows_limit_offset
{
    [self doTestRows:@[ @[ @(self.object2.identifier), self.object2.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable ORDER BY rowid ASC LIMIT 1 OFFSET 1"
         bySelecting:^WCTColumnsXRows * {
             return [[self.database getHandle] getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName limit:1 offset:1];
         }];
}

- (void)test_handle_get_rows_where_orders_limit
{
    [self doTestRows:@[ @[ @(self.object2.identifier), self.object2.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1"
         bySelecting:^WCTColumnsXRows * {
             return [[self.database getHandle] getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1];
         }];
}

- (void)test_handle_get_rows_where_limit_offset
{
    [self doTestRows:@[ @[ @(self.object2.identifier), self.object2.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY rowid ASC LIMIT 1 OFFSET 1"
         bySelecting:^WCTColumnsXRows * {
             return [[self.database getHandle] getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName where:TestCaseObject.identifier > 0 limit:1 offset:1];
         }];
}

- (void)test_handle_get_rows_orders_limit_offset
{
    [self doTestRows:@[ @[ @(self.object1.identifier), self.object1.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable ORDER BY identifier DESC LIMIT 1 OFFSET 1"
         bySelecting:^WCTColumnsXRows * {
             return [[self.database getHandle] getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
         }];
}

- (void)test_handle_get_rows_where_orders_limit_offset
{
    [self doTestRows:@[ @[ @(self.object1.identifier), self.object1.content ] ]
              andSQL:@"SELECT identifier, content FROM testTable WHERE identifier > 0 ORDER BY identifier DESC LIMIT 1 OFFSET 1"
         bySelecting:^WCTColumnsXRows * {
             return [[self.database getHandle] getRowsOnResultColumns:TestCaseObject.allProperties fromTable:self.tableName where:TestCaseObject.identifier > 0 orders:TestCaseObject.identifier.asOrder(WCTOrderedDescending) limit:1 offset:1];
         }];
}

#pragma mark - Handle - Get From Statement
- (void)test_handle_get_row_from_statement
{
    [self doTestRow:self.partialRow1
             andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1"
        bySelecting:^WCTOneRow * {
            return [[self.database getHandle] getRowFromStatement:WCDB::StatementSelect().select(TestCaseObject.identifier).from(self.tableName).order(WCDB::OrderingTerm::ascendingRowid()).limit(1)];
        }];
}

- (void)test_handle_get_column_from_statement
{
    [self doTestColumn:self.column
                andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC"
           bySelecting:^WCTOneColumn * {
               return [[self.database getHandle] getColumnFromStatement:WCDB::StatementSelect().select(TestCaseObject.identifier).from(self.tableName).order(WCDB::OrderingTerm::ascendingRowid())];
           }];
}

- (void)test_handle_get_value_from_statement
{
    [self doTestValue:self.value1
               andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC LIMIT 1"
          bySelecting:^WCTValue * {
              return [[self.database getHandle] getValueFromStatement:WCDB::StatementSelect().select(TestCaseObject.identifier).from(self.tableName).order(WCDB::OrderingTerm::ascendingRowid()).limit(1)];
          }];
}

- (void)test_handle_get_rows_from_statement
{
    [self doTestRows:self.partialRows
              andSQL:@"SELECT identifier FROM testTable ORDER BY rowid ASC"
         bySelecting:^WCTColumnsXRows * {
             return [[self.database getHandle] getRowsFromStatement:WCDB::StatementSelect().select(TestCaseObject.identifier).from(self.tableName).order(WCDB::OrderingTerm::ascendingRowid())];
         }];
}

@end
