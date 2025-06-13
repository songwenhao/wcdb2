// Created by qiuwenchen on 2023/4/21.
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

#include "ErrorJNI.h"
#include "ErrorBridge.h"
#include "assert.h"

jlong WCDBJNIErrorClassMethod(getLevel, jlong error)
{
    WCDBJNIBridgeStruct(CPPError, error);
    return WCDBErrorGetLevel(errorStruct);
}

jlong WCDBJNIErrorClassMethod(getCode, jlong error)
{
    WCDBJNIBridgeStruct(CPPError, error);
    return WCDBErrorGetCode(errorStruct);
}

jstring WCDBJNIErrorClassMethod(getMessage, jlong error)
{
    WCDBJNIBridgeStruct(CPPError, error);
    WCDBJNICreateJStringAndReturn(WCDBErrorGetMsg(errorStruct));
}

typedef struct JNIContext {
    JNIEnv *env;
    jobject object;
} JNIContext;

void WCDBJNIErrorEnumerateInfoCallback(JNIContext *context, const char *key, CPPCommonValue value)
{
    JNIEnv *env = context->env;
    static jmethodID g_methodId = NULL;
    jlong intValue = 0;
    double doubleValue = 0;
    const char *stringValue = NULL;
    switch (value.type) {
    case WCDBBridgedType_Int:
        intValue = (jlong) value.intValue;
        break;
    case WCDBBridgedType_Double:
        doubleValue = value.doubleValue;
        break;
    case WCDBBridgedType_String:
        stringValue = (const char *) value.intValue;
        break;
    default:
        break;
    }

    if (g_methodId == NULL) {
        g_methodId = (*env)->GetMethodID(
        env, WCDBJNIGetExceptionClass(), "addInfo", "(Ljava/lang/String;IJDLjava/lang/String;)V");
        if (g_methodId == NULL) {
            assert(0);
            return;
        }
    }
    WCDBJNICreateJavaString(key);
    WCDBJNICreateJavaString(stringValue);
    (*env)->CallVoidMethod(
    env, context->object, g_methodId, jkey, (int) value.type, intValue, doubleValue, jstringValue);
}

void WCDBJNIErrorObjectMethod(enumerateInfo, jlong error)
{
    WCDBJNIBridgeStruct(CPPError, error);
    JNIContext context;
    context.env = env;
    context.object = obj;
    WCDBErrorEnumerateAllInfo(
    errorStruct, (void *) &context, (StringViewMapEnumerator) &WCDBJNIErrorEnumerateInfoCallback);
}
