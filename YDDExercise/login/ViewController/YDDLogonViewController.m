//
//  YDDLogonViewController.m
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "YDDLogonViewController.h"
#import "YDDLogView.h"
#import "NSObject+YDDExtend.h"


@interface YDDLogonViewController ()

@property (nonatomic, strong) YDDLogView *logonView;

@end

@implementation YDDLogonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.logonView];
    [self.logonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    self.navBarView.title = @"注册";
    self.hiddenNavBarLeftBtn = NO;
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (YDDLogView *)logonView
{
    if (!_logonView) {
        _logonView = [[YDDLogView alloc] initWithViewType:LogViewType_Logon];
        
        weakObj(self);
        _logonView.loginBlock = ^(YDDUserBaseInfoModel * _Nonnull userInfo) {
            strongObj(self, weakself);
            [strongself logon:userInfo];
        };
    }
    return _logonView;
}

- (void)logon:(YDDUserBaseInfoModel *)userInfo
{
    
    [userInfo ydd_writeModelForKey:kUserInfoWriteKey(userInfo.userId)];
    [[UIApplication sharedApplication].keyWindow hud_showTips:@"注册完成"];
    [self leftAction];
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
