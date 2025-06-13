// Created by qiuwenchen on 2024/4/27.
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

package com.tencent.wcdbtest

import com.tencent.wcdb.WCDBField
import com.tencent.wcdb.WCDBTableCoding

@WCDBTableCoding
class TestObject {
    @WCDBField(isPrimary = true, isAutoIncrement = true)
    var id = 0

    @WCDBField
    var content: String? = null

    override fun equals(other: Any?): Boolean {
        return if (other is TestObject) {
            if (other.id != id) {
                return false
            }
            if (content == null) {
                return other.content == null || other.content!!.isEmpty()
            } else if (other.content == null) {
                return content!!.isEmpty()
            }
            other.content == content
        } else {
            super.equals(other)
        }
    }

    companion object {
        fun createObject(id: Int, content: String?): TestObject {
            val obj = TestObject()
            obj.id = id
            obj.content = content
            return obj
        }

        fun createPartialObject(id: Int): TestObject {
            val obj = TestObject()
            obj.id = id
            return obj
        }

        fun createAutoIncrementObject(content: String?): TestObject {
            val obj = TestObject()
            obj.id = 0
            obj.content = content
            return obj
        }
    }
}