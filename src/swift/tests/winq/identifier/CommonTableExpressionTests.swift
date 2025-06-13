//
// Created by qiuwenchen on 2022/5/30.
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

import Foundation
#if TEST_WCDB_SWIFT
import WCDBSwift
#else
import WCDB
#endif

class CommonTableExpressionTests: BaseTestCase {

    func testCommonTableExpression() {
        WINQAssertEqual(CommonTableExpression("testTable").as(StatementSelect().select(1)), "testTable AS(SELECT 1)")

        WINQAssertEqual(CommonTableExpression("testTable").column(Column(named: "testColumn1")).as(StatementSelect().select(1)), "testTable(testColumn1) AS(SELECT 1)")

        WINQAssertEqual(CommonTableExpression("testTable").column(Column(named: "testColumn1")).column(Column(named: "testColumn2")).as(StatementSelect().select(1)), "testTable(testColumn1, testColumn2) AS(SELECT 1)")
    }
}
