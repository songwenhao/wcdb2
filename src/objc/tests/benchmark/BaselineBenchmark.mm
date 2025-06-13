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

#import "ObjectsBasedBenchmark.h"

@interface BaselineBenchmark : ObjectsBasedBenchmark

@end

@implementation BaselineBenchmark

- (void)test_write
{
    [self doTestWrite];
}

- (void)test_read
{
    [self doTestRead];
}

- (void)test_batch_read
{
    [self doTestBatchRead];
}

- (void)test_batch_write
{
    [self doTestBatchWrite];
}

- (void)test_create_index
{
    __block BOOL result;
    [self
    doMeasure:^{
        NSString* indexName = [NSString stringWithFormat:@"%@_index", self.tableName];
        WCDB::StatementCreateIndex statement = WCDB::StatementCreateIndex().createIndex(indexName).table(self.tableName).indexed(TestCaseObject.identifier);

        result = [self.database execute:statement];
    }
    setUp:^{
        [self setUpDatabase];
    }
    tearDown:^{
        [self tearDownDatabase];
        result = NO;
    }
    checkCorrectness:^{
        TestCaseAssertTrue(result);
    }];
}

- (void)test_winq_read
{
    [self
           doMeasure:^{
               for (int i = 0; i < self.testQuality; i++) {
                   WCDB::StatementSelect select = WCDB::StatementSelect().select(TestCaseObject.allProperties).from(self.tableName).where(TestCaseObject.identifier == 1);
                   WCDB::StringView description = select.getDescription();
               }
           }
               setUp:nil
            tearDown:nil
    checkCorrectness:nil];
}

- (void)test_winq_write
{
    [self
           doMeasure:^{
               for (int i = 0; i < self.testQuality; i++) {
                   WCDB::StatementInsert insert = WCDB::StatementInsert().insertIntoTable(self.tableName).columns(TestCaseObject.allProperties).values(WCDB::BindParameter::bindParameters(TestCaseObject.allProperties.size()));
                   WCDB::StringView description = insert.getDescription();
               }
           }
               setUp:nil
            tearDown:nil
    checkCorrectness:nil];
}

@end
