// Created by qiuwenchen on 2023/5/8.
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
package com.tencent.wcdbtest.base;

import com.tencent.wcdb.base.WCDBException;
import com.tencent.wcdb.core.Table;
import com.tencent.wcdb.orm.TableBinding;
import com.tencent.wcdb.winq.Column;
import com.tencent.wcdb.winq.ColumnDef;
import com.tencent.wcdb.winq.ColumnType;
import com.tencent.wcdb.winq.StatementCreateTable;

import org.junit.Assert;

import java.util.Collections;
import java.util.List;
import java.util.Arrays;
import java.util.ArrayList;

public class TableTestCase extends DatabaseTestCase {
    public String tableName = "testTable";
    public TableBinding<TestObject> tableBinding = DBTestObject.INSTANCE;
    public boolean isVirtualTable = false;
    public Table<TestObject> table;

    public void createTable() throws WCDBException {
        if (!isVirtualTable) {
            database.createTable(tableName, tableBinding);
        } else {
            database.createVirtualTable(tableName, tableBinding);
        }
        table = database.getTable(tableName, tableBinding);
    }

    public void createValueTable() throws WCDBException {
        StatementCreateTable createTable = new StatementCreateTable().createTable(tableName);
        createTable.define(new ColumnDef("id", ColumnType.Integer).makePrimary(true));
        createTable.define(new ColumnDef("content", ColumnType.Text));
        database.execute(createTable);
    }

    public Column[] columns() {
        return new Column[]{new Column("id"), new Column("content")};
    }

    public void createVirtualTable() throws WCDBException {
        database.createVirtualTable(tableName, tableBinding);
        table = database.getTable(tableName, tableBinding);
    }

    public void dropTable() throws WCDBException {
        database.dropTable(tableName);
    }

    public void doTestObjectsAfterInsert(List objects, int insertCount, String[] sqls, TestOperation operation) {
        if (insertCount > 1) {
            List<String> list = new ArrayList<String>(Arrays.asList(sqls));
            list.add(0, "BEGIN IMMEDIATE");
            list.add("COMMIT");
            sqls = list.toArray(new String[0]);
        }
        doTestObjectsAfterOperation(objects, sqls, operation);
    }

    public void doTestObjectsAfterOperation(List objects, String sql, TestOperation operation) {
        doTestObjectsAfterOperation(objects, new String[]{sql}, operation);
    }

    public void doTestObjectsAfterOperation(List objects, String[] sqls, TestOperation operation) {
        doTestSQLs(sqls, operation);
        List<TestObject> allObjects;
        try {
            allObjects = getAllObjects();
        } catch (WCDBException e) {
            throw new RuntimeException(e);
        }
        Assert.assertTrue(((objects == null || objects.size() == 0) &&
                (allObjects == null || allObjects.size() == 0)) || objects.equals(allObjects));
    }

    public interface SelectingObjectOperation {
        List<TestObject> execute() throws WCDBException;
    }

    public void doTestObjectBySelecting(TestObject object, String sql, SelectingObjectOperation operation) {
        doTestObjectBySelecting(Collections.singletonList(object), new String[]{sql}, operation);
    }

    public void doTestObjectBySelecting(List<TestObject> objects, String sql, SelectingObjectOperation operation) {
        doTestObjectBySelecting(objects, new String[]{sql}, operation);
    }

    public void doTestObjectBySelecting(List<TestObject> objects, String[] sqls, final SelectingObjectOperation operation) {
        final List<TestObject> selecting = new ArrayList<TestObject>();
        doTestSQLs(sqls, new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                selecting.addAll(operation.execute());
            }
        });
        Assert.assertTrue(((objects == null || objects.size() == 0) &&
                selecting.size() == 0) || objects.equals(selecting));
    }

    public List<TestObject> getAllObjects() throws WCDBException {
        return table.getAllObjects();
    }
}
