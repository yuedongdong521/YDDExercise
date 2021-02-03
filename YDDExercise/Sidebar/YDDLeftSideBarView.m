//
//  YDDLeftSideBarView.m
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "YDDLeftSideBarView.h"
#import "YDDSettingViewController.h"


@interface YDDLeftSideBarView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idLabel;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, weak) UINavigationController *navigationVC;

@property (nonatomic, weak) UITabBarController *tabBar;

@property (nonatomic, assign, readonly) CGRect tabBarFrame;
@property (nonatomic, assign, readonly) CGRect sideBarFrame;


@end

@implementation YDDLeftSideBarView

- (instancetype)initWithNavigationVC:(UINavigationController *)navigationVC;
{
    self = [super init];
    if (self) {
        self.navigationVC = navigationVC;
        
        if ([self.navigationVC.viewControllers.firstObject isKindOfClass:[UITabBarController class]]) {
            self.tabBar = (UITabBarController *)self.navigationVC.viewControllers.firstObject;
        }
        
        self.frame = self.sideBarFrame;
        self.backgroundColor = [UIColor grayColor];
        
        [self.navigationVC.view addSubview:self.bgView];
        [self.navigationVC.view addSubview:self];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, kLeftSideBarWidth, 0, 0));
        }];
        
        [self createUI];
        
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesAction:)];
        panGes.delegate = self;
        [self.navigationVC.view addGestureRecognizer:panGes];
    }
    return self;
}


- (void)hiddenSideBar:(BOOL)hidden animation:(BOOL)animation
{
    CGRect tabFrame = self.tabBarFrame;
    CGRect sideFrame = self.sideBarFrame;
    
    if (!hidden) {
        tabFrame.origin.x = kLeftSideBarWidth;
        sideFrame.origin.x = 0;
    }
    
    if (!animation) {
        self.tabBar.view.frame = tabFrame;
        self.frame = sideFrame;
        return;
    }
    
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tabBar.view.frame = tabFrame;
        self.frame = sideFrame;
    } completion:^(BOOL finished) {
        if (!finished) {
            self.tabBar.view.frame = tabFrame;
            self.frame = sideFrame;
        }
    }];
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.tabBar.selectedIndex == 0 && self.navigationVC.viewControllers.count == 1) {
        return YES;
    }
    return NO;
}

- (void)quitAction
{
    if (_logonBlock) {
        _logonBlock();
    }
}

- (void)settingAction
{
    [self hiddenSideBar:YES animation:NO];
    YDDSettingViewController *vc = [[YDDSettingViewController alloc] init];
    
    
    UIViewController *curVC = [self ydd_curTopViewController];
    if ([curVC isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController*)curVC) pushViewController:vc animated:YES];
    } else if (curVC.navigationController) {
        [curVC.navigationController pushViewController:vc animated:YES];
    }
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
    CGPoint moveP = [pan translationInView:self.navigationVC.view];
    
    // 获取到本次滑动距离后重置当前位置
    [pan setTranslation:CGPointZero inView:self.navigationVC.view];

    NSLog(@"moveP : %@", NSStringFromCGPoint(moveP));
    
    CGRect tabFrame = self.tabBar.view.frame;
    CGRect sideFrame = self.frame;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged: {
            
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
            self.frame = sideFrame;
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled: {
            CGRect tabFrame = self.tabBar.view.frame;
            CGRect sideFrame = self.frame;
            CGPoint speedP = [pan velocityInView:self.tabBar.view];
            if (speedP.x > kLeftSideBarWidth) {
                tabFrame.origin.x = kLeftSideBarWidth;
                sideFrame.origin.x = 0;
            } else if (speedP.x < -kLeftSideBarWidth) {
                tabFrame.origin.x = 0;
                sideFrame.origin.x = -kLeftSideBarWidth;
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
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.tabBar.view.frame = tabFrame;
                self.frame = sideFrame;
            } completion:^(BOOL finished) {
                if (!finished) {
                    self.tabBar.view.frame = tabFrame;
                    self.frame = sideFrame;
                }
            }];
        }
            break;
        default:
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.tabBar.view.frame = self.tabBarFrame;
                self.frame = self.sideBarFrame;
            } completion:^(BOOL finished) {
                if (!finished) {
                    self.tabBar.view.frame = self.tabBarFrame;
                    self.frame = self.sideBarFrame;
                }
            }];
            
            break;
    }
}



- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (frame.origin.x == -kLeftSideBarWidth) {
        self.bgView.hidden = YES;
    } else if (frame.origin.x == 0) {
        self.bgView.hidden = NO;
    }
}

- (void)setUserInfo:(YDDUserBaseInfoModel *)userInfo
{
    [self.headImageView yy_setImageWithURL:[userInfo.userIcon ydd_coverUrl] placeholder:kHeadIconDefault];
    
    self.nameLabel.text = [NSString stringWithFormat:@"昵称:%@", userInfo.userName];
    self.idLabel.text = [NSString stringWithFormat:@"id:%@", @(userInfo.userId)];
}

- (void)createUI
{
    [self addSubview:self.headImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.idLabel];
    
    UIButton *quitBtn = [UIButton ydd_buttonType:UIButtonTypeCustom title:@"退出登录" backgroundColor:[UIColor redColor] target:self action:@selector(quitAction)];
    [self addSubview:quitBtn];
    
    UIButton *settingBtn = [UIButton ydd_buttonType:UIButtonTypeCustom title:@"设置" backgroundColor:[UIColor redColor] target:self action:@selector(settingAction)];
    [self addSubview:settingBtn];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(100);
        make.width.height.mas_equalTo(80);
    }];
    [self.headImageView cutRadius:40 borderWidth:1 borderColor:[UIColor whiteColor]];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_left);
        make.top.mas_equalTo(self.headImageView.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.mas_right).mas_offset(-15);
    }];
    
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.mas_right).mas_offset(-15);
    }];
    
    [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.idLabel.mas_left);
        make.top.mas_equalTo(self.idLabel.mas_bottom).mas_offset(30);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
    [quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 50));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(-50 - (kSafeBottom));
    }];
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
    }
    return _headImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel ydd_labelAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:16] text:nil];
    }
    return _nameLabel;
}

- (UILabel *)idLabel
{
    if (!_idLabel) {
        _idLabel = [UILabel ydd_labelAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:16] text:nil];
    }
    return _idLabel;
}


- (void)dealloc
{
    NSLog(@"dealloc : %@", NSStringFromClass(self.class));
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

