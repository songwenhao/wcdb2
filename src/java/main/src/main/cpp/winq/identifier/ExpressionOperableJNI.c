// Created by chenqiuwen on 2023/4/1.
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

#include "ExpressionOperableJNI.h"
#include "ExpressionOperatableBridge.h"
#include <alloca.h>

jlong WCDBJNIExpressionOperableClassMethod(nullOperate, jint operandType, jlong operand, jboolean isNot)
{
    CPPCommonValue operand_common;
    operand_common.type = operandType;
    operand_common.intValue = operand;
    return (jlong) WCDBExpressionNullOperate2(operand_common, isNot).innerValue;
}

jlong WCDBJNIExpressionOperableClassMethod(binaryOperate,
                                           jint leftType,
                                           jlong left,
                                           WCDBJNICommonValueParameter(right),
                                           jint operatorType,
                                           jboolean isNot)
{
    CPPCommonValue left_common;
    left_common.type = leftType;
    left_common.intValue = left;
    WCDBJNICreateCommonValue(right, true);
    jlong ret = (jlong) WCDBExpressionBinaryOperate2(
                left_common, right_common, operatorType, isNot)
                .innerValue;
    WCDBJNITryReleaseStringInCommonValue(right);
    return ret;
}

jlong WCDBJNIExpressionOperableClassMethod(betweenOperate,
                                           jint operandType,
                                           jlong operand,
                                           WCDBJNICommonValueParameter(left),
                                           WCDBJNICommonValueParameter(right),
                                           jboolean isNot)
{
    CPPCommonValue operand_common;
    operand_common.type = operandType;
    operand_common.intValue = operand;
    WCDBJNICreateCommonValue(left, false);
    WCDBJNICreateCommonValue(right, false);
    jlong ret = (jlong) WCDBExpressionBetweenOperate2(
                operand_common, left_common, right_common, isNot)
                .innerValue;
    WCDBJNITryReleaseStringInCommonValue(left);
    WCDBJNITryReleaseStringInCommonValue(right);
    return ret;
}

jlong WCDBJNIExpressionOperableClassMethod(inOperate,
                                           jint operandType,
                                           jlong operand,
                                           WCDBJNICommonArrayParameter(values),
                                           jboolean isNot)
{
    CPPCommonValue operand_common;
    operand_common.type = operandType;
    operand_common.intValue = operand;
    jlong ret = 0;
    WCDBJNICreateCommonArrayWithAction(
    values,
    ret
    = (jlong) WCDBExpressionInOperate(operand_common, values_commonArray, isNot).innerValue);
    return ret;
}

jlong WCDBJNIExpressionOperableClassMethod(
inTableOperate, jint operandType, jlong operand, jstring table, jboolean isNot)
{
    CPPCommonValue operand_common;
    operand_common.type = operandType;
    operand_common.intValue = operand;
    WCDBJNIGetStringCritical(table);
    jlong ret
    = (jlong) WCDBExpressionInTableOperate2(operand_common, tableString, isNot).innerValue;
    WCDBJNIReleaseStringCritical(table);
    return ret;
}

jlong WCDBJNIExpressionOperableClassMethod(
inFunctionOperate, jint operandType, jlong operand, jstring func, jboolean isNot)
{
    CPPCommonValue operand_common;
    operand_common.type = operandType;
    operand_common.intValue = operand;
    WCDBJNIGetStringCritical(func);
    jlong ret = (jlong) WCDBExpressionInFunctionOperate2(operand_common, funcString, isNot)
                .innerValue;
    WCDBJNIReleaseStringCritical(func);
    return ret;
}

jlong WCDBJNIExpressionOperableClassMethod(
inSelectionOperate, jint operandType, jlong operand, jlong select, jboolean isNot)
{
    CPPCommonValue operand_common;
    operand_common.type = operandType;
    operand_common.intValue = operand;
    WCDBJNIBridgeStruct(CPPStatementSelect, select);
    return (jlong) WCDBExpressionInSelectionOperate2(operand_common, selectStruct, isNot)
    .innerValue;
}

jlong WCDBJNIExpressionOperableClassMethod(collateOperate, jint operandType, jlong operand, jstring collation)
{
    CPPCommonValue operand_common;
    operand_common.type = operandType;
    operand_common.intValue = operand;
    WCDBJNIGetStringCritical(collation);
    jlong ret
    = (jlong) WCDBExpressionCollateOperate2(operand_common, collationString).innerValue;
    WCDBJNIReleaseStringCritical(collation);
    return ret;
}