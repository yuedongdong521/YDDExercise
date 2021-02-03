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

static YDDAppManager *_manager;

@interface YDDAppManager ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic, readonly) UIWindow *window;

@property (nonatomic, strong) YDDLeftSideBarView *leftSideBar;
@property (nonatomic, strong) YDDTabBarController *tabBar;
@property (nonatomic, strong) UINavigationController *navigation;

@property (nonatomic, assign, readonly) CGRect tabBarFrame;
@property (nonatomic, assign, readonly) CGRect sideBarFrame;

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
        _navigation = [[UINavigationController alloc] initWithRootViewController:_tabBar];
        self.window.rootViewController = _navigation;
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
    if (_navigation) {
        _navigation = nil;
    }
}

- (void)addleftSideBar
{
    if (_leftSideBar) {
        _leftSideBar = nil;
    }
    _leftSideBar = [[YDDLeftSideBarView alloc] initWithFrame:self.sideBarFrame superView:self.navigation.view];
    weakObj(self);
    _leftSideBar.logonBlock = ^{
        strongObj(self, weakself);
        [strongself userLogon];
    };
   
    _leftSideBar.userInfo = _userInfo;
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesAction:)];
    panGes.delegate = self;
    [self.navigation.view addGestureRecognizer:panGes];
    
}

- (void)showOrHideLeftSideBar
{
    CGRect navFrame = self.tabBarFrame;
    CGRect sideFrame = self.sideBarFrame;
    if (self.leftSideBar.frame.origin.x == -kLeftSideBarWidth ||
        self.tabBar.view.frame.origin.x == 0) {
        navFrame.origin.x = kLeftSideBarWidth;
        sideFrame.origin.x = 0;
    }
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.tabBar.view.frame = navFrame;
        self.leftSideBar.frame = sideFrame;
    } completion:^(BOOL finished) {
        
    }];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (_tabBar.selectedIndex == 0 && _navigation.viewControllers.count == 1) {
        return YES;
    }
    return NO;
}


- (CGRect)tabBarFrame
{
    return CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}

- (CGRect)sideBarFrame
{
    return CGRectMake(-kLeftSideBarWidth, 0, kLeftSideBarWidth, ScreenHeight);
}

- (void)panGesAction:(UIPanGestureRecognizer *)pan
{
    CGPoint moveP = [pan translationInView:_tabBar.view];
    
    static CGRect startTabFrame, startSideFrame;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            startTabFrame = self.tabBar.view.frame;
            startSideFrame = self.leftSideBar.frame;
            break;
        case UIGestureRecognizerStateChanged: {
            
            CGRect tabFrame = startTabFrame;
            CGRect sideFrame = startSideFrame;
            tabFrame.origin.x += moveP.x;
            sideFrame.origin.x += moveP.x;
            if (tabFrame.origin.x < 0 || sideFrame.origin.x < -kLeftSideBarWidth) {
                tabFrame.origin.x = 0;
                sideFrame.origin.x = -kLeftSideBarWidth;
            } else if (tabFrame.origin.x > kLeftSideBarWidth || sideFrame.origin.x > 0) {
                tabFrame.origin.x = kLeftSideBarWidth;
                sideFrame.origin.x = 0;
            }
            self.tabBar.view.frame = tabFrame;
            self.leftSideBar.frame = sideFrame;
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled: {
            CGRect tabFrame = self.tabBar.view.frame;
            CGRect sideFrame = self.leftSideBar.frame;
            CGPoint speedP = [pan velocityInView:self.tabBar.view];
            if (speedP.x > kLeftSideBarWidth) {
                tabFrame.origin.x = kLeftSideBarWidth;
                sideFrame.origin.x = 0;
            } else {
                CGFloat halfX = kLeftSideBarWidth * 0.5;
                if (tabFrame.origin.x > halfX || sideFrame.origin.x > -halfX) {
                    tabFrame.origin.x = kLeftSideBarWidth;
                    sideFrame.origin.x = 0;
                } else {
                    tabFrame.origin.x = 0;
                    sideFrame.origin.x = -kLeftSideBarWidth;
                }
            }
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.tabBar.view.frame = tabFrame;
                self.leftSideBar.frame = sideFrame;
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
        default:
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.tabBar.view.frame = self.tabBarFrame;
                self.leftSideBar.frame = self.sideBarFrame;
            } completion:^(BOOL finished) {
                
            }];
            
            break;
    }
}


@end
