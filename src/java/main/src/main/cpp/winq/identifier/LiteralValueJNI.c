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

#include "LiteralValueJNI.h"
#include "LiteralValueBridge.h"

jlong WCDBJNILiteralValueClassMethod(create, WCDBJNICommonValueParameter(value))
{
    WCDBJNICreateCommonValue(value, true);
    jlong ret = (jlong) WCDBLiteralValueCreate(value_common).innerValue;
    WCDBJNITryReleaseStringInCommonValue(value);
    return ret;
}

jlong WCDBJNILiteralValueClassMethod(createWithInt64, jlong value)
{
    return (jlong) WCDBLiteralValueCreateWithInt64(value).innerValue;
}

jlong WCDBJNILiteralValueClassMethod(createWithBool, jboolean value)
{
    return (jlong) WCDBLiteralValueCreateWithBool(value).innerValue;
}

jlong WCDBJNILiteralValueClassMethod(createWithDouble, jdouble value)
{
    return (jlong) WCDBLiteralValueCreateWithDouble(value).innerValue;
}

jlong WCDBJNILiteralValueClassMethod(createWithString, jstring value)
{
    WCDBJNIGetStringCritical(value);
    jlong result = (jlong) WCDBLiteralValueCreateWithString(valueString).innerValue;
    WCDBJNIReleaseStringCritical(value);
    return result;
}

jlong WCDBJNILiteralValueClassMethodWithNoArg(createWithCurrentTime)
{
    return (jlong) WCDBLiteralValueCreateWithCurrentTime().innerValue;
}

jlong WCDBJNILiteralValueClassMethodWithNoArg(createWithCurrentDate)
{
    return (jlong) WCDBLiteralValueCreateWithCurrentDate().innerValue;
}

jlong WCDBJNILiteralValueClassMethodWithNoArg(createWithCurrentTimestamp)
{
    return (jlong) WCDBLiteralValueCreateWithCurrentTimestamp().innerValue;
}