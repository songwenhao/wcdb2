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

#import <Foundation/Foundation.h>
#import <string>

typedef NS_ENUM(NSInteger, EnumNSType) {
    EnumNSTypeMin = std::numeric_limits<NSInteger>::min(),
    EnumNSTypeZero = 0,
    EnumNSTypeMax = std::numeric_limits<NSInteger>::max(),
};

typedef NS_OPTIONS(NSInteger, OptionNSType) {
    OptionNSTypeMin = std::numeric_limits<NSInteger>::min(),
    OptionNSTypeZero = 0,
    OptionNSTypeMax = std::numeric_limits<NSInteger>::max(),
};

enum EnumType {
    Min = std::numeric_limits<int>::min(),
    Zero = 0,
    Max = std::numeric_limits<int>::max(),
};

enum class EnumClassType {
    Min = std::numeric_limits<int>::min(),
    Zero = 0,
    Max = std::numeric_limits<int>::max(),
};

typedef enum {
    EnumMin = std::numeric_limits<int>::min(),
    EnumZero = 0,
    EnumMax = std::numeric_limits<int>::max(),
} LiteralEnum;

@interface AllTypesObject : NSObject

@property (nonatomic, assign) NSString* type;

// Enum
@property (nonatomic, assign) EnumNSType enumNSValue;
@property (nonatomic, assign) OptionNSType optionNSValue;
@property (nonatomic, assign) EnumType enumValue;
@property (nonatomic, assign) EnumClassType enumClassValue;
@property (nonatomic, assign) LiteralEnum literalEnumValue;

// Bool
@property (nonatomic, assign) bool trueOrFalseValue;
@property (nonatomic, assign) BOOL yesOrNoValue;

// Integer
@property (nonatomic, assign) int intValue;
@property (nonatomic, assign) unsigned int unsignedIntValue;
@property (nonatomic, assign) int32_t int32Value;
@property (nonatomic, assign) int64_t int64Value;
@property (nonatomic, assign) uint32_t uint32Value;
@property (nonatomic, assign) uint64_t uint64Value;
@property (nonatomic, assign) NSInteger integerValue;
@property (nonatomic, assign) NSUInteger uintegerValue;

// Float
@property (nonatomic, assign) float floatValue;
@property (nonatomic, assign) double doubleValue;
@property (nonatomic, retain) NSNumber* numberValue;
@property (nonatomic, retain) NSDate* dateValue;

// String
@property (nonatomic, retain) NSString* stringValue;

// BLOB
@property (nonatomic, retain) NSData* dataValue;
@property (nonatomic, retain) NSURL* codingValue; // all other class based NSCoding

// getter && setter
@property (nonatomic, assign, getter=renamedGet, setter=renamedSet:) int renamedGSValue;

+ (AllTypesObject*)maxObject;
+ (AllTypesObject*)minObject;
+ (AllTypesObject*)nilObject;
+ (AllTypesObject*)emptyObject;

@end
