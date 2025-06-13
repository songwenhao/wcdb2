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

import com.tencent.wcdb.base.WCDBException;
import com.tencent.wcdb.winq.Order;
import com.tencent.wcdbtest.base.DBTestObject;
import com.tencent.wcdbtest.base.ObjectCRUDTestCase;
import com.tencent.wcdbtest.base.RandomTool;
import com.tencent.wcdbtest.base.TestObject;

import org.junit.Before;
import org.junit.Test;

import java.util.Arrays;

public class ObjectUpdateTest extends ObjectCRUDTestCase {
    TestObject renewObject;
    TestObject renewedObject1;
    TestObject renewedObject2;

    @Before
    public void setup() throws WCDBException {
        super.setup();
        String renewContent = RandomTool.string();
        renewObject = TestObject.createObject(0, renewContent);
        renewedObject1 = TestObject.createObject(1, renewContent);
        renewedObject2 = TestObject.createObject(2, renewContent);
    }

    @Test
    public void testDatabaseUpdateObject() {
        doTestObjectsAfterOperation(Arrays.asList(renewedObject1, renewedObject2),
                "UPDATE testTable SET content = ?1",
                new TestOperation() {
                    @Override
                    public void execute() throws WCDBException {
                        database.updateObject(renewObject, DBTestObject.content, tableName);
                    }
                });
    }

    @Test
    public void testDatabaseUpdateObjectWhere() {
        doTestObjectsAfterOperation(Arrays.asList(renewedObject1, object2),
                "UPDATE testTable SET content = ?1 WHERE id == 1",
                new TestOperation() {
                    @Override
                    public void execute() throws WCDBException {
                        database.updateObject(renewObject, DBTestObject.content, tableName, DBTestObject.id.eq(1));
                    }
                });
    }

    @Test
    public void testDatabaseUpdateObjectWhereOrderLimit() {
        doTestObjectsAfterOperation(Arrays.asList(object1, renewedObject2),
                "UPDATE testTable SET content = ?1 WHERE id > 0 ORDER BY id DESC LIMIT 1",
                new TestOperation() {
                    @Override
                    public void execute() throws WCDBException {
                        database.updateObject(renewObject,
                                DBTestObject.content,
                                tableName,
                                DBTestObject.id.gt(0),
                                DBTestObject.id.order(Order.Desc), 1);
                    }
                });
    }

    @Test
    public void testDatabaseUpdateObjectWhereOrderLimitOffset() {
        doTestObjectsAfterOperation(Arrays.asList(renewedObject1, object2),
                "UPDATE testTable SET content = ?1 WHERE id > 0 ORDER BY id DESC LIMIT 1 OFFSET 1",
                new TestOperation() {
                    @Override
                    public void execute() throws WCDBException {
                        database.updateObject(renewObject,
                                DBTestObject.content,
                                tableName,
                                DBTestObject.id.gt(0),
                                DBTestObject.id.order(Order.Desc), 1, 1);
                    }
                });
    }

    @Test
    public void testDatabaseUpdateObjectOrderLimit() {
        doTestObjectsAfterOperation(Arrays.asList(object1, renewedObject2),
                "UPDATE testTable SET content = ?1 ORDER BY id DESC LIMIT 1",
                new TestOperation() {
                    @Override
                    public void execute() throws WCDBException {
                        database.updateObject(renewObject,
                                DBTestObject.content,
                                tableName,
                                DBTestObject.id.order(Order.Desc), 1);
                    }
                });
    }

    @Test
    public void testDatabaseUpdateObjectOrderLimitOffset() {
        doTestObjectsAfterOperation(Arrays.asList(renewedObject1, object2),
                "UPDATE testTable SET content = ?1 ORDER BY id DESC LIMIT 1 OFFSET 1",
                new TestOperation() {
                    @Override
                    public void execute() throws WCDBException {
                        database.updateObject(renewObject,
                                DBTestObject.content,
                                tableName,
                                DBTestObject.id.order(Order.Desc), 1, 1);
                    }
                });
    }

    @Test
    public void testTableUpdateObject() {
        doTestObjectsAfterOperation(Arrays.asList(renewedObject1, renewedObject2),
                "UPDATE testTable SET content = ?1",
                new TestOperation() {
                    @Override
                    public void execute() throws WCDBException {
                        table.updateObject(renewObject, DBTestObject.content);
                    }
                });
    }

    @Test
    public void testTableUpdateObjectWhere() {
        doTestObjectsAfterOperation(Arrays.asList(renewedObject1, object2),
                "UPDATE testTable SET content = ?1 WHERE id == 1",
                new TestOperation() {
                    @Override
                    public void execute() throws WCDBException {
                        table.updateObject(renewObject, DBTestObject.content, DBTestObject.id.eq(1));
                    }
                });
    }

    @Test
    public void testTableUpdateObjectWhereOrderLimit() {
        doTestObjectsAfterOperation(Arrays.asList(object1, renewedObject2),
                "UPDATE testTable SET content = ?1 WHERE id > 0 ORDER BY id DESC LIMIT 1",
                new TestOperation() {
                    @Override
                    public void execute() throws WCDBException {
                        table.updateObject(renewObject,
                                DBTestObject.content,
                                DBTestObject.id.gt(0),
                                DBTestObject.id.order(Order.Desc), 1);
                    }
                });
    }

    @Test
    public void testTableUpdateObjectWhereOrderLimitOffset() {
        doTestObjectsAfterOperation(Arrays.asList(renewedObject1, object2),
                "UPDATE testTable SET content = ?1 WHERE id > 0 ORDER BY id DESC LIMIT 1 OFFSET 1",
                new TestOperation() {
                    @Override
                    public void execute() throws WCDBException {
                        table.updateObject(renewObject,
                                DBTestObject.content,
                                DBTestObject.id.gt(0),
                                DBTestObject.id.order(Order.Desc), 1, 1);
                    }
                });
    }

    @Test
    public void testTableUpdateObjectOrderLimit() {
        doTestObjectsAfterOperation(Arrays.asList(object1, renewedObject2),
                "UPDATE testTable SET content = ?1 ORDER BY id DESC LIMIT 1",
                new TestOperation() {
                    @Override
                    public void execute() throws WCDBException {
                        table.updateObject(renewObject,
                                DBTestObject.content,
                                DBTestObject.id.order(Order.Desc), 1);
                    }
                });
    }

    @Test
    public void testTableUpdateObjectOrderLimitOffset() {
        doTestObjectsAfterOperation(Arrays.asList(renewedObject1, object2),
                "UPDATE testTable SET content = ?1 ORDER BY id DESC LIMIT 1 OFFSET 1",
                new TestOperation() {
                    @Override
                    public void execute() throws WCDBException {
                        table.updateObject(renewObject,
                                DBTestObject.content,
                                DBTestObject.id.order(Order.Desc), 1, 1);
                    }
                });
    }

    @Test
    public void testHandleUpdateObject() {
        doTestObjectsAfterOperation(Arrays.asList(renewedObject1, renewedObject2),
                "UPDATE testTable SET content = ?1",
                new TestOperation() {
                    @Override
                    public void execute() throws WCDBException {
                        handle.updateObject(renewObject, DBTestObject.content, tableName);
                    }
                });
    }

    @Test
    public void testHandleUpdateObjectWhere() {
        doTestObjectsAfterOperation(Arrays.asList(renewedObject1, object2),
                "UPDATE testTable SET content = ?1 WHERE id == 1",
                new TestOperation() {
                    @Override
                    public void execute() throws WCDBException {
                        handle.updateObject(renewObject, DBTestObject.content, tableName, DBTestObject.id.eq(1));
                    }
                });
    }

    @Test
    public void testHandleUpdateObjectWhereOrderLimit() {
        doTestObjectsAfterOperation(Arrays.asList(object1, renewedObject2),
                "UPDATE testTable SET content = ?1 WHERE id > 0 ORDER BY id DESC LIMIT 1",
                new TestOperation() {
                    @Override
                    public void execute() throws WCDBException {
                        handle.updateObject(renewObject,
                                DBTestObject.content,
                                tableName,
                                DBTestObject.id.gt(0),
                                DBTestObject.id.order(Order.Desc), 1);
                    }
                });
    }

    @Test
    public void testHandleUpdateObjectWhereOrderLimitOffset() {
        doTestObjectsAfterOperation(Arrays.asList(renewedObject1, object2),
                "UPDATE testTable SET content = ?1 WHERE id > 0 ORDER BY id DESC LIMIT 1 OFFSET 1",
                new TestOperation() {
                    @Override
                    public void execute() throws WCDBException {
                        handle.updateObject(renewObject,
                                DBTestObject.content,
                                tableName,
                                DBTestObject.id.gt(0),
                                DBTestObject.id.order(Order.Desc), 1, 1);
                    }
                });
    }

    @Test
    public void testHandleUpdateObjectOrderLimit() {
        doTestObjectsAfterOperation(Arrays.asList(object1, renewedObject2),
                "UPDATE testTable SET content = ?1 ORDER BY id DESC LIMIT 1",
                new TestOperation() {
                    @Override
                    public void execute() throws WCDBException {
                        handle.updateObject(renewObject,
                                DBTestObject.content,
                                tableName,
                                DBTestObject.id.order(Order.Desc), 1);
                    }
                });
    }

    @Test
    public void testHandleUpdateObjectOrderLimitOffset() {
        doTestObjectsAfterOperation(Arrays.asList(renewedObject1, object2),
                "UPDATE testTable SET content = ?1 ORDER BY id DESC LIMIT 1 OFFSET 1",
                new TestOperation() {
                    @Override
                    public void execute() throws WCDBException {
                        handle.updateObject(renewObject,
                                DBTestObject.content,
                                tableName,
                                DBTestObject.id.order(Order.Desc), 1, 1);
                    }
                });
    }
}
