//
//  YDDAppManager.h
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDDUserBaseInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

#define kAppManager [YDDAppManager shareManager]

#define kUserLastLoginInfo @"UserLastLoginInfo"

typedef enum : NSUInteger {
    AppState_logout = 0,
    AppState_login,
} AppState;

@interface YDDAppManager : NSObject

@property (nonatomic, strong) YDDUserBaseInfoModel *userInfo;

+ (instancetype)shareManager;
+ (void)checkLoginState;
- (void)loginStateDidChanage:(AppState)state;

+ (YDDUserBaseInfoModel *)keychainAccountInfo;

+ (void)updateKeychainAccountInfo:(YDDUserBaseInfoModel *)info;

@end

NS_ASSUME_NONNULL_END
