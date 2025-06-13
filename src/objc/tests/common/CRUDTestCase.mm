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

#import "CRUDTestCase.h"
#import "Random+TestCaseObject.h"
#import "Random.h"
#import "TestCaseAssertion.h"
#if TEST_WCDB_OBJC
#import <WCDBOBjc/WCTDatabase+Test.h>
#elif TEST_WCDB_CPP
#import <WCDBCpp/WCTDatabase+Test.h>
#else
#import <WCDB/WCTDatabase+Test.h>
#endif

@implementation CRUDTestCase {
    TestCaseObject* _object1;
    TestCaseObject* _object2;
    NSArray<TestCaseObject*>* _objects;
}

- (TestCaseObject*)object1
{
    @synchronized(self) {
        if (_object1 == nil) {
            _object1 = [Random.shared testCaseObjectWithIdentifier:1];
        }
        return _object1;
    }
}

- (TestCaseObject*)object2
{
    @synchronized(self) {
        if (_object2 == nil) {
            _object2 = [Random.shared testCaseObjectWithIdentifier:2];
        }
        return _object2;
    }
}

- (NSArray<TestCaseObject*>*)objects
{
    @synchronized(self) {
        if (_objects == nil) {
            _objects = @[ self.object1, self.object2 ];
        }
        return _objects;
    }
}

- (void)insertPresetObjects
{
    TestCaseAssertTrue([self createTable]);
    TestCaseAssertTrue([self.table insertObjects:self.objects]);
    [self.database close];
}

@end
