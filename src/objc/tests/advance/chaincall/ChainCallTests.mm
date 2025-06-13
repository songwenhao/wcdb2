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

@interface ChainCallTests : CRUDTestCase

@end

@implementation ChainCallTests

- (void)setUp
{
    [super setUp];
    [self insertPresetObjects];
}

#pragma mark - Delete
- (void)test_database_delete
{
    WCTDelete* delete_ = [[self.database prepareDelete] fromTable:self.tableName];
    TestCaseAssertSQLEqual(delete_.statement, @"DELETE FROM testTable");
}

- (void)test_table_delete
{
    WCTDelete* delete_ = [self.table prepareDelete];
    TestCaseAssertSQLEqual(delete_.statement, @"DELETE FROM testTable");
}

- (void)test_handle_delete
{
    WCTDelete* delete_ = [[[self.database getHandle] prepareDelete] fromTable:self.tableName];
    TestCaseAssertSQLEqual(delete_.statement, @"DELETE FROM testTable");
}

#pragma mark - Insert
- (void)test_database_insert
{
    WCTInsert* insert = [[[self.database prepareInsert] onProperties:TestCaseObject.allProperties] intoTable:self.tableName];
    TestCaseAssertSQLEqual(insert.statement, @"INSERT INTO testTable(identifier, content) VALUES(?1, ?2)");
}

- (void)test_table_insert
{
    WCTInsert* insert = [[self.table prepareInsert] onProperties:TestCaseObject.allProperties];
    TestCaseAssertSQLEqual(insert.statement, @"INSERT INTO testTable(identifier, content) VALUES(?1, ?2)");
}

- (void)test_handle_insert
{
    WCTInsert* insert = [[[[self.database getHandle] prepareInsert] onProperties:TestCaseObject.allProperties] intoTable:self.tableName];
    TestCaseAssertSQLEqual(insert.statement, @"INSERT INTO testTable(identifier, content) VALUES(?1, ?2)");
}

#pragma mark - Update
- (void)test_database_update
{
    WCTUpdate* update = [[[self.database prepareUpdate] table:self.tableName] set:TestCaseObject.content];
    TestCaseAssertSQLEqual(update.statement, @"UPDATE testTable SET content = ?1");
}

- (void)test_table_update
{
    WCTUpdate* update = [[self.table prepareUpdate] set:TestCaseObject.content];
    TestCaseAssertSQLEqual(update.statement, @"UPDATE testTable SET content = ?1");
}

- (void)test_handle_update
{
    WCTUpdate* update = [[[[self.database getHandle] prepareUpdate] table:self.tableName] set:TestCaseObject.content];
    TestCaseAssertSQLEqual(update.statement, @"UPDATE testTable SET content = ?1");
}

#pragma mark - Select
- (void)test_database_select
{
    WCTSelect* select = [[[self.database prepareSelect] onResultColumns:TestCaseObject.allProperties] fromTable:self.tableName];
    TestCaseAssertSQLEqual(select.statement, @"SELECT identifier, content FROM testTable");
}

- (void)test_table_select
{
    WCTSelect* select = [[self.table prepareSelect] onResultColumns:TestCaseObject.allProperties];
    TestCaseAssertSQLEqual(select.statement, @"SELECT identifier, content FROM testTable");
}

- (void)test_handle_select
{
    WCTSelect* select = [[[[self.database getHandle] prepareSelect] onResultColumns:TestCaseObject.allProperties] fromTable:self.tableName];
    TestCaseAssertSQLEqual(select.statement, @"SELECT identifier, content FROM testTable");
}

- (void)test_check_next_object_failed_using_done
{
    WCTSelect* select = [[[[self.database prepareSelect] onResultColumns:TestCaseObject.allProperties] fromTable:self.tableName] limit:1];

    [WCTDatabase simulateIOError:WCTSimulateWriteIOError | WCTSimulateReadIOError];
    // oneObject is nil due to IOError, so done is false.
    TestCaseAssertTrue([select firstObject] == nil);

    [WCTDatabase simulateIOError:WCTSimulateNoneIOError];
    // oneObject is not nil, so done is false.
    select = [[[[self.database prepareSelect] onResultColumns:TestCaseObject.allProperties] fromTable:self.tableName] limit:1];
    TestCaseAssertTrue([select firstObject] != nil);
}

#pragma mark - Multi Select
- (void)test_database_multi_select
{
    NSString* tableName2 = @"testTable2";
    WCTResultColumns resultColumns = {
        TestCaseObject.content.redirect(TestCaseObject.content.table(self.tableName)),
        TestCaseObject.content.redirect(TestCaseObject.content.table(tableName2)),
    };
    WCTMultiSelect* select = [[[[self.database prepareMultiSelect] onResultColumns:resultColumns] fromTables:@[ self.tableName, tableName2 ]] where:TestCaseObject.identifier.table(self.tableName) == TestCaseObject.identifier.table(tableName2)];
    TestCaseAssertSQLEqual(select.statement, @"SELECT testTable.content, testTable2.content FROM testTable, testTable2 WHERE testTable.identifier == testTable2.identifier");
}

- (void)test_handle_multi_select
{
    NSString* tableName2 = @"testTable2";
    WCTResultColumns resultColumns = {
        TestCaseObject.content.redirect(TestCaseObject.content.table(self.tableName)),
        TestCaseObject.content.redirect(TestCaseObject.content.table(tableName2)),
    };
    WCTMultiSelect* select = [[[[[self.database getHandle] prepareMultiSelect] onResultColumns:resultColumns] fromTables:@[ self.tableName, tableName2 ]] where:TestCaseObject.identifier.table(self.tableName) == TestCaseObject.identifier.table(tableName2)];
    TestCaseAssertSQLEqual(select.statement, @"SELECT testTable.content, testTable2.content FROM testTable, testTable2 WHERE testTable.identifier == testTable2.identifier");
}

@end
