//
// Created by qiuwenchen on 2023/7/24.
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

#import "MigrationTestObjectBase.h"
#import "NSObject+TestCase.h"

@implementation MigrationTestObjectBase

- (BOOL)isEqual:(NSObject*)object
{
    if (object.class != self.class) {
        return NO;
    }
    MigrationTestObjectBase* other = (MigrationTestObjectBase*) object;
    if (self.identifier != other.identifier) {
        return NO;
    }
    if (self.classification != other.classification) {
        return NO;
    }
    if (![NSObject isObject:self.content nilEqualToObject:other.content]) {
        return NO;
    }
    return YES;
}

- (NSUInteger)hash
{
    NSMutableData* data = [NSMutableData data];
    [data appendBytes:&(_identifier) length:sizeof(_identifier)];
    [data appendData:[_content dataUsingEncoding:NSUTF8StringEncoding]];
    return data.hash;
}

@end
