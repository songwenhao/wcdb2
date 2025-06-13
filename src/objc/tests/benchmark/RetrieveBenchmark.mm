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

#import "SizeBasedFactory.h"
#import "TestCase.h"

@interface RetrieveBenchmark : Benchmark

@end

@implementation RetrieveBenchmark {
    SizeBasedFactory* _factory;
    NSData* _cipherKey;
}

- (SizeBasedFactory*)factory
{
    @synchronized(self) {
        if (_factory == nil) {
            _factory = [[SizeBasedFactory alloc] initWithDirectory:self.class.cacheRoot];
        }
        return _factory;
    }
}

- (NSData*)cipherKey
{
    @synchronized(self) {
        if (_cipherKey.length == 0) {
            _cipherKey = Random.shared.data;
        }
        return _cipherKey;
    }
}

- (void)setUp
{
    [super setUp];

    self.factory.needCipher = NO;
    [self.database setCipherKey:nil];
    self.factory.quality = 100 * 1024 * 1024;
    self.factory.tolerance = 0.02;
}

- (void)setUpDatabase
{
    TestCaseAssertTrue([self.database removeFiles]);
    [self.factory produce:self.path];
}

- (void)tearDownDatabase
{
    TestCaseAssertTrue([self.database removeFiles]);
}

- (void)test_backup
{
    __block BOOL result;
    [self
    doMeasure:^{
        result = [self.database backup];
    }
    setUp:^{
        [self setUpDatabase];
    }
    tearDown:^{
        [self tearDownDatabase];
        result = NO;
    }
    checkCorrectness:^{
        TestCaseAssertTrue(result);
        TestCaseAssertTrue([self.fileManager fileExistsAtPath:self.database.firstMaterialPath]);
    }];
}

- (void)test_cipher_backup
{
    __block BOOL result;
    [self.database setCipherKey:SizeBasedFactory.commonCipherKey];
    self.factory.needCipher = YES;
    [self
    doMeasure:^{
        result = [self.database backup];
    }
    setUp:^{
        [self setUpDatabase];
    }
    tearDown:^{
        [self tearDownDatabase];
        result = NO;
    }
    checkCorrectness:^{
        TestCaseAssertTrue(result);
        TestCaseAssertTrue([self.fileManager fileExistsAtPath:self.database.firstMaterialPath]);
    }];
}

- (void)test_retrieve
{
    __block double score;
    [self
    doMeasure:^{
        score = [self.database retrieve:nil];
    }
    setUp:^{
        [self setUpDatabase];
        TestCaseAssertTrue([self.database backup]);
    }
    tearDown:^{
        [self tearDownDatabase];
        score = 0.0f;
    }
    checkCorrectness:^{
        TestCaseAssertEqual(score, 1.0f);
    }];
}

- (void)test_cipher_retrieve
{
    __block double score;
    [self.database setCipherKey:SizeBasedFactory.commonCipherKey];
    self.factory.needCipher = YES;
    [self
    doMeasure:^{
        score = [self.database retrieve:nil];
    }
    setUp:^{
        [self setUpDatabase];
        TestCaseAssertTrue([self.database backup]);
    }
    tearDown:^{
        [self tearDownDatabase];
        score = 0.0f;
    }
    checkCorrectness:^{
        TestCaseAssertEqual(score, 1.0f);
    }];
}

- (void)test_retrieve_without_backup
{
    __block double score;
    [self
    doMeasure:^{
        score = [self.database retrieve:nil];
    }
    setUp:^{
        [self setUpDatabase];
    }
    tearDown:^{
        [self tearDownDatabase];
        score = 0.0f;
    }
    checkCorrectness:^{
        TestCaseAssertEqual(score, 1.0f);
    }];
}

- (void)test_ciper_retrieve_without_backup
{
    __block double score;
    [self.database setCipherKey:SizeBasedFactory.commonCipherKey];
    self.factory.needCipher = YES;
    [self
    doMeasure:^{
        score = [self.database retrieve:nil];
    }
    setUp:^{
        [self setUpDatabase];
    }
    tearDown:^{
        [self tearDownDatabase];
        score = 0.0f;
    }
    checkCorrectness:^{
        TestCaseAssertEqual(score, 1.0f);
    }];
}

@end
