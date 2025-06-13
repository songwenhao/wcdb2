//
// Created by qiuwenchen on 2022/5/27.
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

class BindParameterTests: BaseTestCase {

    func testBindParameter() {
        WINQAssertEqual(BindParameter(1), "?1")

        WINQAssertEqual(BindParameter("testName"), ":testName")

        WINQAssertEqual(BindParameter.at(named: "testName"), "@testName")

        WINQAssertEqual(BindParameter.dollar(named: "testName"), "$testName")

        WINQAssertEqual(BindParameter.colon(named: "testName"), ":testName")

        WINQAssertEqual(BindParameter.def, "?")
        WINQAssertEqual(BindParameter._1, "?1")
        WINQAssertEqual(BindParameter._2, "?2")
        WINQAssertEqual(BindParameter._3, "?3")
        WINQAssertEqual(BindParameter._4, "?4")
        WINQAssertEqual(BindParameter._5, "?5")
        WINQAssertEqual(BindParameter._6, "?6")
        WINQAssertEqual(BindParameter._7, "?7")
        WINQAssertEqual(BindParameter._8, "?8")
        WINQAssertEqual(BindParameter._9, "?9")
        WINQAssertEqual(BindParameter._10, "?10")
    }
}
