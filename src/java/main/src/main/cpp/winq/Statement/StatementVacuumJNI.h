// Created by qiuwenchen on 2023/6/13.
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

#pragma once

#include "WCDBJNI.h"

#define WCDBJNIStatementVacuumFuncName(funcName)                               \
    WCDBJNI(StatementVacuum, funcName)
#define WCDBJNIStatementVacuumObjectMethod(funcName, ...)                      \
    WCDBJNIObjectMethod(StatementVacuum, funcName, __VA_ARGS__)
#define WCDBJNIStatementVacuumObjectMethodWithNoArg(funcName)                  \
    WCDBJNIObjectMethodWithNoArg(StatementVacuum, funcName)
#define WCDBJNIStatementVacuumClassMethodWithNoArg(funcName)                   \
    WCDBJNIClassMethodWithNoArg(StatementVacuum, funcName)
#define WCDBJNIStatementVacuumClassMethod(funcName, ...)                       \
    WCDBJNIClassMethod(StatementVacuum, funcName, __VA_ARGS__)

jlong WCDBJNIStatementVacuumClassMethodWithNoArg(createCppObj);
void WCDBJNIStatementVacuumClassMethod(configSchema,
                                       jlong self,
                                       WCDBJNIObjectOrStringParameter(schema));
