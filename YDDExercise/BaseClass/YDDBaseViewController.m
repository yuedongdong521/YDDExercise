//
//  YDDBaseViewController.m
//  YDDExercise
//
//  Created by ydd on 2019/7/20.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "YDDBaseViewController.h"
#import "UINavigationController+StatuBar.h"

@interface YDDBaseViewController ()

@end

@implementation YDDBaseViewController

- (BOOL)prefersStatusBarHidden
{
    return _hiddenStatuBar;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return _statuBarStyle;
}

- (UIStatusBarStyle)statuBarStyle
{
    if (!_statuBarStyle) {
        return [UIApplication sharedApplication].statusBarStyle;
    }
    return _statuBarStyle;
}

- (void)setHiddenStatuBar:(BOOL)hiddenStatuBar
{
    if (_hiddenStatuBar != hiddenStatuBar) {
        _hiddenStatuBar = hiddenStatuBar;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setHiddenNavBarLeftBtn:(BOOL)hiddenNavBarLeftBtn
{
    _hiddenNavBarLeftBtn = hiddenNavBarLeftBtn;
    if (!_hiddenNavBarLeftBtn) {
        weakObj(self);
        _navBarView.leftBlock = ^{
            strongObj(self, weakself);
            [strongself leftAction];
        };
    }
}

- (void)setHiddenNavBarRightBtn:(BOOL)hiddenNavBarRightBtn
{
    _hiddenNavBarRightBtn = hiddenNavBarRightBtn;
    if (!_hiddenNavBarRightBtn) {
        weakObj(self);
        _navBarView.rightBlock = ^{
            strongObj(self, weakself);
            [strongself rightAction];
        };
    }
}

- (YDDNavigationBarView *)navBarView
{
    if (!_navBarView) {
        _navBarView = [[YDDNavigationBarView alloc] init];
        [self.view addSubview:_navBarView];
        [_navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(kNavBarHeight);
        }];
    }
    return _navBarView;
}

- (void)leftAction
{
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction
{
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
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
