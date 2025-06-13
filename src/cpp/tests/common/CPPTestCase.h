//
// Created by qiuwenchen on 2022/8/10.
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

#import "CPPBaseTestCase.h"
#import "CPPCRUDTestCase.h"
#import "CPPDatabaseTestCase.h"
#import "CPPORMTestUtil.h"
#import "CPPTableTestCase.h"
#import "CPPTestCaseAssertion.h"
#import "CPPTestCaseObject.h"
#import "Dispatch.h"
#import "NSObject+TestCase.h"
#import "Random+CPPTestObject.h"
#import "Random+WCDB.h"
#import "Random.h"
#import "Signpost.h"
#import "TestCaseAssertion.h"
#import "TestCaseLog.h"
#import "TestCaseMacro.h"
#if TEST_WCDB_OBJC
#import <WCDBOBjc/WCDBCpp.h>
#elif TEST_WCDB_CPP
#import <WCDBCpp/WCDBCpp.h>
#else
#import <WCDB/WCDBCpp.h>
#endif
