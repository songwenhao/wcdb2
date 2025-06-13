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

#import "TestCaseObject.h"
#import "NSObject+TestCase.h"
#import "TestCaseObject+WCTTableCoding.h"
#if TEST_WCDB_OBJC
#import <WCDBOBjc/WCDBObjc.h>
#elif TEST_WCDB_CPP
#import <WCDBCpp/WCDBCpp.h>
#else
#import <WCDB/WCDBObjc.h>
#endif

@implementation TestCaseObject

WCDB_IMPLEMENTATION(TestCaseObject)
WCDB_SYNTHESIZE(identifier)
WCDB_SYNTHESIZE(content)

WCDB_PRIMARY_ASC_AUTO_INCREMENT(identifier)
@synthesize lastInsertedRowID;

- (BOOL)isEqual:(NSObject*)object
{
    if (object.class != self.class) {
        return NO;
    }
    TestCaseObject* other = (TestCaseObject*) object;
    return self.identifier == other.identifier && [NSObject isObject:self.content nilEqualToObject:other.content];
}

- (NSUInteger)hash
{
    NSMutableData* data = [NSMutableData data];
    [data appendBytes:&(_identifier) length:sizeof(_identifier)];
    [data appendData:[_content dataUsingEncoding:NSUTF8StringEncoding]];
    return data.hash;
}

+ (instancetype)objectWithIdentifier:(int)identifier andContent:(NSString*)content
{
    TestCaseObject* object = [[TestCaseObject alloc] init];
    object.identifier = identifier;
    object.content = content;
    return object;
}

+ (instancetype)partialObjectWithIdentifier:(int)identifier
{
    return [self objectWithIdentifier:identifier andContent:nil];
}

+ (instancetype)autoIncrementObjectWithContent:(NSString*)content
{
    TestCaseObject* object = [self objectWithIdentifier:0 andContent:content];
    object.isAutoIncrement = YES;
    return object;
}

@end
