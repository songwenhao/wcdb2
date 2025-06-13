// Created by chenqiuwen on 2023/3/31.
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
public class BindParameterTest {
    @Test
    public void test() {
        winqEqual(new BindParameter(1), "?1");
        winqEqual(new BindParameter("testName"), ":testName");
        winqEqual(BindParameter.at("testName"), "@testName");
        winqEqual(BindParameter.dollar("testName"), "$testName");
        winqEqual(BindParameter.colon("testName"), ":testName");
        winqEqual(BindParameter.bindParameters(5)[4], "?5");

        winqEqual(BindParameter.def, "?");
        winqEqual(BindParameter._1, "?1");
        winqEqual(BindParameter._2, "?2");
        winqEqual(BindParameter._3, "?3");
        winqEqual(BindParameter._4, "?4");
        winqEqual(BindParameter._5, "?5");
        winqEqual(BindParameter._6, "?6");
        winqEqual(BindParameter._7, "?7");
        winqEqual(BindParameter._8, "?8");
        winqEqual(BindParameter._9, "?9");
        winqEqual(BindParameter._10, "?10");

    }
}
