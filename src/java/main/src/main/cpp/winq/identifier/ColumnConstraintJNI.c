// Created by chenqiuwen on 2023/4/3.
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

#include "ColumnConstraintJNI.h"
#include "ColumnConstraintBridge.h"

jlong WCDBJNIColumnConstraintClassMethod(create, jstring name)
{
    WCDBJNIGetStringCritical(name);
    jlong ret = (jlong) WCDBColumnConstraintCreate(nameString).innerValue;
    WCDBJNIReleaseStringCritical(name);
    return ret;
}

void WCDBJNIColumnConstraintClassMethod(configPrimaryKey, jlong constraint)
{
    WCDBJNIBridgeStruct(CPPColumnConstraint, constraint);
    WCDBColumnConstraintConfigPrimaryKey(constraintStruct);
}

void WCDBJNIColumnConstraintClassMethod(configOrder, jlong constraint, jint order)
{
    WCDBJNIBridgeStruct(CPPColumnConstraint, constraint);
    WCDBColumnConstraintConfigOrder(constraintStruct, order);
}

void WCDBJNIColumnConstraintClassMethod(configConflictAction, jlong constraint, jint conflictAction)
{
    WCDBJNIBridgeStruct(CPPColumnConstraint, constraint);
    WCDBColumnConstraintConfigCoflictAction(constraintStruct, conflictAction);
}

void WCDBJNIColumnConstraintClassMethod(configAutoIncrement, jlong constraint)
{
    WCDBJNIBridgeStruct(CPPColumnConstraint, constraint);
    WCDBColumnConstraintConfigAutoIncrement(constraintStruct);
}

void WCDBJNIColumnConstraintClassMethod(configNotNull, jlong constraint)
{
    WCDBJNIBridgeStruct(CPPColumnConstraint, constraint);
    WCDBColumnConstraintConfigNotNull(constraintStruct);
}

void WCDBJNIColumnConstraintClassMethod(configUnique, jlong constraint)
{
    WCDBJNIBridgeStruct(CPPColumnConstraint, constraint);
    WCDBColumnConstraintConfigUnique(constraintStruct);
}

void WCDBJNIColumnConstraintClassMethod(configCheck, jlong constraint, jlong expression)
{
    WCDBJNIBridgeStruct(CPPColumnConstraint, constraint);
    WCDBJNIBridgeStruct(CPPExpression, expression);
    WCDBColumnConstraintConfigCheck(constraintStruct, expressionStruct);
}

void WCDBJNIColumnConstraintClassMethod(configDefaultValue,
                                        jlong constraint,
                                        WCDBJNICommonValueParameter(value))
{
    WCDBJNIBridgeStruct(CPPColumnConstraint, constraint);
    WCDBJNICreateCommonValue(value, true);
    WCDBColumnConstraintConfigDefaultValue2(constraintStruct, value_common);
    WCDBJNITryReleaseStringInCommonValue(value);
}

void WCDBJNIColumnConstraintClassMethod(configCollation, jlong constraint, jstring collation)
{
    WCDBJNIBridgeStruct(CPPColumnConstraint, constraint);
    WCDBJNIGetStringCritical(collation);
    WCDBColumnConstraintConfigCollation(constraintStruct, collationString);
    WCDBJNIReleaseStringCritical(collation);
}

void WCDBJNIColumnConstraintClassMethod(configForeignKey, jlong constraint, jlong foreignKey)
{
    WCDBJNIBridgeStruct(CPPColumnConstraint, constraint);
    WCDBJNIBridgeStruct(CPPForeignKey, foreignKey);
    WCDBColumnConstraintConfigForeignKey(constraintStruct, foreignKeyStruct);
}

void WCDBJNIColumnConstraintClassMethod(configUnindexed, jlong constraint)
{
    WCDBJNIBridgeStruct(CPPColumnConstraint, constraint);
    WCDBColumnConstraintConfigUnIndexed(constraintStruct);
}
