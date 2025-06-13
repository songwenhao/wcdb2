//
// Created by qiuwenchen on 2023/12/3.
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

#if TEST_WCDB_OBJC
#import <WCDBOBjc/WCDBObjc.h>
#elif TEST_WCDB_CPP
#import <WCDBCpp/WCDBCpp.h>
#else
#import <WCDB/WCDBObjc.h>
#endif

@interface CompressionTestObject : NSObject <WCTTableCoding>

@property (nonatomic, assign) int mainId;
@property (nonatomic, assign) double subId;
@property (nonatomic, strong) NSString* text;
@property (nonatomic, assign) int textMatchId;
@property (nonatomic, strong) NSData* blob;
@property (nonatomic, assign) int blobMatchId;

WCDB_PROPERTY(mainId);
WCDB_PROPERTY(subId);
WCDB_PROPERTY(text);
WCDB_PROPERTY(textMatchId)
WCDB_PROPERTY(blob);
WCDB_PROPERTY(blobMatchId)

@end
