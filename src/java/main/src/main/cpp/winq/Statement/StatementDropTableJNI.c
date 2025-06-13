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

#include "StatementDropTableJNI.h"
#include "StatementDropTableBridge.h"

jlong WCDBJNIStatementDropTableClassMethodWithNoArg(create)
{
    return (jlong) WCDBStatementDropTableCreate().innerValue;
}

void WCDBJNIStatementDropTableClassMethod(configSchema,
                                          jlong self,
                                          WCDBJNIObjectOrStringParameter(schema))
{
    WCDBJNIBridgeStruct(CPPStatementDropTable, self);
    WCDBJNICreateObjectOrStringCommonValue(schema, true);
    WCDBStatementDropTableConfigSchema2(selfStruct, schema_common);
    WCDBJNITryReleaseStringInCommonValue(schema);
}

void WCDBJNIStatementDropTableClassMethod(configTableName, jlong self, jstring tableName)
{
    WCDBJNIBridgeStruct(CPPStatementDropTable, self);
    WCDBJNIGetStringCritical(tableName);
    WCDBStatementDropTableConfigTable(selfStruct, tableNameString);
    WCDBJNIReleaseStringCritical(tableName);
}

void WCDBJNIStatementDropTableClassMethod(configIfExist, jlong self)
{
    WCDBJNIBridgeStruct(CPPStatementDropTable, self);
    WCDBStatementDropTableConfigIfExists(selfStruct);
}