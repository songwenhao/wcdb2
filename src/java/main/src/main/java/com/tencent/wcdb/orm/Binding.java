// Created by chenqiuwen on 2023/4/19.
//

/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the &quot;License&quot;); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.tencent.wcdb.orm;

import com.tencent.wcdb.base.CppObject;
import com.tencent.wcdb.base.WCDBException;
import com.tencent.wcdb.core.Handle;
import com.tencent.wcdb.winq.ColumnDef;
import com.tencent.wcdb.winq.StatementCreateIndex;
import com.tencent.wcdb.winq.TableConstraint;

public class Binding extends CppObject {
    private long baseBinding = 0;

    public Binding() {
        cppObj = createCppObj();
    }

    private static native long createCppObj();

    public void addColumnDef(ColumnDef def) {
        addColumnDef(cppObj, CppObject.get(def));
    }

    private static native void addColumnDef(long self, long columnDef);

    public void enableAutoIncrementForExistingTable() {
        enableAutoIncrementForExistingTable(cppObj);
    }

    private static native void enableAutoIncrementForExistingTable(long self);

    public void addIndex(String indexNameOrSuffix, boolean isFullName, StatementCreateIndex createIndex) {
        addIndex(cppObj, indexNameOrSuffix, isFullName, CppObject.get(createIndex));
    }

    private static native void addIndex(long self, String indexNameOrSuffix, boolean isFullName, long createIndex);

    public void addTableConstraint(TableConstraint constraint) {
        addTableConstraint(cppObj, CppObject.get(constraint));
    }

    private static native void addTableConstraint(long self, long tableConstraint);

    public Binding configVirtualModule(String module) {
        configVirtualModule(cppObj, module);
        return this;
    }

    private static native void configVirtualModule(long self, String module);

    public void configVirtualModuleArgument(String argument) {
        configVirtualModuleArgument(cppObj, argument);
    }

    private static native void configVirtualModuleArgument(long self, String argument);

    public void configWithoutRowId() {
        configWithoutRowId(cppObj);
    }

    private static native void configWithoutRowId(long self);

    public boolean createTable(String tableName, Handle handle) throws WCDBException {
        return createTable(cppObj, tableName, handle.getCppHandle());
    }

    private static native boolean createTable(long self, String tableName, long handle);

    public boolean createVirtualTable(String tableName, Handle handle) throws WCDBException {
        return createVirtualTable(cppObj, tableName, handle.getCppHandle());
    }

    private static native boolean createVirtualTable(long self, String tableName, long handle);

    long getBaseBinding() {
        if (baseBinding == 0) {
            baseBinding = getBaseBinding(cppObj);
        }
        return baseBinding;
    }

    private static native long getBaseBinding(long self);
}
