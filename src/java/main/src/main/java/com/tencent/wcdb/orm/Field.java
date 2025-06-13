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
package com.tencent.wcdb.orm;

import com.tencent.wcdb.winq.Column;
import com.tencent.wcdb.winq.Schema;

import org.jetbrains.annotations.NotNull;

public class Field<T> extends Column {
    protected TableBinding<T> binding = null;

    public TableBinding<T> getTableBinding() {
        return binding;
    }

    private int fieldId = 0;

    public int getFieldId() {
        return fieldId;
    }

    private String name;

    public String getName() {
        return name;
    }

    private boolean isAutoIncrement = false;

    public boolean isAutoIncrement() {
        return isAutoIncrement;
    }

    private boolean isPrimaryKey = false;

    public boolean isPrimaryKey() {
        return isPrimaryKey;
    }

    public Field(String name, TableBinding<T> binding, int fieldId, boolean isAutoIncrement, boolean isPrimaryKey) {
        super(name, binding.baseBinding().getBaseBinding());
        this.name = name;
        this.binding = binding;
        this.fieldId = fieldId;
        this.isAutoIncrement = isAutoIncrement;
        this.isPrimaryKey = isPrimaryKey;
    }

    protected Field() {
        super();
    }

    protected Field<T> copySelf() {
        Field<T> field = new Field<T>();
        field.cppObj = copy(cppObj);
        field.name = name;
        field.fieldId = fieldId;
        field.isAutoIncrement = isAutoIncrement;
        field.isPrimaryKey = isPrimaryKey;
        field.binding = binding;
        return field;
    }

    @NotNull
    public Field<T> table(String tableName) {
        Field<T> field = copySelf();
        field.inTable(field.cppObj, tableName);
        return field;
    }

    @Override
    @NotNull
    public Field<T> of(String schema) {
        Field<T> field = copySelf();
        field.ofSchema(schema);
        return field;
    }

    @Override
    @NotNull
    public Field<T> of(Schema schema) {
        Field<T> field = copySelf();
        field.ofSchema(schema);
        return field;
    }

    @NotNull
    public static <T> TableBinding<T> getBinding(@NotNull Field<T> field) {
        assert field.getTableBinding() != null;
        return field.getTableBinding();
    }

    @SafeVarargs
    @NotNull
    public static <T> TableBinding<T> getBinding(@NotNull Field<T>... fields) {
        assert fields.length > 0;
        Field<T> field = fields[0];
        return getBinding(field);
    }

    @SafeVarargs
    @NotNull
    public static <T> Class<T> getBindClass(@NotNull Field<T>... fields) {
        assert fields.length > 0;
        return fields[0].binding.bindingType();
    }
}
