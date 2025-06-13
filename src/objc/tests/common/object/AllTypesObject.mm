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

#import "AllTypesObject.h"
#import "AllTypesObject+WCTTableCoding.h"
#import "NSObject+TestCase.h"
#if TEST_WCDB_OBJC
#import <WCDBOBjc/WCDBObjc.h>
#elif TEST_WCDB_CPP
#import <WCDBCpp/WCDBCpp.h>
#else
#import <WCDB/WCDBObjc.h>
#endif

@implementation AllTypesObject

WCDB_IMPLEMENTATION(AllTypesObject)

WCDB_SYNTHESIZE(type)

WCDB_SYNTHESIZE(enumNSValue)
WCDB_SYNTHESIZE(optionNSValue)
WCDB_SYNTHESIZE(enumValue)
WCDB_SYNTHESIZE(enumClassValue)
WCDB_SYNTHESIZE(literalEnumValue)

WCDB_SYNTHESIZE(trueOrFalseValue)
WCDB_SYNTHESIZE(yesOrNoValue)

WCDB_SYNTHESIZE(intValue)
WCDB_SYNTHESIZE(unsignedIntValue)
WCDB_SYNTHESIZE(int32Value)
WCDB_SYNTHESIZE(int64Value)
WCDB_SYNTHESIZE(uint32Value)
WCDB_SYNTHESIZE(uint64Value)
WCDB_SYNTHESIZE(integerValue)
WCDB_SYNTHESIZE(uintegerValue)

WCDB_SYNTHESIZE(floatValue)
WCDB_SYNTHESIZE(doubleValue)
WCDB_SYNTHESIZE(numberValue)
WCDB_SYNTHESIZE(dateValue)

WCDB_SYNTHESIZE(stringValue)

WCDB_SYNTHESIZE(dataValue)
WCDB_SYNTHESIZE(codingValue)

WCDB_SYNTHESIZE(renamedGSValue)

WCDB_PRIMARY(type)

+ (AllTypesObject *)maxObject
{
    AllTypesObject *object = [[AllTypesObject alloc] init];
    object.type = @"max";

#define ASSIGN_WITH_TYPED_MAX_VALUE(property, type) \
    object.property = std::numeric_limits<type>::max()
#define ASSIGN_WITH_MAX_VALUE(property) \
    ASSIGN_WITH_TYPED_MAX_VALUE(property, decltype(object.property))

    object.enumNSValue = EnumNSTypeMax;
    object.optionNSValue = OptionNSTypeMax;
    object.enumValue = EnumType::Max;
    object.enumClassValue = EnumClassType::Max;
    object.literalEnumValue = LiteralEnum::EnumMax;

    ASSIGN_WITH_MAX_VALUE(trueOrFalseValue);
    object.yesOrNoValue = YES;

    ASSIGN_WITH_MAX_VALUE(intValue);
    ASSIGN_WITH_MAX_VALUE(unsignedIntValue);
    ASSIGN_WITH_MAX_VALUE(int32Value);
    ASSIGN_WITH_MAX_VALUE(int64Value);
    ASSIGN_WITH_MAX_VALUE(uint32Value);
    ASSIGN_WITH_MAX_VALUE(uint64Value);
    ASSIGN_WITH_MAX_VALUE(integerValue);
    ASSIGN_WITH_MAX_VALUE(uintegerValue);

    ASSIGN_WITH_MAX_VALUE(floatValue);
    ASSIGN_WITH_MAX_VALUE(doubleValue);
    object.numberValue = [NSNumber numberWithDouble:std::numeric_limits<double>::max()];
    object.dateValue = [NSDate dateWithTimeIntervalSince1970:std::numeric_limits<double>::max()];

    object.stringValue = @"";

    object.dataValue = [NSData data];
    object.codingValue = [NSURL URLWithString:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];

    ASSIGN_WITH_MAX_VALUE(renamedGSValue);

    return object;
}

+ (AllTypesObject *)minObject
{
    AllTypesObject *object = [[AllTypesObject alloc] init];
    object.type = @"min";

#define ASSIGN_WITH_TYPED_MIN_VALUE(property, type) \
    object.property = std::numeric_limits<type>::min()
#define ASSIGN_WITH_MIN_VALUE(property) ASSIGN_WITH_TYPED_MIN_VALUE(property, decltype(object.property))

    object.enumNSValue = EnumNSTypeMin;
    object.optionNSValue = OptionNSTypeMin;
    object.enumValue = EnumType::Min;
    object.enumClassValue = EnumClassType::Min;
    object.literalEnumValue = LiteralEnum::EnumMin;

    ASSIGN_WITH_MIN_VALUE(trueOrFalseValue);
    object.yesOrNoValue = NO;

    ASSIGN_WITH_MIN_VALUE(intValue);
    ASSIGN_WITH_MIN_VALUE(unsignedIntValue);
    ASSIGN_WITH_MIN_VALUE(int32Value);
    ASSIGN_WITH_MIN_VALUE(int64Value);
    ASSIGN_WITH_MIN_VALUE(uint32Value);
    ASSIGN_WITH_MIN_VALUE(uint64Value);
    ASSIGN_WITH_MIN_VALUE(integerValue);
    ASSIGN_WITH_MIN_VALUE(uintegerValue);

    ASSIGN_WITH_MIN_VALUE(floatValue);
    ASSIGN_WITH_MIN_VALUE(doubleValue);
    object.numberValue = [NSNumber numberWithDouble:std::numeric_limits<double>::min()];
    object.dateValue = [NSDate dateWithTimeIntervalSince1970:std::numeric_limits<double>::min()];

    object.stringValue = @"";

    object.dataValue = [NSData data];
    object.codingValue = [NSURL URLWithString:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];

    ASSIGN_WITH_MIN_VALUE(renamedGSValue);

    return object;
}

+ (AllTypesObject *)nilObject
{
    AllTypesObject *object = [[AllTypesObject alloc] init];
    object.type = @"nil";

    object.enumNSValue = EnumNSTypeZero;
    object.optionNSValue = OptionNSTypeZero;
    object.enumValue = EnumType::Zero;
    object.enumClassValue = EnumClassType::Zero;
    object.literalEnumValue = EnumZero;

    object.trueOrFalseValue = false;
    object.yesOrNoValue = NO;

    object.intValue = 0;
    object.unsignedIntValue = 0;
    object.int32Value = 0;
    object.int64Value = 0;
    object.uint32Value = 0;
    object.uint64Value = 0;
    object.integerValue = 0;
    object.uintegerValue = 0;

    object.floatValue = 0;
    object.doubleValue = 0;
    object.numberValue = nil;
    object.dateValue = nil;

    object.stringValue = nil;

    object.dataValue = nil;
    object.codingValue = nil;

    object.renamedGSValue = 0;

    return object;
}

+ (AllTypesObject *)emptyObject
{
    AllTypesObject *object = [[AllTypesObject alloc] init];
    object.type = @"empty";

    object.enumNSValue = EnumNSTypeZero;
    object.optionNSValue = OptionNSTypeZero;
    object.enumValue = EnumType::Zero;
    object.enumClassValue = EnumClassType::Zero;
    object.literalEnumValue = EnumZero;

    object.trueOrFalseValue = false;
    object.yesOrNoValue = NO;

    object.intValue = 0;
    object.unsignedIntValue = 0;
    object.int32Value = 0;
    object.int64Value = 0;
    object.uint32Value = 0;
    object.uint64Value = 0;
    object.integerValue = 0;
    object.uintegerValue = 0;

    object.floatValue = 0;
    object.doubleValue = 0;
    object.numberValue = @(0);
    object.dateValue = [NSDate dateWithTimeIntervalSince1970:0];

    object.stringValue = @"";

    object.dataValue = [NSData data];
    object.codingValue = [NSURL URLWithString:@""];

    object.renamedGSValue = 0;

    return object;
}

- (BOOL)isEqual:(NSObject *)object
{
    if (object.class != self.class) {
        return NO;
    }
    AllTypesObject *other = (AllTypesObject *) object;
    return self.enumNSValue == other.enumNSValue
           && self.optionNSValue == other.optionNSValue
           && self.enumValue == other.enumValue
           && self.enumClassValue == other.enumClassValue
           && self.literalEnumValue == other.literalEnumValue
           && self.trueOrFalseValue == other.trueOrFalseValue
           && self.yesOrNoValue == other.yesOrNoValue
           && self.intValue == other.intValue
           && self.unsignedIntValue == other.unsignedIntValue
           && self.int32Value == other.int32Value
           && self.int64Value == other.int64Value
           && self.uint32Value == other.uint32Value
           && self.uint64Value == other.uint64Value
           && self.integerValue == other.integerValue
           && self.uintegerValue == other.uintegerValue
           && self.floatValue == other.floatValue
           && self.doubleValue == other.doubleValue
           && [NSObject isObject:self.numberValue nilEqualToObject:other.numberValue]
           && [NSObject isObject:self.dateValue nilEqualToObject:other.dateValue]
           && [NSObject isObject:self.stringValue nilEqualToObject:other.stringValue]
           && [NSObject isObject:self.dataValue nilEqualToObject:other.dataValue]
           && [NSObject isObject:self.codingValue nilEqualToObject:other.codingValue]
           && self.renamedGSValue == other.renamedGSValue;
}

@end
