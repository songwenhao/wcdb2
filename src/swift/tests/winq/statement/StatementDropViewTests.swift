//
// Created by qiuwenchen on 2022/7/13.
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

import XCTest
#if TEST_WCDB_SWIFT
import WCDBSwift
#else
import WCDB
#endif

class StatementDropViewTests: BaseTestCase {

    func testStatementDropView() {

        WINQAssertEqual(StatementDropView().drop(view: "testView"), "DROP VIEW testView")

        WINQAssertEqual(StatementDropView().drop(view: "testView").ifExists(), "DROP VIEW IF EXISTS testView")

        WINQAssertEqual(StatementDropView().drop(view: "testView").of(schema: "testSchema"), "DROP VIEW testSchema.testView")

    }
}
