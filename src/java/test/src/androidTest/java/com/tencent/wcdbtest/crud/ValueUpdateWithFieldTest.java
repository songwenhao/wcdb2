// Created by chenqiuwen on 2023/5/14.
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

package com.tencent.wcdbtest.crud;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import com.tencent.wcdb.base.Value;
import com.tencent.wcdb.base.WCDBException;
import com.tencent.wcdb.winq.Order;
import com.tencent.wcdbtest.base.DBTestObject;
import com.tencent.wcdbtest.base.ObjectCRUDTestCase;

import org.junit.Test;

public class ValueUpdateWithFieldTest extends ObjectCRUDTestCase {


    @Test
    public void testDatabaseUpdateValue() throws WCDBException {
        doTestSQL("UPDATE testTable SET content = ?1", new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                database.updateValue("newContent", DBTestObject.content, tableName);
            }
        });
        assertEquals(database.getValue(DBTestObject.content, tableName).getText(), "newContent");
    }

    @Test
    public void testDatabaseUpdateValueWhere() throws WCDBException {
        doTestSQLs(new String[]{
                "UPDATE testTable SET content = ?1 WHERE id == 1",
                "UPDATE testTable SET id = ?1 WHERE content == 'newContent'"
        }, new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                database.updateValue("newContent", DBTestObject.content, tableName, DBTestObject.id.eq(1));
                database.updateValue(nextId, DBTestObject.id, tableName, DBTestObject.content.eq("newContent"));
            }
        });
        assertEquals(database.getValue(DBTestObject.content, tableName, DBTestObject.id.eq(nextId)).getText(), "newContent");
        assertEquals(database.getValue(DBTestObject.id, tableName, DBTestObject.content.eq("newContent")).getLong(), nextId);
    }

    @Test
    public void testDatabaseUpdateValueWhereOrderLimit() throws WCDBException {
        doTestSQLs(new String[]{
                "UPDATE testTable SET content = ?1 WHERE id > 0 ORDER BY id ASC LIMIT 1",
                "UPDATE testTable SET id = ?1 ORDER BY content ASC LIMIT 1"
        }, new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                database.updateValue("newContent", DBTestObject.content, tableName, DBTestObject.id.gt(0), DBTestObject.id.order(Order.Asc), 1);
                database.updateValue(nextId, DBTestObject.id, tableName, DBTestObject.content.order(Order.Asc), 1);
            }
        });
        assertEquals(database.getValue(DBTestObject.content.count(), tableName, DBTestObject.id.eq(nextId)).getLong(), 1);
        assertEquals(database.getValue(DBTestObject.id.count(), tableName, DBTestObject.content.eq("newContent")).getLong(), 1);
    }

    @Test
    public void testDatabaseUpdateValueWhereOrderLimitOffset() throws WCDBException {
        doTestSQLs(new String[]{
                "UPDATE testTable SET content = ?1 WHERE id > 0 ORDER BY id ASC LIMIT 1 OFFSET 1",
                "UPDATE testTable SET id = ?1 ORDER BY content ASC LIMIT 1 OFFSET 1"
        }, new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                database.updateValue("newContent", DBTestObject.content, tableName, DBTestObject.id.gt(0), DBTestObject.id.order(Order.Asc), 1, 1);
                database.updateValue(nextId, DBTestObject.id, tableName, DBTestObject.content.order(Order.Asc), 1, 1);
            }
        });
        assertEquals(database.getValue(DBTestObject.content.count(), tableName, DBTestObject.id.eq(nextId)).getLong(), 1);
        assertEquals(database.getValue(DBTestObject.id.count(), tableName, DBTestObject.content.eq("newContent")).getLong(), 1);
    }

    @Test
    public void testDatabaseUpdateRowWhere() throws WCDBException {
        doTestSQL("UPDATE testTable SET id = ?1, content = ?2 WHERE id != 1", new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                database.updateRow(new Value[]{new Value(nextId), new Value("newContent")}, DBTestObject.allFields(), tableName, DBTestObject.id.notEq(1));
            }
        });
        assertEquals(database.getValue(DBTestObject.content, tableName, DBTestObject.id.eq(nextId)).getText(), "newContent");
    }

    @Test
    public void testDatabaseUpdateRowWhereOrderLimit() throws WCDBException {
        doTestSQLs(new String[]{
                "UPDATE testTable SET id = ?1, content = ?2 WHERE id < 3 ORDER BY id DESC LIMIT 1",
                "UPDATE testTable SET id = ?1, content = ?2 ORDER BY content DESC LIMIT 1",
        }, new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                database.updateRow(new Value[]{new Value(nextId), new Value("newContent")}, DBTestObject.allFields(), tableName, DBTestObject.id.lt(nextId), DBTestObject.id.order(Order.Desc), 1);
                database.updateRow(new Value[]{new Value(nextId + 1), new Value("newContent2")}, DBTestObject.allFields(), tableName, DBTestObject.content.order(Order.Desc), 1);
            }
        });
        assertTrue(database.getValue(DBTestObject.content.count(), tableName, DBTestObject.id.eq(nextId)).getLong() +
                database.getValue(DBTestObject.content.count(), tableName, DBTestObject.id.eq(nextId + 1)).getLong() >= 1);
        assertTrue(database.getValue(DBTestObject.id.count(), tableName, DBTestObject.content.eq("newContent")).getLong() +
                database.getValue(DBTestObject.id.count(), tableName, DBTestObject.content.eq("newContent2")).getLong() >= 1);
    }

    @Test
    public void testDatabaseUpdateRowWhereOrderLimitOffset() throws WCDBException {
        doTestSQLs(new String[]{
                "UPDATE testTable SET id = ?1, content = ?2 WHERE id < 3 ORDER BY id DESC LIMIT 1 OFFSET 1",
                "UPDATE testTable SET id = ?1, content = ?2 ORDER BY content DESC LIMIT 1 OFFSET 1",
        }, new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                database.updateRow(new Value[]{new Value(nextId), new Value("newContent")}, DBTestObject.allFields(), tableName, DBTestObject.id.lt(nextId), DBTestObject.id.order(Order.Desc), 1, 1);
                database.updateRow(new Value[]{new Value(nextId + 1), new Value("newContent2")}, DBTestObject.allFields(), tableName, DBTestObject.content.order(Order.Desc), 1, 1);
            }
        });
        assertTrue(database.getValue(DBTestObject.content.count(), tableName, DBTestObject.id.eq(nextId)).getLong() +
                database.getValue(DBTestObject.content.count(), tableName, DBTestObject.id.eq(nextId + 1)).getLong() >= 1);
        assertTrue(database.getValue(DBTestObject.id.count(), tableName, DBTestObject.content.eq("newContent")).getLong() +
                database.getValue(DBTestObject.id.count(), tableName, DBTestObject.content.eq("newContent2")).getLong() >= 1);
    }

    @Test
    public void testTableUpdateValue() throws WCDBException {
        doTestSQL("UPDATE testTable SET content = ?1", new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                table.updateValue("newContent", DBTestObject.content);
            }
        });
        assertEquals(table.getValue(DBTestObject.content).getText(), "newContent");
    }

    @Test
    public void testTableUpdateValueWhere() throws WCDBException {
        doTestSQLs(new String[]{
                "UPDATE testTable SET content = ?1 WHERE id == 1",
                "UPDATE testTable SET id = ?1 WHERE content == 'newContent'"
        }, new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                table.updateValue("newContent", DBTestObject.content, DBTestObject.id.eq(1));
                table.updateValue(nextId, DBTestObject.id, DBTestObject.content.eq("newContent"));
            }
        });
        assertEquals(table.getValue(DBTestObject.content, DBTestObject.id.eq(nextId)).getText(), "newContent");
        assertEquals(table.getValue(DBTestObject.id, DBTestObject.content.eq("newContent")).getLong(), nextId);
    }

    @Test
    public void testTableUpdateValueWhereOrderLimit() throws WCDBException {
        doTestSQLs(new String[]{
                "UPDATE testTable SET content = ?1 WHERE id > 0 ORDER BY id ASC LIMIT 1",
                "UPDATE testTable SET id = ?1 ORDER BY content ASC LIMIT 1"
        }, new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                table.updateValue("newContent", DBTestObject.content, DBTestObject.id.gt(0), DBTestObject.id.order(Order.Asc), 1);
                table.updateValue(nextId, DBTestObject.id, DBTestObject.content.order(Order.Asc), 1);
            }
        });
        assertEquals(table.getValue(DBTestObject.content.count(), DBTestObject.id.eq(nextId)).getLong(), 1);
        assertEquals(table.getValue(DBTestObject.id.count(), DBTestObject.content.eq("newContent")).getLong(), 1);
    }

    @Test
    public void testTableUpdateValueWhereOrderLimitOffset() throws WCDBException {
        doTestSQLs(new String[]{
                "UPDATE testTable SET content = ?1 WHERE id > 0 ORDER BY id ASC LIMIT 1 OFFSET 1",
                "UPDATE testTable SET id = ?1 ORDER BY content ASC LIMIT 1 OFFSET 1"
        }, new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                table.updateValue("newContent", DBTestObject.content, DBTestObject.id.gt(0), DBTestObject.id.order(Order.Asc), 1, 1);
                table.updateValue(nextId, DBTestObject.id, DBTestObject.content.order(Order.Asc), 1, 1);
            }
        });
        assertEquals(table.getValue(DBTestObject.content.count(), DBTestObject.id.eq(nextId)).getLong(), 1);
        assertEquals(table.getValue(DBTestObject.id.count(), DBTestObject.content.eq("newContent")).getLong(), 1);
    }

    @Test
    public void testTableUpdateRowWhere() throws WCDBException {
        doTestSQL("UPDATE testTable SET id = ?1, content = ?2 WHERE id != 1", new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                table.updateRow(new Value[]{new Value(nextId), new Value("newContent")}, DBTestObject.allFields(), DBTestObject.id.notEq(1));
            }
        });
        assertEquals(table.getValue(DBTestObject.content, DBTestObject.id.eq(nextId)).getText(), "newContent");
    }

    @Test
    public void testTableUpdateRowWhereOrderLimit() throws WCDBException {
        doTestSQLs(new String[]{
                "UPDATE testTable SET id = ?1, content = ?2 WHERE id < 3 ORDER BY id DESC LIMIT 1",
                "UPDATE testTable SET id = ?1, content = ?2 ORDER BY content DESC LIMIT 1",
        }, new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                table.updateRow(new Value[]{new Value(nextId), new Value("newContent")}, DBTestObject.allFields(), DBTestObject.id.lt(nextId), DBTestObject.id.order(Order.Desc), 1);
                table.updateRow(new Value[]{new Value(nextId + 1), new Value("newContent2")}, DBTestObject.allFields(), DBTestObject.content.order(Order.Desc), 1);
            }
        });
        assertTrue(table.getValue(DBTestObject.content.count(), DBTestObject.id.eq(nextId)).getLong() +
                table.getValue(DBTestObject.content.count(), DBTestObject.id.eq(nextId + 1)).getLong() >= 1);
        assertTrue(table.getValue(DBTestObject.id.count(), DBTestObject.content.eq("newContent")).getLong() +
                table.getValue(DBTestObject.id.count(), DBTestObject.content.eq("newContent2")).getLong() >= 1);
    }

    @Test
    public void testTableUpdateRowWhereOrderLimitOffset() throws WCDBException {
        doTestSQLs(new String[]{
                "UPDATE testTable SET id = ?1, content = ?2 WHERE id < 3 ORDER BY id DESC LIMIT 1 OFFSET 1",
                "UPDATE testTable SET id = ?1, content = ?2 ORDER BY content DESC LIMIT 1 OFFSET 1",
        }, new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                table.updateRow(new Value[]{new Value(nextId), new Value("newContent")}, DBTestObject.allFields(), DBTestObject.id.lt(nextId), DBTestObject.id.order(Order.Desc), 1, 1);
                table.updateRow(new Value[]{new Value(nextId + 1), new Value("newContent2")}, DBTestObject.allFields(), DBTestObject.content.order(Order.Desc), 1, 1);
            }
        });
        assertTrue(table.getValue(DBTestObject.content.count(), DBTestObject.id.eq(nextId)).getLong() +
                table.getValue(DBTestObject.content.count(), DBTestObject.id.eq(nextId + 1)).getLong() >= 1);
        assertTrue(table.getValue(DBTestObject.id.count(), DBTestObject.content.eq("newContent")).getLong() +
                table.getValue(DBTestObject.id.count(), DBTestObject.content.eq("newContent2")).getLong() >= 1);
    }

    @Test
    public void testHandleUpdateValue() throws WCDBException {
        doTestSQL("UPDATE testTable SET content = ?1", new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                handle.updateValue("newContent", DBTestObject.content, tableName);
            }
        });
        assertEquals(handle.getValue(DBTestObject.content, tableName).getText(), "newContent");
    }

    @Test
    public void testHandleUpdateValueWhere() throws WCDBException {
        doTestSQLs(new String[]{
                "UPDATE testTable SET content = ?1 WHERE id == 1",
                "UPDATE testTable SET id = ?1 WHERE content == 'newContent'"
        }, new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                handle.updateValue("newContent", DBTestObject.content, tableName, DBTestObject.id.eq(1));
                handle.updateValue(nextId, DBTestObject.id, tableName, DBTestObject.content.eq("newContent"));
            }
        });
        assertEquals(handle.getValue(DBTestObject.content, tableName, DBTestObject.id.eq(nextId)).getText(), "newContent");
        assertEquals(handle.getValue(DBTestObject.id, tableName, DBTestObject.content.eq("newContent")).getLong(), nextId);
    }

    @Test
    public void testHandleUpdateValueWhereOrderLimit() throws WCDBException {
        doTestSQLs(new String[]{
                "UPDATE testTable SET content = ?1 WHERE id > 0 ORDER BY id ASC LIMIT 1",
                "UPDATE testTable SET id = ?1 ORDER BY content ASC LIMIT 1"
        }, new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                handle.updateValue("newContent", DBTestObject.content, tableName, DBTestObject.id.gt(0), DBTestObject.id.order(Order.Asc), 1);
                handle.updateValue(nextId, DBTestObject.id, tableName, DBTestObject.content.order(Order.Asc), 1);
            }
        });
        assertEquals(handle.getValue(DBTestObject.content.count(), tableName, DBTestObject.id.eq(nextId)).getLong(), 1);
        assertEquals(handle.getValue(DBTestObject.id.count(), tableName, DBTestObject.content.eq("newContent")).getLong(), 1);
    }

    @Test
    public void testHandleUpdateValueWhereOrderLimitOffset() throws WCDBException {
        doTestSQLs(new String[]{
                "UPDATE testTable SET content = ?1 WHERE id > 0 ORDER BY id ASC LIMIT 1 OFFSET 1",
                "UPDATE testTable SET id = ?1 ORDER BY content ASC LIMIT 1 OFFSET 1"
        }, new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                handle.updateValue("newContent", DBTestObject.content, tableName, DBTestObject.id.gt(0), DBTestObject.id.order(Order.Asc), 1, 1);
                handle.updateValue(nextId, DBTestObject.id, tableName, DBTestObject.content.order(Order.Asc), 1, 1);
            }
        });
        assertEquals(handle.getValue(DBTestObject.content.count(), tableName, DBTestObject.id.eq(nextId)).getLong(), 1);
        assertEquals(handle.getValue(DBTestObject.id.count(), tableName, DBTestObject.content.eq("newContent")).getLong(), 1);
    }

    @Test
    public void testHandleUpdateRowWhere() throws WCDBException {
        doTestSQL("UPDATE testTable SET id = ?1, content = ?2 WHERE id != 1", new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                handle.updateRow(new Value[]{new Value(nextId), new Value("newContent")}, DBTestObject.allFields(), tableName, DBTestObject.id.notEq(1));
            }
        });
        assertEquals(handle.getValue(DBTestObject.content, tableName, DBTestObject.id.eq(nextId)).getText(), "newContent");
    }

    @Test
    public void testHandleUpdateRowWhereOrderLimit() throws WCDBException {
        doTestSQLs(new String[]{
                "UPDATE testTable SET id = ?1, content = ?2 WHERE id < 3 ORDER BY id DESC LIMIT 1",
                "UPDATE testTable SET id = ?1, content = ?2 ORDER BY content DESC LIMIT 1",
        }, new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                handle.updateRow(new Value[]{new Value(nextId), new Value("newContent")}, DBTestObject.allFields(), tableName, DBTestObject.id.lt(nextId), DBTestObject.id.order(Order.Desc), 1);
                handle.updateRow(new Value[]{new Value(nextId + 1), new Value("newContent2")}, DBTestObject.allFields(), tableName, DBTestObject.content.order(Order.Desc), 1);
            }
        });
        assertTrue(handle.getValue(DBTestObject.content.count(), tableName, DBTestObject.id.eq(nextId)).getLong() +
                handle.getValue(DBTestObject.content.count(), tableName, DBTestObject.id.eq(nextId + 1)).getLong() >= 1);
        assertTrue(handle.getValue(DBTestObject.id.count(), tableName, DBTestObject.content.eq("newContent")).getLong() +
                handle.getValue(DBTestObject.id.count(), tableName, DBTestObject.content.eq("newContent2")).getLong() >= 1);
    }

    @Test
    public void testHandleUpdateRowWhereOrderLimitOffset() throws WCDBException {
        doTestSQLs(new String[]{
                "UPDATE testTable SET id = ?1, content = ?2 WHERE id < 3 ORDER BY id DESC LIMIT 1 OFFSET 1",
                "UPDATE testTable SET id = ?1, content = ?2 ORDER BY content DESC LIMIT 1 OFFSET 1",
        }, new TestOperation() {
            @Override
            public void execute() throws WCDBException {
                handle.updateRow(new Value[]{new Value(nextId), new Value("newContent")}, DBTestObject.allFields(), tableName, DBTestObject.id.lt(nextId), DBTestObject.id.order(Order.Desc), 1, 1);
                handle.updateRow(new Value[]{new Value(nextId + 1), new Value("newContent2")}, DBTestObject.allFields(), tableName, DBTestObject.content.order(Order.Desc), 1, 1);
            }
        });
        assertTrue(handle.getValue(DBTestObject.content.count(), tableName, DBTestObject.id.eq(nextId)).getLong() +
                handle.getValue(DBTestObject.content.count(), tableName, DBTestObject.id.eq(nextId + 1)).getLong() >= 1);
        assertTrue(handle.getValue(DBTestObject.id.count(), tableName, DBTestObject.content.eq("newContent")).getLong() +
                handle.getValue(DBTestObject.id.count(), tableName, DBTestObject.content.eq("newContent2")).getLong() >= 1);
    }
}
