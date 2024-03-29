//
//  YDDAppManager.m
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "YDDAppManager.h"
#import "YDDLoginViewController.h"
#import "YDDTabBarController.h"
#import "YDDLeftSideBarView.h"
#import "NSObject+YDDExtend.h"
#import "KeychainItemWrapper.h"

static YDDAppManager *_manager;

@interface YDDAppManager ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic, readonly) UIWindow *window;

@property (nonatomic, strong) YDDLeftSideBarView *leftSideBar;
@property (nonatomic, strong) YDDTabBarController *tabBar;
//@property (nonatomic, strong) UINavigationController *navigation;


@end

@implementation YDDAppManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[YDDAppManager alloc] init];
    });
    return _manager;
}

- (UIWindow *)window
{
    return  [[UIApplication sharedApplication] delegate].window;
}

+ (void)checkLoginState
{
    NSLog(@"开始启动");
    YDDAppManager *manager = [YDDAppManager shareManager];
    manager.userInfo = [YDDUserBaseInfoModel ydd_readModelForKey:kUserLastLoginInfo];
    if (manager.userInfo && _manager.userInfo.password.length > 0) {
        NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:manager.userInfo.loginDate];
        if (time < 7 * 24 * 3600) {
            [manager loginStateDidChanage:AppState_login];
            NSLog(@"已登录");
            return;
        }
    }
    [manager loginStateDidChanage:AppState_logout];
    NSLog(@"重新登录");
}

- (void)loginStateDidChanage:(AppState)state
{
    [self destoryWindow];
    if (state == AppState_login) {
        _tabBar = [[YDDTabBarController alloc] init];
//        _navigation = [[UINavigationController alloc] initWithRootViewController:_tabBar];
        self.window.rootViewController = _tabBar;
        [self addleftSideBar];
        
    } else {
        YDDLoginViewController *logInVC = [[YDDLoginViewController alloc] init];
        UINavigationController *navig = [[UINavigationController alloc] initWithRootViewController:logInVC];
        self.window.rootViewController = navig;
    }
}

- (void)userLogon
{
    self.userInfo.password = @"";
    [self.userInfo ydd_writeModelForKey:kUserLastLoginInfo];
    [self loginStateDidChanage:AppState_logout];
}

- (void)destoryWindow
{
    if (_tabBar) {
        _tabBar = nil;
    }
//    if (_navigation) {
//        _navigation = nil;
//    }
}

- (void)addleftSideBar
{
    if (_leftSideBar) {
        _leftSideBar = nil;
    }
    
    _leftSideBar = [[YDDLeftSideBarView alloc] initWithTabBarVC:self.tabBar];
    weakObj(self);
    _leftSideBar.logonBlock = ^{
        strongObj(self, weakself);
        [strongself userLogon];
    };
    _leftSideBar.userInfo = _userInfo;
}


+ (YDDUserBaseInfoModel *)keychainAccountInfo
{
    /// KeychainItemWrapper 读取钥匙链存储信息
    KeychainItemWrapper *app = [[KeychainItemWrapper alloc] initWithIdentifier:@"YDDExerciseKey" accessGroup:nil];
    
    NSNumber *account = [app objectForKey:(id)kSecAttrAccount];
    NSString *password = [app objectForKey:(id)kSecValueData];

    NSLog(@"account : %@, password : %@", account, password);
    
    if (account.integerValue > 0 && password.length > 0) {
        YDDUserBaseInfoModel *infoModel = [[YDDUserBaseInfoModel alloc] init];
        infoModel.userId = [account integerValue];
        infoModel.password = password;
        return infoModel;
    }
    return nil;
}

+ (void)updateKeychainAccountInfo:(YDDUserBaseInfoModel *)info
{
    if (info.password.length == 0 || info.userId == 0) {
        return;
    }
    /// KeychainItemWrapper 钥匙链存储信息
    KeychainItemWrapper *app = [[KeychainItemWrapper alloc] initWithIdentifier:@"YDDExerciseKey" accessGroup:nil];
    [app setObject:@(info.userId) forKey:(id)kSecAttrAccount];
    [app setObject:info.password forKey:(id)kSecValueData];
    /// 清空钥匙链
//        [app resetKeychainItem];
    
}


@end
