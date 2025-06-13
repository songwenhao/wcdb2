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

@interface StoppableIterationTests : BaseTestCase

@end

@implementation StoppableIterationTests

- (void)test
{
    auto testingSQL = WCDB::StatementInsert().insertIntoTable("testTable").schema("testSchema").column(WCDB::Column("testColumn")).values(1);

    std::list<WCDB::Syntax::Identifier::Type> types;
    testingSQL.iterate([&types](WCDB::Syntax::Identifier& identifier, bool begin, bool& stop) {
        if (!begin) {
            return;
        }
        types.push_back(identifier.getType());
        if (identifier.getType() == WCDB::Syntax::Identifier::Type::Schema) {
            stop = true;
        }
    });

    std::list<WCDB::Syntax::Identifier::Type> testingTypes = { WCDB::SQL::Type::InsertSTMT, WCDB::SQL::Type::Schema };

    TestCaseAssertTypesEqual(types, testingTypes);
}

@end
