//
// Created by sanhuazhang on 2019/07/05
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

#import "Random+WCDB.h"

@implementation Random (WCDB)

- (long)tag
{
    long tag;
    do {
        tag = self.int32;
    } while (tag == 0);
    return tag;
}

- (NSString *)tableName
{
    return [self tableNameWithPrefix:@"t_"];
}

- (NSString *)tableNameWithPrefix:(NSString *)prefix
{
    return [NSString stringWithFormat:@"%@%@", prefix, self.string];
}

- (NSArray<NSString *> *)tableNamesWithCount:(int)count
{
    NSMutableArray<NSString *> *tableNames = [NSMutableArray array];
    for (int i = 0; i < count; ++i) {
        [tableNames addObject:self.tableName];
    }
    return tableNames;
}

@end
