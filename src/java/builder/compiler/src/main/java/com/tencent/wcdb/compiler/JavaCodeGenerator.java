// Created by qiuwenchen on 2023/6/21.
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

package com.tencent.wcdb.compiler;

import com.tencent.wcdb.compiler.resolvedInfo.ColumnInfo;
import com.tencent.wcdb.compiler.resolvedInfo.FTSModuleInfo;
import com.tencent.wcdb.compiler.resolvedInfo.MultiIndexesInfo;
import com.tencent.wcdb.compiler.resolvedInfo.MultiPrimaryInfo;
import com.tencent.wcdb.compiler.resolvedInfo.MultiUniqueInfo;
import com.tencent.wcdb.compiler.resolvedInfo.TableConfigInfo;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class JavaCodeGenerator {
    public String packageName;
    public String className;
    public String ormClassName;
    public TableConfigInfo tableConstraintInfo;
    public List<ColumnInfo> allColumnInfo;

    private StringBuilder builder;
    private static final String TAB = "\t";

    public String generate() {
        builder = new StringBuilder();
        builder.append("package ").append(packageName).append(";\n\n");

        generateImport();

        builder.append("public class ").append(ormClassName).append(" implements TableBinding<").append(className).append("> {\n");
        builder.append(TAB + "private static final Binding baseBinding;\n");
        builder.append(TAB + "public static final ").append(ormClassName).append(" INSTANCE;\n\n");

        generateFields();

        builder.append("\n");
        builder.append(TAB + "static {\n\n");
        builder.append(TAB + TAB + "baseBinding = new Binding();\n");
        builder.append(TAB + TAB + "INSTANCE = new ").append(ormClassName).append("();\n\n");
        generateColumns();
        generateTableConfig();
        builder.append(TAB + "}\n\n");

        generateBindingType();
        generateBindingFields();
        generateBaseBinding();

        generateExtractObject();
        generateBindObject();

        generateAutoIncrementConfig();

        builder.append("}");
        return builder.toString();
    }

    private void generateImport() {
        builder.append("import com.tencent.wcdb.core.PreparedStatement;\n");
        builder.append("import com.tencent.wcdb.orm.*;\n");
        builder.append("import com.tencent.wcdb.winq.Column;\n");
        builder.append("import com.tencent.wcdb.winq.ColumnConstraint;\n");
        builder.append("import com.tencent.wcdb.winq.ColumnDef;\n");
        builder.append("import com.tencent.wcdb.winq.ColumnType;\n");
        builder.append("import com.tencent.wcdb.winq.StatementCreateIndex;\n");
        builder.append("import com.tencent.wcdb.winq.TableConstraint;\n\n");
    }

    private void generateFields() {
        for (ColumnInfo info : allColumnInfo) {
            builder.append(TAB + "public static final Field<").append(className).append("> ")
                    .append(info.getPropertyName()).append(";\n");
        }
    }

    private void generateColumns() {
        int fieldId = 1;
        for (ColumnInfo columnInfo : allColumnInfo) {
            JavaFieldORMInfo ormInfo = JavaFieldORMInfo.allInfo.get(columnInfo.getPropertyType());
            assert ormInfo != null;

            String propertyName = columnInfo.getPropertyName();
            String columnName = columnInfo.getColumnName();
            if (columnName.length() == 0) {
                columnName = propertyName;
            }

            builder.append(TAB + TAB).append(propertyName).append(" = new Field(\"")
                    .append(columnName).append("\", INSTANCE, ").append(fieldId).append(", ")
                    .append(columnInfo.isPrimary() && columnInfo.isAutoIncrement()).append(", ")
                    .append(columnInfo.isPrimary()).append(");\n");

            fieldId++;

            builder.append(TAB + TAB + "ColumnDef ").append(propertyName)
                    .append("Def = new ColumnDef(").append(propertyName)
                    .append(", ColumnType.").append(ormInfo.columnType).append(");\n");

            String constraintPrefix = TAB + TAB + propertyName + "Def.constraint(new ColumnConstraint()";

            if (columnInfo.isPrimary()) {
                builder.append(constraintPrefix).append(".primaryKey()").append(columnInfo.isAutoIncrement() ? ".autoIncrement());\n" : ");\n");
            }

            if (columnInfo.getDefaultValue() != null) {
                if (ormInfo.columnType.equals("Integer")) {
                    builder.append(constraintPrefix).append(".defaultTo(").append(columnInfo.getDefaultValue().getIntValue()).append("));\n");
                } else if (ormInfo.columnType.equals("Float")) {
                    builder.append(constraintPrefix).append(".defaultTo(").append(columnInfo.getDefaultValue().getDoubleValue()).append("));\n");
                } else {
                    builder.append(constraintPrefix).append(".defaultTo(\"").append(columnInfo.getDefaultValue().getTextValue()).append("\"));\n");
                }
            }

            if (columnInfo.isUnique()) {
                builder.append(constraintPrefix).append(".unique()").append(");\n");
            }

            if (columnInfo.isNotNull()) {
                builder.append(constraintPrefix).append(".notNull()").append(");\n");
            }

            if (columnInfo.isNotIndexed()) {
                builder.append(constraintPrefix).append(".unIndex()").append(");\n");
            }

            builder.append(TAB + TAB + "baseBinding.addColumnDef(").append(propertyName).append("Def);\n");

            if (columnInfo.getEnableAutoIncrementForExistingTable()) {
                builder.append(TAB + TAB + "baseBinding.enableAutoIncrementForExistingTable();\n");
            }

            if (!columnInfo.getHasIndex()) {
                continue;
            }
            String indexName = columnInfo.getIndexName();
            boolean isFullName = true;
            if (indexName.length() == 0) {
                isFullName = false;
                indexName = "_" + columnName + "_index";
            }

            builder.append(TAB + TAB + "baseBinding.addIndex(\"")
                    .append(indexName).append("\", ").append(isFullName)
                    .append(", new StatementCreateIndex().ifNotExist()");

            if (columnInfo.getIndexIsUnique()) {
                builder.append(".unique()");
            }
            builder.append(".indexedBy(").append(propertyName).append("));\n\n");
        }
    }

    private void generateTableConfig() {

        Map<String, ColumnInfo> allColumns = new HashMap<>();
        for (ColumnInfo columnInfo : allColumnInfo) {
            allColumns.put(columnInfo.getColumnName().isEmpty() ? columnInfo.getPropertyName() : columnInfo.getColumnName(), columnInfo);
        }

        for (MultiIndexesInfo indexes : tableConstraintInfo.getMultiIndexes()) {
            String indexName = indexes.getName();
            boolean isFullName = true;
            if (indexName.length() == 0) {
                isFullName = false;
                indexName = "_" + String.join("_", indexes.getColumns()) + "_index";
            }
            builder.append(TAB + TAB + "baseBinding.addIndex(\"").append(indexName).append("\", ").append(isFullName)
                    .append(", new StatementCreateIndex().ifNotExist().indexedBy(new Column[]{\n" + TAB + TAB + TAB);
            for (String column : indexes.getColumns()) {
                builder.append(allColumns.get(column).getPropertyName()).append(", ");
            }
            builder.append("\n" + TAB + TAB + "}));\n");
        }

        for (MultiPrimaryInfo primaries : tableConstraintInfo.getMultiPrimaries()) {
            builder.append(TAB + TAB + "baseBinding.addTableConstraint(new TableConstraint().primaryKey().indexedBy(new Column[]{\n" + TAB + TAB + TAB);
            for (String column : primaries.getColumns()) {
                builder.append(allColumns.get(column).getPropertyName()).append(", ");
            }
            builder.append("\n" + TAB + TAB + "}));\n");
        }

        for (MultiUniqueInfo uniques : tableConstraintInfo.getMultiUnique()) {
            builder.append(TAB + TAB + "baseBinding.addTableConstraint(new TableConstraint().unique().indexedBy(new Column[]{\n" + TAB + TAB + TAB);
            for (String column : uniques.getColumns()) {
                builder.append(allColumns.get(column).getPropertyName()).append(", ");
            }
            builder.append("\n" + TAB + TAB + "}));\n");
        }

        if (tableConstraintInfo.isWithoutRowId()) {
            builder.append(TAB + TAB + "baseBinding.configWithoutRowId();\n");
        }

        FTSModuleInfo ftsModuleInfo = tableConstraintInfo.getFtsModule();
        if (ftsModuleInfo == null || ftsModuleInfo.getFtsVersion().isEmpty()) {
            return;
        }

        builder.append(TAB + TAB + "baseBinding.configVirtualModule(\"").append(ftsModuleInfo.getFtsVersion()).append("\");\n");

        StringBuilder tokenizer = new StringBuilder("tokenize = ");
        tokenizer.append(ftsModuleInfo.getTokenizer());
        for (String para : ftsModuleInfo.getTokenizerParameters()) {
            tokenizer.append(" ").append(para);
        }
        builder.append(TAB + TAB + "baseBinding.configVirtualModuleArgument(\"").append(tokenizer).append("\");\n");
        if (!ftsModuleInfo.getExternalTable().isEmpty()) {
            builder.append(TAB + TAB + "baseBinding.configVirtualModuleArgument(\"content='").append(ftsModuleInfo.getExternalTable()).append("'\");\n");
        }
    }

    private void generateBindingType() {
        builder.append(TAB + "@Override\n");
        builder.append(TAB + "public Class<").append(className).append("> bindingType() {\n");
        builder.append(TAB + TAB + "return ").append(className).append(".class;\n");
        builder.append(TAB + "}\n\n");
    }

    private void generateBindingFields() {
        builder.append(TAB + "@Override\n");
        builder.append(TAB + "public Field<").append(className).append(">[] allBindingFields() {\n");
        builder.append(TAB + TAB + "return new Field[]{");
        for (ColumnInfo columnInfo : allColumnInfo) {
            builder.append(columnInfo.getPropertyName()).append(", ");
        }
        builder.append("};\n" + TAB + "}\n\n");

        builder.append(TAB + "public static Field<").append(className).append(">[] allFields() {\n");
        builder.append(TAB + TAB + "return new Field[]{");
        for (ColumnInfo columnInfo : allColumnInfo) {
            builder.append(columnInfo.getPropertyName()).append(", ");
        }
        builder.append("};\n" + TAB + "}\n\n");
    }

    private void generateBaseBinding() {
        builder.append(TAB + "@Override\n");
        builder.append(TAB + "public Binding baseBinding() {\n");
        builder.append(TAB + TAB + "return baseBinding;\n");
        builder.append(TAB + "}\n\n");
    }

    private void generateExtractObject() {
        builder.append(TAB + "@Override\n");
        builder.append(TAB + "public <R extends ").append(className).append("> R extractObject(Field<")
                .append(className).append(">[] fields, PreparedStatement preparedStatement, Class<R> cls) throws ReflectiveOperationException {\n");
        builder.append(TAB + TAB + "R newOne = cls.newInstance();\n");
        builder.append(TAB + TAB + "int index = 0;\n");
        builder.append(TAB + TAB + "for(Field<").append(className).append("> field : fields) {\n");
        builder.append(TAB + TAB + TAB + "switch (field.getFieldId()) {\n");
        int index = 1;
        for (ColumnInfo columnInfo : allColumnInfo) {
            JavaFieldORMInfo info = JavaFieldORMInfo.allInfo.get(columnInfo.getPropertyType());
            assert info != null;

            builder.append(TAB + TAB + TAB + TAB + "case ").append(index).append(":\n");
            if (info.nullable) {
                builder.append(TAB + TAB + TAB + TAB + TAB + "if (preparedStatement.getColumnType(index) != ColumnType.Null) {\n");
                builder.append(TAB + TAB + TAB + TAB + TAB + TAB + "newOne.").append(columnInfo.getPropertyName())
                        .append(" = ").append(info.fieldSetter).append("(index);\n");
                builder.append(TAB + TAB + TAB + TAB + TAB + "}\n");
            } else {
                builder.append(TAB + TAB + TAB + TAB + TAB + "newOne.").append(columnInfo.getPropertyName())
                        .append(" = ").append(info.fieldSetter).append("(index);\n");
            }
            builder.append(TAB + TAB + TAB + TAB + TAB + "break;\n");

            index++;
        }

        builder.append(TAB + TAB + TAB + TAB + "default:\n");
        builder.append(TAB + TAB + TAB + TAB + TAB + "assert false : \"Invalid id \" + field.getFieldId() + \" of field \" + field.getDescription() + \" in ")
                .append(className).append(".\";\n");
        builder.append(TAB + TAB + TAB + "}\n");
        builder.append(TAB + TAB + TAB + "index++;\n");
        builder.append(TAB + TAB + "}\n");
        builder.append(TAB + TAB + "return newOne;\n");
        builder.append(TAB + "}\n\n");
    }

    private void generateBindObject() {
        builder.append(TAB + "@Override\n");
        builder.append(TAB + "public void bindField(").append(className).append(" object, Field<")
                .append(className).append("> field, int index, PreparedStatement preparedStatement) {\n");
        builder.append(TAB + TAB + "switch (field.getFieldId()) {\n");
        int index = 1;
        for (ColumnInfo columnInfo : allColumnInfo) {
            String type = columnInfo.getPropertyType();
            JavaFieldORMInfo info = JavaFieldORMInfo.allInfo.get(type);
            String field = columnInfo.getPropertyName();
            assert info != null;

            builder.append(TAB + TAB + TAB + "case ").append(index).append(":\n");
            if (info.nullable) {
                builder.append(TAB + TAB + TAB + TAB + "if ( object.").append(field)
                        .append(" != null ) {\n");
                builder.append(TAB + TAB + TAB + TAB + TAB + "preparedStatement.").append(info.fieldGetter)
                        .append("(object.").append(field).append(", index);\n");
                builder.append(TAB + TAB + TAB + TAB + "} else {\n");
                builder.append(TAB + TAB + TAB + TAB + TAB + "preparedStatement.bindNull(index);\n");
                builder.append(TAB + TAB + TAB + TAB + "}\n");
            } else {
                builder.append(TAB + TAB + TAB + TAB + "preparedStatement.").append(info.fieldGetter)
                        .append("(object.").append(field).append(", index);\n");
            }

            builder.append(TAB + TAB + TAB + TAB + "break;\n");

            index++;
        }

        builder.append(TAB + TAB + TAB + "default:\n");
        builder.append(TAB + TAB + TAB + TAB + "assert false : \"Invalid id \" + field.getFieldId() + \" of field \" + field.getDescription() + \" in ")
                .append(className).append(".\";\n");
        builder.append(TAB + TAB + "}\n");
        builder.append(TAB + "}\n\n");
    }

    private void generateAutoIncrementConfig() {
        builder.append(TAB + "@Override\n");
        builder.append(TAB + "public boolean isAutoIncrement(").append(className).append(" object) {\n");
        ColumnInfo autoIncrementColumn = null;
        for (ColumnInfo info : allColumnInfo) {
            if (info.isAutoIncrement() && info.isPrimary()) {
                autoIncrementColumn = info;
                break;
            }
        }
        if (autoIncrementColumn != null) {
            builder.append(TAB + TAB + "return object.").append(autoIncrementColumn.getPropertyName()).append(" == 0;\n");
        } else {
            builder.append(TAB + TAB + "return false;\n");
        }
        builder.append(TAB + "}\n\n");

        builder.append(TAB + "@Override\n");
        builder.append(TAB + "public void setLastInsertRowId(").append(className).append(" object, long lastInsertRowId) {\n");
        if (autoIncrementColumn != null) {
            builder.append(TAB + TAB + "object.").append(autoIncrementColumn.getPropertyName())
                    .append(" = (").append(autoIncrementColumn.getPropertyType()).append(") lastInsertRowId;\n");
        }
        builder.append(TAB + "}\n\n");
    }
}
