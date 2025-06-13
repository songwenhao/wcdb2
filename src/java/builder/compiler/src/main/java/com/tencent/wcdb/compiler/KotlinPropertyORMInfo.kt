// Created by qiuwenchen on 2023/6/20.
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

package com.tencent.wcdb.compiler

internal val AllKotlinPropertyORMInfo = mapOf<String, KotlinPropertyORMInfo>(
    Boolean::class.qualifiedName!! to KotlinPropertyORMInfo(
        "Integer",
        "bindBool",
        "getBool(index)"
    ),
    Byte::class.qualifiedName!! to KotlinPropertyORMInfo(
        "Integer",
        "bindInteger",
        "getByte(index)"
    ),
    Short::class.qualifiedName!! to KotlinPropertyORMInfo(
        "Integer",
        "bindInteger",
        "getShort(index)"
    ),
    Int::class.qualifiedName!! to KotlinPropertyORMInfo("Integer", "bindInteger", "getInt(index)"),
    Long::class.qualifiedName!! to KotlinPropertyORMInfo(
        "Integer",
        "bindInteger",
        "getLong(index)"
    ),
    Float::class.qualifiedName!! to KotlinPropertyORMInfo("Float", "bindDouble", "getFloat(index)"),
    Double::class.qualifiedName!! to KotlinPropertyORMInfo(
        "Float",
        "bindDouble",
        "getDouble(index)"
    ),
    String::class.qualifiedName!! to KotlinPropertyORMInfo("Text", "bindText", "getText(index)"),
    ByteArray::class.qualifiedName!! to KotlinPropertyORMInfo("BLOB", "bindBLOB", "getBLOB(index)"),
)

internal val AllKotlinPropertyTypes = AllKotlinPropertyORMInfo.keys

internal val K2JTypeMap = mapOf<String, String>(
    Boolean::class.qualifiedName!! to "boolean",
    Byte::class.qualifiedName!! to "byte",
    Short::class.qualifiedName!! to "short",
    Int::class.qualifiedName!! to "int",
    Long::class.qualifiedName!! to "long",
    Float::class.qualifiedName!! to "float",
    Double::class.qualifiedName!! to "double",
    String::class.qualifiedName!! to "java.lang.String",
    ByteArray::class.qualifiedName!! to "byte[]",
)

internal data class KotlinPropertyORMInfo(
    val columnType: String,
    val getter: String,
    val setter: String
) {
}