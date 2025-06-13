// Created by chenqiuwen on 2023/4/19.
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

#define WCDBJNIBindingFuncName(funcName) WCDBJNI(Binding, funcName)
#define WCDBJNIBindingObjectMethod(funcName, ...)                              \
    WCDBJNIObjectMethod(Binding, funcName, __VA_ARGS__)
#define WCDBJNIBindingObjectMethodWithNoArg(funcName)                          \
    WCDBJNIObjectMethodWithNoArg(Binding, funcName)
#define WCDBJNIBindingClassMethodWithNoArg(funcName)                           \
    WCDBJNIClassMethodWithNoArg(Binding, funcName)
#define WCDBJNIBindingClassMethod(funcName, ...)                               \
    WCDBJNIClassMethod(Binding, funcName, __VA_ARGS__)

jlong WCDBJNIBindingClassMethodWithNoArg(create);
void WCDBJNIBindingClassMethod(addColumnDef, jlong self, jlong columnDef);
void WCDBJNIBindingClassMethod(enableAutoIncrementForExistingTable, jlong self);
void WCDBJNIBindingClassMethod(
addIndex, jlong self, jstring indexNameOrSuffix, jboolean isFullName, jlong createIndex);
void WCDBJNIBindingClassMethod(addTableConstraint, jlong self, jlong constraint);
void WCDBJNIBindingClassMethod(configVirtualModule, jlong self, jstring moduleName);
void WCDBJNIBindingClassMethod(configVirtualModuleArgument, jlong self, jstring argument);
void WCDBJNIBindingClassMethod(configWithoutRowId, jlong self);
jboolean WCDBJNIBindingClassMethod(createTable, jlong self, jstring tableName, jlong handle);
jboolean
WCDBJNIBindingClassMethod(createVirtualTable, jlong self, jstring tableName, jlong handle);
jlong WCDBJNIBindingClassMethod(getBaseBinding, jlong self);
