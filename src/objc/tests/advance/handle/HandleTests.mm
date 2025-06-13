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

#import "TestCase.h"

@interface HandleTests : CRUDTestCase

@property (nonatomic, readonly) WCTHandle* handle;

@property (nonatomic, readonly) WCDB::StatementInsert statementInsert;

@property (nonatomic, readonly) WCDB::StatementSelect statementSelect;

@end

@implementation HandleTests {
    WCTHandle* _handle;
}

- (void)setUp
{
    [super setUp];

    _statementInsert = WCDB::StatementInsert()
                       .insertIntoTable(self.tableName)
                       .columns({ TestCaseObject.identifier, TestCaseObject.content })
                       .values({ 3, WCDB::BindParameter(1) });

    _statementSelect = WCDB::StatementSelect()
                       .select(TestCaseObject.content)
                       .from(self.tableName)
                       .where(TestCaseObject.identifier == 3);

    [self insertPresetObjects];
}

- (WCTHandle*)handle
{
    @synchronized(self) {
        if (_handle == nil) {
            _handle = [self.database getHandle];
        }
        return _handle;
    }
}

- (void)tearDown
{
    if ([_handle isValidated]) {
        [_handle invalidate];
    }
    _handle = nil;
    [super tearDown];
}

#pragma mark - Handle
- (void)test_tag
{
    TestCaseAssertEqual(self.handle.database.tag, self.database.tag);
}

#pragma mark - Execute
- (void)test_execute
{
    [self doTestSQLs:@[ @"PRAGMA user_version = 123" ]
         inOperation:^BOOL {
             return [self.handle execute:WCDB::StatementPragma().pragma(WCDB::Pragma::userVersion()).to(123)];
         }];
}

#pragma mark - Prepare
- (void)test_prepare
{
    WCDB::StatementPragma statement = WCDB::StatementPragma().pragma(WCDB::Pragma::userVersion()).to(123);
    TestCaseAssertFalse([self.handle isPrepared]);
    TestCaseAssertTrue([self.handle prepare:statement]);
    TestCaseAssertTrue([self.handle isPrepared]);
    [self.handle finalizeStatement];
    TestCaseAssertFalse([self.handle isPrepared]);
}

#pragma mark - Step
- (void)test_step
{
    [self doTestSQLs:@[ @"INSERT INTO testTable(identifier, content) VALUES(?1, ?2)", @"INSERT INTO testTable(identifier, content) VALUES(?1, ?2)" ]
         inOperation:^BOOL {
             WCDB::StatementInsert statement = WCDB::StatementInsert().insertIntoTable(self.tableName).column(WCDB::Column(@"identifier")).column(WCDB::Column(@"content")).values(WCDB::BindParameter::bindParameters(2));
             if (![self.handle prepare:statement]) {
                 return NO;
             }

             [self.handle bindInteger:3
                              toIndex:1];
             [self.handle bindString:Random.shared.string toIndex:2];
             if (![self.handle step]) {
                 return NO;
             }

             [self.handle reset];
             [self.handle bindInteger:4 toIndex:1];
             [self.handle bindString:Random.shared.string toIndex:2];
             BOOL succeed = [self.handle step] && [self.handle done];
             [self.handle finalizeStatement];
             return succeed;
         }];
}

#pragma mark - State
- (void)test_readonly
{
    {
        WCDB::StatementPragma statement = WCDB::StatementPragma().pragma(WCDB::Pragma::userVersion());
        TestCaseAssertTrue([self.handle prepare:statement]);
        TestCaseAssertTrue([self.handle isStatementReadonly]);
        [self.handle finalizeStatement];
    }
    {
        WCDB::StatementPragma statement = WCDB::StatementPragma().pragma(WCDB::Pragma::userVersion()).to(123);
        TestCaseAssertTrue([self.handle prepare:statement]);
        TestCaseAssertFalse([self.handle isStatementReadonly]);
        [self.handle finalizeStatement];
    }
}

- (void)test_changes
{
    TestCaseAssertTrue([self.handle execute:WCDB::StatementDelete().deleteFrom(self.tableName)]);
    TestCaseAssertEqual([self.handle getChanges], self.objects.count);
}

- (void)test_get_last_inserted
{
    WCDB::StatementInsert statement = WCDB::StatementInsert().insertIntoTable(self.tableName).column(WCDB::Column(@"identifier")).column(WCDB::Column(@"content")).value(nullptr).value(Random.shared.string);
    TestCaseAssertTrue([self.handle execute:statement]);
    TestCaseAssertEqual([self.handle getLastInsertedRowID], 3);
}

#pragma mark - Bind && Get
- (void)test_integer
{
    int64_t value = Random.shared.int64;
    {
        TestCaseAssertTrue([self.handle prepare:self.statementInsert]);
        [self.handle bindInteger:value toIndex:1];

        TestCaseAssertTrue([self.handle step]);
        [self.handle finalizeStatement];
    }
    {
        TestCaseAssertTrue([self.handle prepare:self.statementSelect]);
        TestCaseAssertTrue([self.handle step]);
        TestCaseAssertEqual([self.handle extractIntegerAtIndex:0], value);
        [self.handle finalizeStatement];
    }
}

- (void)test_double
{
    double value = 1.2;
    {
        TestCaseAssertTrue([self.handle prepare:self.statementInsert]);
        [self.handle bindDouble:value toIndex:1];

        TestCaseAssertTrue([self.handle step]);
        [self.handle finalizeStatement];
    }
    {
        TestCaseAssertTrue([self.handle prepare:self.statementSelect]);
        TestCaseAssertTrue([self.handle step]);

        double extractedValue = [self.handle extractDoubleAtIndex:0];
        TestCaseAssertTrue(extractedValue == value);
        [self.handle finalizeStatement];
    }
}

- (void)test_null
{
    {
        TestCaseAssertTrue([self.handle prepare:self.statementInsert]);
        [self.handle bindNullToIndex:1];

        TestCaseAssertTrue([self.handle step]);
        [self.handle finalizeStatement];
    }
    {
        TestCaseAssertTrue([self.handle prepare:self.statementSelect]);
        TestCaseAssertTrue([self.handle step]);
        TestCaseAssertEqual([self.handle extractTypeAtIndex:0], WCTColumnTypeNull);
        [self.handle finalizeStatement];
    }
}

- (void)test_string
{
    NSString* value = Random.shared.string;
    TestCaseAssertTrue(value != nil);
    {
        TestCaseAssertTrue([self.handle prepare:self.statementInsert]);
        [self.handle bindString:value toIndex:1];

        TestCaseAssertTrue([self.handle step]);
        [self.handle finalizeStatement];
    }
    {
        TestCaseAssertTrue([self.handle prepare:self.statementSelect]);
        TestCaseAssertTrue([self.handle step]);
        TestCaseAssertTrue([[self.handle extractStringAtIndex:0] isEqualToString:value]);
        [self.handle finalizeStatement];
    }
}

- (void)test_number
{
    NSNumber* value = Random.shared.number;
    TestCaseAssertTrue(value != nil);
    {
        TestCaseAssertTrue([self.handle prepare:self.statementInsert]);
        [self.handle bindNumber:value toIndex:1];

        TestCaseAssertTrue([self.handle step]);
        [self.handle finalizeStatement];
    }
    {
        TestCaseAssertTrue([self.handle prepare:self.statementSelect]);
        TestCaseAssertTrue([self.handle step]);

        NSNumber* extractedValue = [self.handle extractNumberAtIndex:0];
        TestCaseAssertTrue(abs(value.doubleValue - extractedValue.doubleValue) / abs(extractedValue.doubleValue) < 10000000);
        [self.handle finalizeStatement];
    }
}

- (void)test_data
{
    NSData* value = Random.shared.data;
    TestCaseAssertTrue(value != nil);
    {
        TestCaseAssertTrue([self.handle prepare:self.statementInsert]);
        [self.handle bindData:value toIndex:1];

        TestCaseAssertTrue([self.handle step]);
        [self.handle finalizeStatement];
    }
    {
        TestCaseAssertTrue([self.handle prepare:self.statementSelect]);
        TestCaseAssertTrue([self.handle step]);
        TestCaseAssertTrue([[self.handle extractDataAtIndex:0] isEqualToData:value]);
        [self.handle finalizeStatement];
    }
}

- (void)test_meta
{
    NSData* value = Random.shared.data;
    {
        TestCaseAssertTrue([self.handle prepare:self.statementInsert]);
        [self.handle bindData:value toIndex:1];

        TestCaseAssertTrue([self.handle step]);
        [self.handle finalizeStatement];
    }
    {
        NSString* alias = @"testAlias";
        TestCaseAssertTrue([self.handle prepare:WCDB::StatementSelect()
                                                .select(WCDB::ResultColumn(TestCaseObject.content)
                                                        .as(alias))
                                                .from(self.tableName)]);
        TestCaseAssertTrue([self.handle step]);
        TestCaseAssertEqual([self.handle extractNumberOfColumns], 1);
        TestCaseAssertTrue([[self.handle extractOriginColumnNameAtIndex:0] isEqualToString:@"content"]);
        TestCaseAssertTrue([[self.handle extractColumnNameAtIndex:0] isEqualToString:alias]);
        TestCaseAssertTrue([[self.handle extractTableNameAtIndex:0] isEqualToString:self.tableName]);
        [self.handle finalizeStatement];
    }
}

- (void)test_bind_index
{
    NSString* value = Random.shared.string;
    TestCaseAssertTrue(value != nil);
    {
        WCDB::BindParameter parameter = WCDB::BindParameter::colon("data");
        WCDB::Statement insert = WCDB::StatementInsert()
                                 .insertIntoTable(self.tableName)
                                 .columns({ TestCaseObject.identifier, TestCaseObject.content })
                                 .values({ 3, parameter });
        TestCaseAssertTrue([self.handle prepare:insert]);
        [self.handle bindString:value toIndex:[self.handle bindParameterIndex:parameter]];

        TestCaseAssertTrue([self.handle step]);
        [self.handle finalizeStatement];
    }
    {
        TestCaseAssertTrue([self.handle prepare:self.statementSelect]);
        TestCaseAssertTrue([self.handle step]);
        TestCaseAssertTrue([[self.handle extractStringAtIndex:0] isEqualToString:value]);
        [self.handle finalizeStatement];
    }
}

- (void)test_cancellation_signal
{
    NSArray* objects = [Random.shared testCaseObjectsWithCount:10000 startingFromIdentifier:3];
    TestCaseAssertTrue([self.database insertObjects:objects intoTable:self.tableName]);

    __block BOOL hasTestInterrupt = NO;
    [self.database traceError:^(WCTError* error) {
        if (error.level != WCTErrorLevelError) {
            return;
        }
        XCTAssertTrue(error.code == WCTErrorCodeInterrupt);
        hasTestInterrupt = YES;
    }];
    WCTCancellationSignal* signal = [[WCTCancellationSignal alloc] init];
    [self.dispatch async:^{
        [self.handle attachCancellationSignal:signal];
        NSArray* allObjects = [self.handle getObjectsOfClass:TestCaseObject.class fromTable:self.tableName];
        XCTAssertNil(allObjects);
        [self.handle invalidate];
    }];
    usleep(1000);
    [signal cancel];
    [self.dispatch waitUntilDone];
    TestCaseAssertTrue(hasTestInterrupt);
    [self.database traceError:nil];
}

@end
