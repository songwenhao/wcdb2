// Created by qiuwenchen on 2023/6/12.
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

#define WCDBJNIStatementRollbackFuncName(funcName)                             \
    WCDBJNI(StatementRollback, funcName)
#define WCDBJNIStatementRollbackObjectMethod(funcName, ...)                    \
    WCDBJNIObjectMethod(StatementRollback, funcName, __VA_ARGS__)
#define WCDBJNIStatementRollbackObjectMethodWithNoArg(funcName)                \
    WCDBJNIObjectMethodWithNoArg(StatementRollback, funcName)
#define WCDBJNIStatementRollbackClassMethodWithNoArg(funcName)                 \
    WCDBJNIClassMethodWithNoArg(StatementRollback, funcName)
#define WCDBJNIStatementRollbackClassMethod(funcName, ...)                     \
    WCDBJNIClassMethod(StatementRollback, funcName, __VA_ARGS__)

jlong WCDBJNIStatementRollbackClassMethodWithNoArg(createCppObj);
void WCDBJNIStatementRollbackClassMethod(configSavepoint, jlong self, jstring savepoint);
