//
//  YDDKeychainTool.m
//  YDDExercise
//
//  Created by ydd on 2021/5/10.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDKeychainTool.h"
#import "KeychainItemWrapper.h"

@interface YDDKeychainTool ()

@property (nonatomic, strong) KeychainItemWrapper *wrapper;

@end

static YDDKeychainTool *_keychain;

@implementation YDDKeychainTool


+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _keychain = [[YDDKeychainTool alloc] init];
    });
    return _keychain;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"YDDExerciseKey" accessGroup:nil];
    }
    return self;
}

- (void)setObject:(id)object forKey:(CFStringRef)key
{
    if (object && key) {
        [_wrapper setObject:object forKey:(__bridge id)key];
    }
}

- (id)objectForKey:(CFStringRef)key
{
    if (key) {
        return [_wrapper objectForKey:(__bridge id)key];
    }
    return nil;
}

@end
