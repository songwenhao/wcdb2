// Created by chenqiuwen on 2023/6/11.
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

#include "WCDBJNI.h"

#pragma once
#define WCDBJNIStatementAlterTableFuncName(funcName)                           \
    WCDBJNI(StatementAlterTable, funcName)
#define WCDBJNIStatementAlterTableObjectMethod(funcName, ...)                  \
    WCDBJNIObjectMethod(StatementAlterTable, funcName, __VA_ARGS__)
#define WCDBJNIStatementAlterTableClassMethodWithNoArg(funcName)               \
    WCDBJNIClassMethodWithNoArg(StatementAlterTable, funcName)
#define WCDBJNIStatementAlterTableClassMethod(funcName, ...)                   \
    WCDBJNIClassMethod(StatementAlterTable, funcName, __VA_ARGS__)

jlong WCDBJNIStatementAlterTableClassMethodWithNoArg(createCppObj);
void WCDBJNIStatementAlterTableClassMethod(configTable, jlong self, jstring table);
void WCDBJNIStatementAlterTableClassMethod(configSchema,
                                           jlong self,
                                           WCDBJNIObjectOrStringParameter(schema));
void WCDBJNIStatementAlterTableClassMethod(configRenameToTable, jlong self, jstring table);
void WCDBJNIStatementAlterTableClassMethod(configRenameColumn,
                                           jlong self,
                                           WCDBJNIObjectOrStringParameter(column));
void WCDBJNIStatementAlterTableClassMethod(configRenameToColumn,
                                           jlong self,
                                           WCDBJNIObjectOrStringParameter(column));
void WCDBJNIStatementAlterTableClassMethod(configAddColumn, jlong self, jlong columnDef);
