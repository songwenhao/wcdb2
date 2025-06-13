// Created by qiuwenchen on 2023/6/9.
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

#include "UpsertJNI.h"
#include "UpsertBridge.h"

jlong WCDBJNIUpsertClassMethodWithNoArg(createCppObj)
{
    return (jlong) WCDBUpsertCreate().innerValue;
}

void WCDBJNIUpsertClassMethod(configIndexedColumn,
                              jlong upsert,
                              WCDBJNIObjectOrStringArrayParameter(columns))
{
    WCDBJNIBridgeStruct(CPPUpsert, upsert);
    WCDBJNICreateObjectOrStringArrayCriticalWithAction(
    columns, WCDBUpsertConfigIndexdColumn2(upsertStruct, columns_commonArray));
}

void WCDBJNIUpsertClassMethod(configWhere, jlong upsert, jlong expression)
{
    WCDBJNIBridgeStruct(CPPUpsert, upsert);
    WCDBJNIBridgeStruct(CPPExpression, expression);
    WCDBUpsertConfigWhere(upsertStruct, expressionStruct);
}

void WCDBJNIUpsertClassMethod(configDoNothing, jlong upsert)
{
    WCDBJNIBridgeStruct(CPPUpsert, upsert);
    WCDBUpsertConfigDoNothing(upsertStruct);
}

void WCDBJNIUpsertClassMethod(configDoUpdate, jlong upsert)
{
    WCDBJNIBridgeStruct(CPPUpsert, upsert);
    WCDBUpsertConfigDoUpdate(upsertStruct);
}

void WCDBJNIUpsertClassMethod(configSetColumns,
                              jlong upsert,
                              WCDBJNIObjectOrStringArrayParameter(columns))
{
    WCDBJNIBridgeStruct(CPPUpsert, upsert);
    WCDBJNICreateObjectOrStringArrayCriticalWithAction(
    columns, WCDBUpsertConfigSetColumns2(upsertStruct, columns_commonArray));
}

void WCDBJNIUpsertClassMethod(configToValue, jlong upsert, WCDBJNICommonValueParameter(expression))
{
    WCDBJNIBridgeStruct(CPPUpsert, upsert);
    WCDBJNICreateCommonValue(expression, true);
    WCDBUpsertConfigToValue2(upsertStruct, expression_common);
    WCDBJNITryReleaseStringInCommonValue(expression);
}