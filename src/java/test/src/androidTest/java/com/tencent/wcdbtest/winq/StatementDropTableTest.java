// Created by qiuwenchen on 2023/4/12.
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

package com.tencent.wcdbtest.winq;

import androidx.test.ext.junit.runners.AndroidJUnit4;

import com.tencent.wcdb.winq.*;

import static com.tencent.wcdbtest.base.WinqTool.winqEqual;

import org.junit.Test;
import org.junit.runner.RunWith;

@RunWith(AndroidJUnit4.class)
public class StatementDropTableTest {
    @Test
    public void test() {
        winqEqual(new StatementDropTable().dropTable("testTable"),
                "DROP TABLE testTable");

        winqEqual(new StatementDropTable().dropTable("testTable").ifExist(),
                "DROP TABLE IF EXISTS testTable");

        winqEqual(new StatementDropTable().dropTable("testTable").of("testSchema"),
                "DROP TABLE testSchema.testTable");

    }
}
