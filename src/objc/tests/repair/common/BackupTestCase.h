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

#import "RepairTestObject.h"
#import "TestCase.h"

@interface BackupTestCase : TableTestCase

@property (nonatomic, assign) BOOL needCipher;
@property (nonatomic, strong) Class<RepairTestObject> testClass;
@property (nonatomic, assign) int objectCount;
@property (nonatomic, readonly) NSMutableArray<NSObject<RepairTestObject>*>* objects;
@property (nonatomic, assign) bool incrementalBackup;
@property (nonatomic, assign) bool corruptHeader;

- (void)setObjects:(NSMutableArray*)objects;

- (void)executeTest:(void (^)())operation;

- (void)executeFullTest:(void (^)())operation withCheck:(void (^)())check;

- (void)checkObjects:(NSArray*)object containedIn:(NSArray*)allObject;

@end
