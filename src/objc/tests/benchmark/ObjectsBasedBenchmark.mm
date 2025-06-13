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

@implementation ObjectsBasedBenchmark {
    ObjectsBasedFactory* _factory;
}

- (ObjectsBasedFactory*)factory
{
    @synchronized(self) {
        if (_factory == nil) {
            _factory = [[ObjectsBasedFactory alloc] initWithDirectory:self.class.cacheRoot];
        }
        return _factory;
    }
}

- (void)setUp
{
    [super setUp];

    self.factory.tolerance = 0.0f;
    self.factory.quality = 1000000;

    self.testQuality = 100000;
    self.tableName = self.factory.tableName;
}

- (void)setUpDatabase
{
    [self.factory produce:self.path];

    TestCaseAssertOptionalEqual([self.database getNumberOfWalFrames], 0);
    TestCaseAssertFalse([self.database isOpened]);
}

- (void)tearDownDatabase
{
    [self.database removeFiles];
}

- (void)doTestWrite
{
    NSArray* objects = [Random.shared testCaseObjectsWithCount:self.testQuality startingFromIdentifier:(int) self.factory.quality];
    __block BOOL result;
    [self
    doMeasure:^{
        for (TestCaseObject* object in objects) {
            if (![self.database insertObject:object intoTable:self.tableName]) {
                result = NO;
                return;
            }
        }
        result = YES;
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

- (void)doTestRead
{
    __block NSMutableArray<TestCaseObject*>* result;
    [self
    doMeasure:^{
        for (int i = 1; i <= self.testQuality; i++) {
            TestCaseObject* obj = [self.database getObjectOfClass:TestCaseObject.class fromTable:self.tableName where:TestCaseObject.identifier == i];
            [result addObject:obj];
        }
    }
    setUp:^{
        [self setUpDatabase];
    }
    tearDown:^{
        [self tearDownDatabase];
        result = [NSMutableArray new];
    }
    checkCorrectness:^{
        TestCaseAssertEqual(result.count, self.testQuality);
    }];
}

- (void)doTestBatchRead
{
    __block NSArray<TestCaseObject*>* result;
    [self
    doMeasure:^{
        result = [self.database getObjectsOfClass:TestCaseObject.class fromTable:self.tableName limit:self.testQuality];
    }
    setUp:^{
        [self setUpDatabase];
    }
    tearDown:^{
        [self tearDownDatabase];
        result = nil;
    }
    checkCorrectness:^{
        TestCaseAssertEqual(result.count, self.testQuality);
    }];
}

- (void)doTestBatchWrite
{
    NSArray* objects = [Random.shared testCaseObjectsWithCount:self.testQuality startingFromIdentifier:(int) self.factory.quality];
    __block BOOL result;
    [self
    doMeasure:^{
        result = [self.database insertObjects:objects intoTable:self.tableName];
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

- (void)doTestRandomRead
{
    __block NSMutableArray<TestCaseObject*>* result = [[NSMutableArray alloc] initWithCapacity:self.testQuality];
    __block NSMutableArray<WCTValue*>* identifiers;
    [self
    doMeasure:^{
        int index = 0;
        for (int i = 1; i <= self.testQuality; i++) {
            index = [[Random shared] uint32] % identifiers.count;

            TestCaseObject* obj = [self.database getObjectOfClass:TestCaseObject.class fromTable:self.tableName where:TestCaseObject.identifier == identifiers[index].numberValue.intValue];
            if (obj == nil) {
                continue;
                ;
            }
            [result addObject:obj];
            [identifiers removeObjectAtIndex:index];
        }
    }
    setUp:^{
        [self setUpDatabase];
        identifiers = (NSMutableArray<WCTValue*>*) [self.database getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName];
    }
    tearDown:^{
        [self tearDownDatabase];
        result = [[NSMutableArray alloc] initWithCapacity:self.testQuality];
    }
    checkCorrectness:^{
        TestCaseAssertEqual(result.count, self.testQuality);
    }];
}

- (void)doTestRandomUpdate
{
    __block NSMutableArray<WCTValue*>* identifiers;
    [self
    doMeasure:^{
        int index = 0;
        for (int i = 1; i <= self.testQuality; i++) {
            index = [[Random shared] uint32] % identifiers.count;
            TestCaseAssertTrue([self.database updateTable:self.tableName setProperty:TestCaseObject.content toValue:Random.shared.string where:TestCaseObject.identifier == identifiers[index].numberValue.intValue]);
            [identifiers removeObjectAtIndex:index];
        }
    }
    setUp:^{
        [self setUpDatabase];
        identifiers = (NSMutableArray<WCTValue*>*) [self.database getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName];
    }
    tearDown:^{
        [self tearDownDatabase];
    }
    checkCorrectness:nil];
}

- (void)doTestRandomDelete
{
    __block NSMutableArray<WCTValue*>* identifiers;
    [self
    doMeasure:^{
        int index = 0;
        for (int i = 1; i <= self.testQuality; i++) {
            index = [[Random shared] uint32] % identifiers.count;
            TestCaseAssertTrue([self.database deleteFromTable:self.tableName where:TestCaseObject.identifier == identifiers[index].numberValue.intValue]);
            [identifiers removeObjectAtIndex:index];
        }
    }
    setUp:^{
        [self setUpDatabase];
        identifiers = (NSMutableArray<WCTValue*>*) [self.database getColumnOnResultColumn:TestCaseObject.identifier fromTable:self.tableName];
    }
    tearDown:^{
        [self tearDownDatabase];
    }
    checkCorrectness:^{
        WCTValue* count = [self.database getValueOnResultColumn:WCDB::Column::all().count() fromTable:self.tableName];
        TestCaseAssertTrue(count.numberValue.intValue == self.factory.quality - self.testQuality);
    }];
}

@end
