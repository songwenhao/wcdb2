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

#import "ColumnCodingObject+WCTTableCoding.h"
#import "ColumnCodingObject.h"
#import "Random+ColumnCodingObject.h"
#import "TestCase.h"

@interface ColumnCodingTests : CRUDTestCase

@end

@implementation ColumnCodingTests

- (void)setUp
{
    [super setUp];
    self.tableClass = ColumnCodingObject.class;

    TestCaseAssertTrue([self createTable]);
    [self.database close];
}

- (void)test
{
    ColumnCodingObject* object = [Random.shared columnCodingObject];

    [self doTestObjects:@[ object ]
              andNumber:1
           ofInsertSQLs:@"INSERT INTO testTable(integerObject, doubleObject, stringObject, dataObject) VALUES(?1, ?2, ?3, ?4)"
         afterInsertion:^BOOL {
             return [self.database insertObject:object intoTable:self.tableName];
         }];
}

@end
