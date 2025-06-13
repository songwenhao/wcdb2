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

#import "WINQAssertion.h"

@interface StatementReindexTests : BaseTestCase

@end

@implementation StatementReindexTests {
    WCDB::Schema schema;
    NSString* collation;
    NSString* table;
    NSString* index;
}

- (void)setUp
{
    [super setUp];
    collation = @"testCollation";
    schema = @"testSchema";
    table = @"testTable";
    index = @"testIndex";
}

- (void)test_default_constructible
{
    WCDB::StatementReindex constructible;
    TestCaseAssertFalse(constructible.syntax().isValid());
    TestCaseAssertIterateEqual(constructible, std::list<WCDB::Syntax::Identifier::Type>());
    TestCaseAssertTrue(constructible.getDescription().empty());
}

- (void)test_get_type
{
    TestCaseAssertEqual(WCDB::StatementReindex().getType(), WCDB::SQL::Type::ReindexSTMT);
    TestCaseAssertEqual(WCDB::StatementReindex::type, WCDB::SQL::Type::ReindexSTMT);
}

- (void)test_reindex
{
    auto testingSQL = WCDB::StatementReindex().reindex();

    auto testingTypes = { WCDB::SQL::Type::ReindexSTMT };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"REINDEX");
}

- (void)test_reindex_collation
{
    auto testingSQL = WCDB::StatementReindex().reindex().collation(collation);

    auto testingTypes = { WCDB::SQL::Type::ReindexSTMT };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"REINDEX testCollation");
}

- (void)test_reindex_table
{
    auto testingSQL = WCDB::StatementReindex().reindex().schema(schema).table(table);

    auto testingTypes = { WCDB::SQL::Type::ReindexSTMT, WCDB::SQL::Type::Schema };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"REINDEX testSchema.testTable");
}

- (void)test_reindex_table_without_schema
{
    auto testingSQL = WCDB::StatementReindex().reindex().table(table);

    auto testingTypes = { WCDB::SQL::Type::ReindexSTMT };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"REINDEX testTable");
}

- (void)test_reindex_index
{
    auto testingSQL = WCDB::StatementReindex().reindex().schema(schema).index(index);

    auto testingTypes = { WCDB::SQL::Type::ReindexSTMT, WCDB::SQL::Type::Schema };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"REINDEX testSchema.testIndex");
}

- (void)test_reindex_index_without_schema
{
    auto testingSQL = WCDB::StatementReindex().reindex().index(index);

    auto testingTypes = { WCDB::SQL::Type::ReindexSTMT };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"REINDEX testIndex");
}

@end
