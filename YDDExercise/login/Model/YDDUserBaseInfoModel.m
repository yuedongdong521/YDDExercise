//
//  YDDUserBaseInfoModel.m
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "YDDUserBaseInfoModel.h"
#import "NSObject+YDDExtend.h"

@implementation YDDUserBaseInfoModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userName = @"";
        _userIcon = @"";
        _password = @"";
        _loginDate = [NSDate date];
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    YDDUserBaseInfoModel *model = [[self class] allocWithZone:zone];
    [[self class] ydd_GoThroughAllProperty:model propertyBlock:^(NSString * _Nonnull propertyName) {
        id value = [self valueForKey:propertyName];
        if (value != nil) {
            [model setValue:value forKey:propertyName];
        }
    }];
    return model;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
    [[self class] ydd_GoThroughAllProperty:self propertyBlock:^(NSString * _Nonnull propertyName) {
        id value = [self valueForKey:propertyName];
        if (value != nil) {
            [aCoder encodeObject:value forKey:propertyName];
        }
    }];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [[self class] ydd_GoThroughAllProperty:self propertyBlock:^(NSString * _Nonnull propertyName) {
            id value = [aDecoder decodeObjectForKey:propertyName];
            if (value != nil) {
                [self setValue:value forKey:propertyName];
            }
        }];
    }
    return self;
}

@end
