// Created by chenqiuwen on 2023/4/8.
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

#include "QualifiedTableJNI.h"
#include "QualifiedTableBridge.h"

jlong WCDBJNIQualifiedTableClassMethod(create, jstring tableName)
{
    WCDBJNIGetStringCritical(tableName);
    jlong ret = (jlong) WCDBQualifiedTableCreateWithTable(tableNameString).innerValue;
    WCDBJNIReleaseStringCritical(tableName);
    return ret;
}

void WCDBJNIQualifiedTableClassMethod(configSchema, jlong self, WCDBJNIObjectOrStringParameter(schema))
{
    WCDBJNIBridgeStruct(CPPQualifiedTable, self);
    WCDBJNICreateObjectOrStringCommonValue(schema, true);
    WCDBQualifiedTableConfigSchema2(selfStruct, schema_common);
    WCDBJNITryReleaseStringInCommonValue(schema);
}

void WCDBJNIQualifiedTableClassMethod(configAlias, jlong self, jstring alias)
{
    WCDBJNIBridgeStruct(CPPQualifiedTable, self);
    WCDBJNIGetStringCritical(alias);
    WCDBQualifiedTableConfigAliasName(selfStruct, aliasString);
    WCDBJNIReleaseStringCritical(alias);
}

void WCDBJNIQualifiedTableClassMethod(configIndex, jlong self, jstring index)
{
    WCDBJNIBridgeStruct(CPPQualifiedTable, self);
    WCDBJNIGetStringCritical(index);
    WCDBQualifiedTableConfigIndexName(selfStruct, indexString);
    WCDBJNIReleaseStringCritical(index);
}

void WCDBJNIQualifiedTableClassMethod(configNotIndexed, jlong self)
{
    WCDBJNIBridgeStruct(CPPQualifiedTable, self);
    WCDBQualifiedTableConfigNoIndexed(selfStruct);
}