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

@interface StatementAnalyzeTests : BaseTestCase

@end

@implementation StatementAnalyzeTests {
    WCDB::Schema schema;
    NSString* table;
    NSString* index;
}

- (void)setUp
{
    [super setUp];
    schema = @"testSchema";
    table = @"testTable";
    index = @"testIndex";
}

- (void)test_default_constructible
{
    WCDB::StatementAnalyze constructible;
    TestCaseAssertFalse(constructible.syntax().isValid());
    TestCaseAssertIterateEqual(constructible, std::list<WCDB::Syntax::Identifier::Type>());
    TestCaseAssertTrue(constructible.getDescription().empty());
}

- (void)test_get_type
{
    TestCaseAssertEqual(WCDB::StatementAnalyze().getType(), WCDB::SQL::Type::AnalyzeSTMT);
    TestCaseAssertEqual(WCDB::StatementAnalyze::type, WCDB::SQL::Type::AnalyzeSTMT);
}

- (void)test_analyze
{
    auto testingSQL = WCDB::StatementAnalyze().analyze();
    auto testingTypes = { WCDB::SQL::Type::AnalyzeSTMT };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"ANALYZE");
}

- (void)test_analyze_schema
{
    auto testingSQL = WCDB::StatementAnalyze().analyze().schema(schema);

    auto testingTypes = { WCDB::SQL::Type::AnalyzeSTMT, WCDB::SQL::Type::Schema };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"ANALYZE testSchema");
}

- (void)test_analyze_table
{
    auto testingSQL = WCDB::StatementAnalyze().analyze().schema(schema).table(table);

    auto testingTypes = { WCDB::SQL::Type::AnalyzeSTMT, WCDB::SQL::Type::Schema };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"ANALYZE testSchema.testTable");
}

- (void)test_analyze_table_without_schema
{
    auto testingSQL = WCDB::StatementAnalyze().analyze().table(table);

    auto testingTypes = { WCDB::SQL::Type::AnalyzeSTMT };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"ANALYZE testTable");
}

- (void)test_analyze_index
{
    auto testingSQL = WCDB::StatementAnalyze().analyze().schema(schema).index(index);

    auto testingTypes = { WCDB::SQL::Type::AnalyzeSTMT, WCDB::SQL::Type::Schema };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"ANALYZE testSchema.testIndex");
}

@end
