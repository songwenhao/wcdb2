// Created by qiuwenchen on 2023/3/30.
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

#include "ColumnJNI.h"
#include "ColumnBridge.h"

jlong WCDBJNIColumnClassMethodWithNoArg(createAll)
{
    return (jlong) WCDBColumnCreateAll().innerValue;
}

jlong WCDBJNIColumnClassMethodWithNoArg(createRowId)
{
    return (jlong) WCDBColumnCreateRowId().innerValue;
}

jlong WCDBJNIColumnClassMethod(createWithName, jstring name, jlong binding)
{
    WCDBJNIGetStringCritical(name);
    jlong ret
    = (jlong) WCDBColumnCreateWithName2(nameString, (const void *) binding).innerValue;
    WCDBJNIReleaseStringCritical(name);
    return ret;
}

jlong WCDBJNIColumnClassMethod(copy, jlong column)
{
    WCDBJNIBridgeStruct(CPPColumn, column);
    return (jlong) WCDBColumnCopy(columnStruct).innerValue;
}

void WCDBJNIColumnClassMethod(inTable, jlong column, jstring table)
{
    WCDBJNIGetStringCritical(table);
    WCDBJNIBridgeStruct(CPPColumn, column);
    WCDBColumnInTable(columnStruct, tableString);
    WCDBJNIReleaseStringCritical(table);
}

void WCDBJNIColumnClassMethod(ofSchema, jlong column, WCDBJNIObjectOrStringParameter(schema))
{
    WCDBJNIBridgeStruct(CPPColumn, column);
    WCDBJNICreateObjectOrStringCommonValue(schema, true);
    WCDBColumnOfSchema2(columnStruct, schema_common);
    WCDBJNITryReleaseStringInCommonValue(schema);
}

jlong WCDBJNIColumnClassMethod(configAlias, jlong column, jstring alias)
{
    WCDBJNIBridgeStruct(CPPColumn, column);
    WCDBJNIGetString(alias);
    jlong ret = (jlong) WCDBColumnConfigAlias(columnStruct, aliasString).innerValue;
    WCDBJNIReleaseString(alias);
    return ret;
}
