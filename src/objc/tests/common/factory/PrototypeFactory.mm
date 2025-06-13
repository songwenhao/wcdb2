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

#import "PrototypeFactory.h"
#import "TestCase.h"

@interface PrototypeFactory ()
@end

@implementation PrototypeFactory {
    WCTDatabase* _database;
    NSString* _path;
}

+ (NSData*)commonCipherKey
{
    static NSData* g_cipherKey = Random.shared.data;
    return g_cipherKey;
}

+ (void)tryCleanOldCipherDBAtDirectory:(NSString*)directory
{
    static NSMutableSet* g_cleanedOldDirectory = [[NSMutableSet alloc] init];
    @synchronized(self) {
        if (![g_cleanedOldDirectory containsObject:directory]) {
            NSFileManager* mgr = [NSFileManager defaultManager];
            NSString* cipherDirectory = [directory stringByAppendingPathComponent:@"cipherPrototype"];
            NSArray* files = [mgr getAllFilesAtDirectory:cipherDirectory];
            if (files.count > 0) {
                [mgr setFileImmutable:NO ofItemsIfExistsAtPaths:files];
                [mgr removeItemsIfExistsAtPaths:files];
            }

            [g_cleanedOldDirectory addObject:directory];
        }
    }
}

- (instancetype)initWithDirectory:(NSString*)directory
{
    if (self = [super init]) {
        _directory = directory;
    }
    return self;
}

- (void)reset
{
    _path = nil;
    _database = nil;
}

- (void)setDelegate:(id<PrototypePreparation>)delegate
{
    _delegate = delegate;
    [self reset];
}

- (void)setQuality:(double)quality
{
    _quality = quality;
    [self reset];
}

- (void)setNeedCipher:(BOOL)needCipher
{
    _needCipher = needCipher;
    [PrototypeFactory tryCleanOldCipherDBAtDirectory:self.directory];
    [self reset];
}

- (double)lowerQuality
{
    return self.quality * (1.0 - self.tolerance);
}

- (double)upperQuality
{
    return self.quality * (1.0 + self.tolerance);
}

- (NSString*)path
{
    @synchronized(self) {
        if (_path == nil) {
            NSString* fileName = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:self.quality]];
            _path = [[[self.directory stringByAppendingPathComponent:_needCipher ? @"cipherPrototype" : @"prototype"] stringByAppendingPathComponent:self.delegate.categoryOfPrototype] stringByAppendingPathComponent:fileName];
        }
        return _path;
    }
}

- (WCTDatabase*)database
{
    @synchronized(self) {
        if (_database == nil) {
            _database = [[WCTDatabase alloc] initWithPath:self.path];
            if (_needCipher) {
                [_database setCipherKey:PrototypeFactory.commonCipherKey];
            }
            [self configurePrototype];
        }
        return _database;
    }
}

- (void)removePrototype
{
    [[NSFileManager defaultManager] setFileImmutable:NO ofItemsIfExistsAtPaths:self.database.paths];
    TestCaseAssertTrue([self.database removeFiles]);
}

- (BOOL)isExpired
{
    return ![[NSFileManager defaultManager] isFileImmutableOfItemAtPath:self.path]
           || ![self isQualityTolerable:[self.delegate qualityOfPrototype:self.database]];
}

- (BOOL)isQualityTolerable:(double)quality
{
    return quality <= self.upperQuality && quality >= self.lowerQuality;
}

- (void)produce:(NSString*)destination
{
    TestCaseAssertNotNil(self.delegate);

    if ([self isExpired]) {
        TestCaseLog(@"Prototype is expired");
        //        [self removePrototype];

        [self prepare];
    }
    TestCaseLog(@"Prototype at %@", self.path);

    [self shipping:destination];
}

- (void)shipping:(NSString*)destination
{
    NSFileManager* fileManager = [NSFileManager defaultManager];

    TestCaseAssertOptionalEqual([self.database getNumberOfWalFrames], 0);
    [fileManager removeItemIfExistsAtPath:self.database.shmPath];
    [fileManager removeItemIfExistsAtPath:self.database.walPath];

    // move to temp to avoid the production is immutable while test stops unexpectly.
    NSString* tempPath = [[[fileManager temporaryDirectory] path] stringByAppendingPathComponent:@"prototype.temp"];
    [fileManager setFileImmutable:NO ofItemsIfExistsAtPath:tempPath];
    [fileManager removeItemIfExistsAtPath:tempPath];

    [fileManager copyItemsIfExistsAtPath:self.path toPath:tempPath];
    [fileManager setFileImmutable:NO ofItemsIfExistsAtPath:tempPath];

    WCTDatabase* database = [[WCTDatabase alloc] initWithPath:destination];
    TestCaseAssertTrue([database removeFiles]);
    [fileManager copyItemsIfExistsAtPath:tempPath toPath:destination];

    TestCaseLog(@"Product at %@", destination);
}

- (void)prepare
{
    double progress = 0;
    double quality = 0;

    id<PrototypePreparation> delegate = self.delegate;
    TestCaseAssertNotNil(delegate);
    quality = [delegate qualityOfPrototype:self.database];
    while (quality < self.lowerQuality) {
        @autoreleasepool {
            [delegate preparePrototype:self.database currentQuality:quality];
            quality = [delegate qualityOfPrototype:self.database];

            // progress
            double newProgress = quality / self.quality;
            if (newProgress > 1.0f) {
                newProgress = 1.0f;
            }
            if (newProgress - progress >= 0.01f) {
                progress = newProgress;
                TestCaseLog(@"Preparing %.2f%%", progress * 100.0f);
            }
        }
    }

    TestCaseAssertTrue(self.quality <= self.upperQuality);

    TestCaseAssertTrue([self.database truncateCheckpoint]);

    [[NSFileManager defaultManager] setFileImmutable:YES ofItemsIfExistsAtPath:self.path];
}

- (void)configurePrototype
{
    id<PrototypePreparation> delegate = self.delegate;
    TestCaseAssertNotNil(delegate);

    if ([delegate respondsToSelector:@selector(configurePrototype:)]) {
        [delegate configurePrototype:self.database];
    }
}

//- (void)willEndPreparing
//{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(willEndPreparing:)]) {
//        [self.delegate willEndPreparing:self.database];
//    }
//}

@end
