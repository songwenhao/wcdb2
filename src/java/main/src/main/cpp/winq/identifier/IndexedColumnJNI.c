// Created by qiuwenchen on 2023/4/7.
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

#include "IndexedColumnJNI.h"
#include "IndexedColumnBridge.h"

jlong WCDBJNIIndexedColumnClassMethod(create, WCDBJNIObjectOrStringParameter(column))
{
    WCDBJNICreateObjectOrStringCommonValue(column, true);
    jlong ret = (jlong) WCDBIndexedColumnCreate(column_common).innerValue;
    WCDBJNITryReleaseStringInCommonValue(column);
    return ret;
}

void WCDBJNIIndexedColumnClassMethod(configCollation, jlong indexedColumn, jstring collation)
{
    WCDBJNIBridgeStruct(CPPIndexedColumn, indexedColumn);
    WCDBJNIGetStringCritical(collation);
    WCDBIndexedColumnConfigCollation(indexedColumnStruct, collationString);
    WCDBJNIReleaseStringCritical(collation);
}

void WCDBJNIIndexedColumnClassMethod(configOrder, jlong indexedColumn, jint order)
{
    WCDBJNIBridgeStruct(CPPIndexedColumn, indexedColumn);
    WCDBIndexedColumnConfigOrder(indexedColumnStruct, order);
}