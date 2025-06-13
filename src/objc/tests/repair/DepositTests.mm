//
// Created by sanhuazhang on 2019/05/02
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

#import "BackupTestCase.h"
#import "Random+RepairTestObject.h"

@interface DepositTests : BackupTestCase

@end

@implementation DepositTests

- (void)test_desposit
{
    [self
    executeTest:^{
        int rowId = (int) self.objects.count;
        {
            // 1.
            TestCaseAssertTrue([self.database backup]);
            TestCaseAssertTrue([self.database deposit]);

            NSNumber* count = [self.database getValueFromStatement:WCDB::StatementSelect().select([self.testClass allProperties].count()).from(self.tableName)].numberValue;
            TestCaseAssertTrue(count != nil);
            TestCaseAssertTrue(count.integerValue == 0);

            if ([self.testClass isAutoIncrement]) {
                NSObject<RepairTestObject>* object = [Random.shared repairObjectWithClass:self.testClass andIdentifier:0];
                object.isAutoIncrement = YES;

                TestCaseAssertTrue([self.table insertObject:object]);
                ++rowId;
                TestCaseAssertTrue(object.lastInsertedRowID == rowId);
            }
        }

        {
            // 2.
            TestCaseAssertTrue([self.database backup]);
            TestCaseAssertTrue([self.database deposit]);

            NSNumber* count = [self.database getValueFromStatement:WCDB::StatementSelect().select(TestCaseObject.allProperties.count()).from(self.tableName)].numberValue;
            TestCaseAssertTrue(count != nil);
            TestCaseAssertTrue(count.integerValue == 0);

            if ([self.testClass isAutoIncrement]) {
                NSObject<RepairTestObject>* object = [Random.shared repairObjectWithClass:self.testClass andIdentifier:0];
                object.isAutoIncrement = YES;

                TestCaseAssertTrue([self.table insertObject:object]);
                ++rowId;
                TestCaseAssertTrue(object.lastInsertedRowID == rowId);
            }
        }

        TestCaseAssertTrue([self.fileManager fileExistsAtPath:self.database.factoryPath]);
        TestCaseAssertTrue([self.database containsDeposited]);
        TestCaseAssertTrue([self.database removeDeposited]);
        TestCaseAssertFalse([self.database containsDeposited]);
        TestCaseAssertFalse([self.fileManager fileExistsAtPath:self.database.factoryPath]);
    }];
}

@end
