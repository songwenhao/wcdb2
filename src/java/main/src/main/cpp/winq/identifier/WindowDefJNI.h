// Created by chenqiuwen on 2023/6/10.
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

#define WCDBJNIWindowDefFuncName(funcName) WCDBJNI(WindowDef, funcName)
#define WCDBJNIWindowDefObjectMethod(funcName, ...)                            \
    WCDBJNIObjectMethod(WindowDef, funcName, __VA_ARGS__)
#define WCDBJNIWindowDefClassMethodWithNoArg(funcName)                         \
    WCDBJNIClassMethodWithNoArg(WindowDef, funcName)
#define WCDBJNIWindowDefClassMethod(funcName, ...)                             \
    WCDBJNIClassMethod(WindowDef, funcName, __VA_ARGS__)

jlong WCDBJNIWindowDefClassMethodWithNoArg(createCppObj);
void WCDBJNIWindowDefClassMethod(configPartitions,
                                 jlong self,
                                 WCDBJNIMultiTypeArrayParameter(partitions));
void WCDBJNIWindowDefClassMethod(configOrders, jlong self, jlongArray orders);
void WCDBJNIWindowDefClassMethod(configFrameSpec, jlong self, jlong frameSpec);
