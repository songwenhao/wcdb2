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

@interface TableOrSubqueryTests : BaseTestCase

@end

@implementation TableOrSubqueryTests {
    WCDB::Schema schema;
    NSString* table;
    NSString* alias;
    NSString* index;
    NSString* function;
    WCDB::Expression expression1;
    WCDB::Expression expression2;
    WCDB::Expressions expressions;
    WCDB::TablesOrSubqueries tablesOrSubqueries;
    WCDB::Join join;
    WCDB::StatementSelect select;
}

- (void)setUp
{
    [super setUp];
    schema = @"testSchema";
    table = @"testTable";
    alias = @"testAliasTable";
    index = @"testIndex";
    function = @"testFunction";
    expression1 = 1;
    expression2 = 2;
    expressions = {
        expression1,
        expression2,
    };
    tablesOrSubqueries = {
        @"testTable1",
        @"testTable2",
    };
    join = WCDB::Join().table(@"testJoinTable");
    select = WCDB::StatementSelect().select(1);
}

- (void)test_default_constructible
{
    WCDB::TableOrSubquery constructible;
    TestCaseAssertFalse(constructible.syntax().isValid());
    TestCaseAssertIterateEqual(constructible, std::list<WCDB::Syntax::Identifier::Type>());
    TestCaseAssertTrue(constructible.getDescription().empty());
}

- (void)test_get_type
{
    TestCaseAssertEqual(WCDB::TableOrSubquery().getType(), WCDB::SQL::Type::TableOrSubquery);
    TestCaseAssertEqual(WCDB::TableOrSubquery::type, WCDB::SQL::Type::TableOrSubquery);
}

- (void)test_table
{
    auto testingSQL = WCDB::TableOrSubquery(table);

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"testTable");
}

- (void)test_table_with_schema
{
    auto testingSQL = WCDB::TableOrSubquery(table).schema(schema);

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::Schema };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"testSchema.testTable");
}

- (void)test_table_with_alias
{
    auto testingSQL = WCDB::TableOrSubquery(table).as(alias);

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"testTable AS testAliasTable");
}

- (void)test_table_with_index
{
    auto testingSQL = WCDB::TableOrSubquery(table).indexed(index);

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"testTable INDEXED BY testIndex");
}

- (void)test_table_without_index
{
    auto testingSQL = WCDB::TableOrSubquery(table).notIndexed();

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"testTable NOT INDEXED");
}

- (void)test_table_function
{
    auto testingSQL = WCDB::TableOrSubquery::function(function).invoke();

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"testFunction()");
}

- (void)test_table_function_with_schema
{
    auto testingSQL = WCDB::TableOrSubquery::function(function).schema(schema).invoke();

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::Schema };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"testSchema.testFunction()");
}

- (void)test_table_function_with_parameter
{
    auto testingSQL = WCDB::TableOrSubquery::function(function).invoke().argument(expression1);

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"testFunction(1)");
}

- (void)test_table_function_with_seperated_parameters
{
    auto testingSQL = WCDB::TableOrSubquery::function(function).invoke().argument(expression1).argument(expression2);

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"testFunction(1, 2)");
}

- (void)test_table_function_with_parameters
{
    auto testingSQL = WCDB::TableOrSubquery::function(function).invoke().arguments(expressions);

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"testFunction(1, 2)");
}

- (void)test_table_function_with_alias
{
    auto testingSQL = WCDB::TableOrSubquery::function(function).as(alias).invoke();

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"testFunction() AS testAliasTable");
}

- (void)test_tables_or_subqueries
{
    auto testingSQL = WCDB::TableOrSubquery(tablesOrSubqueries);

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::TableOrSubquery };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"(testTable1, testTable2)");
}

- (void)test_join
{
    auto testingSQL = WCDB::TableOrSubquery(join);

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::JoinClause, WCDB::SQL::Type::TableOrSubquery };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"(testJoinTable)");
}

- (void)test_select
{
    auto testingSQL = WCDB::TableOrSubquery(select);

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::SelectSTMT, WCDB::SQL::Type::SelectCore, WCDB::SQL::Type::ResultColumn, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"(SELECT 1)");
}

- (void)test_select_with_alias
{
    auto testingSQL = WCDB::TableOrSubquery(select).as(alias);

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::SelectSTMT, WCDB::SQL::Type::SelectCore, WCDB::SQL::Type::ResultColumn, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    TestCaseAssertIterateEqual(testingSQL, testingTypes);
    TestCaseAssertSQLEqual(testingSQL, @"(SELECT 1) AS testAliasTable");
}

- (void)test_master
{
    TestCaseAssertSQLEqual(WCDB::TableOrSubquery::master(), @"sqlite_master");
}

@end
