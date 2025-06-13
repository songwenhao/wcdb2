// Created by qiuwenchen on 2023/6/25.
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

package com.tencent.wcdbtest.orm.testclass

import com.tencent.wcdb.*

@WCDBTableCoding(
    multiPrimaries = [MultiPrimary(columns = ["multiPrimary1", "multiPrimary2", "multiPrimary3"])],
    multiUnique = [MultiUnique(columns = ["multiUnique1", "multiUnique2", "multiUnique3"])],
    multiIndexes = [
        MultiIndexes(
            name = "specifiedNameIndex",
            columns = ["multiIndex1", "multiIndex2", "multiIndex3"]
        ),
        MultiIndexes(columns = ["multiIndex1", "multiIndex2"])
    ]
)
class TableConstraintObject {
    @WCDBField
    var multiPrimary1 = 0

    @WCDBField
    var multiPrimary2 = 0

    @WCDBField(columnName = "multiPrimary3")
    var multiPrimary = 0

    @WCDBField
    var multiUnique1 = 0

    @WCDBField
    var multiUnique2 = 0

    @WCDBField(columnName = "multiUnique3")
    var multiUnique = 0

    @WCDBField
    var multiIndex1 = 0

    @WCDBField
    var multiIndex2 = 0

    @WCDBField(columnName = "multiIndex3")
    var multiIndex = 0
}