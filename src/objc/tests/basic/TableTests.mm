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

#import "TestCase.h"

@interface TableTests : TableTestCase

@end

@implementation TableTests

#pragma mark - Basic
- (void)test_drop_index_with_suffix
{
    TestCaseAssertTrue([self createTable]);

    [self doTestSQLs:@[ @"DROP INDEX IF EXISTS testTable_index" ]
         inOperation:^BOOL {
             return [self.table dropIndexWithSuffix:@"_index"];
         }];
}

- (void)test_index_with_suffix
{
    TestCaseAssertTrue([self createTable]);

    TestCaseAssertTrue([[self.table indexWithSuffix:@"_index"] isEqualToString:[self.table.tableName stringByAppendingString:@"_index"]]);
}

#pragma mark - Database
- (void)test_database_table_exists
{
    TestCaseAssertTrue([self createTable]);

    TestCaseAssertOptionalTrue([self.database tableExists:self.tableName]);

    TestCaseAssertOptionalFalse([self.database tableExists:@"nonexists"]);
}

- (void)test_database_drop_table
{
    [self doTestSQLs:@[ @"DROP TABLE IF EXISTS testTable" ]
         inOperation:^BOOL {
             return [self.database dropTable:self.tableName];
         }];
    TestCaseAssertOptionalFalse([self.database tableExists:self.tableName]);
}

- (void)test_database_drop_index
{
    [self doTestSQLs:@[ @"DROP INDEX IF EXISTS testTable_index" ]
         inOperation:^BOOL {
             return [self.database dropIndex:@"testTable_index"];
         }];
}

#pragma mark - Handle
- (void)test_handle_table_exists
{
    TestCaseAssertTrue([self createTable]);

    WCTHandle* handle = [self.database getHandle];

    TestCaseAssertOptionalTrue([handle tableExists:self.tableName]);

    TestCaseAssertOptionalFalse([handle tableExists:@"nonexists"]);
}

- (void)test_handle_drop_table
{
    WCTHandle* handle = [self.database getHandle];
    [self doTestSQLs:@[ @"DROP TABLE IF EXISTS testTable" ]
         inOperation:^BOOL {
             return [handle dropTable:self.tableName];
         }];
    TestCaseAssertOptionalFalse([handle tableExists:self.tableName]);
}

- (void)test_handle_drop_index
{
    WCTHandle* handle = [self.database getHandle];
    [self doTestSQLs:@[ @"DROP INDEX IF EXISTS testTable_index" ]
         inOperation:^BOOL {
             return [handle dropIndex:@"testTable_index"];
         }];
}

@end
