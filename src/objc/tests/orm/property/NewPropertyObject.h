//
// Created by qiuwenchen on 2022/12/4.
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

#import <Foundation/Foundation.h>
#if TEST_WCDB_OBJC
#import <WCDBOBjc/WCDBObjc.h>
#elif TEST_WCDB_CPP
#import <WCDBCpp/WCDBCpp.h>
#else
#import <WCDB/WCDBObjc.h>
#endif

@interface NewPropertyObject : NSObject <WCTTableCoding>

@property (nonatomic, assign) int primaryValue;
@property (nonatomic, assign) int uniqueValue;
@property (nonatomic, assign) int insertValue;
@property (nonatomic, assign) int updateValue;
@property (nonatomic, assign) int selectValue;
@property (nonatomic, assign) int multiSelectValue;
@property (nonatomic, assign) int deleteValue;
@property (nonatomic, assign) int indexValue;

WCDB_PROPERTY(primaryValue)
WCDB_PROPERTY(uniqueValue)
WCDB_PROPERTY(insertValue)
WCDB_PROPERTY(updateValue)
WCDB_PROPERTY(selectValue)
WCDB_PROPERTY(multiSelectValue)
WCDB_PROPERTY(deleteValue)

@end
