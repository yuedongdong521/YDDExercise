//
//  YDDLoginViewController.m
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "YDDLoginViewController.h"
#import "YDDLogView.h"
#import "YDDLogonViewController.h"
#import "NSObject+YDDExtend.h"

@interface YDDLoginViewController ()

@property (nonatomic, strong) YDDLogView *loginView;

@end

@implementation YDDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.loginView];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    self.loginView.infoModel = kAppManager.userInfo;
}

- (YDDLogView *)loginView
{
    if (!_loginView) {
        _loginView = [[YDDLogView alloc] initWithViewType:LogViewType_Login];
        weakObj(self);
        _loginView.loginBlock = ^(YDDUserBaseInfoModel * _Nonnull userInfo) {
            strongObj(self, weakself);
            [strongself login:userInfo];
        };
        _loginView.logonBlock = ^{
            strongObj(self, weakself);
            [strongself pushLogonViewController];
        };
    }
    return _loginView;
}

- (void)login:(YDDUserBaseInfoModel *)userInfo
{
    YDDUserBaseInfoModel *serverInfo = (YDDUserBaseInfoModel*)[NSObject ydd_readModelForKey:kUserInfoWriteKey(userInfo.userId)];
    if ([serverInfo.password isEqualToString:userInfo.password]) {
        kAppManager.userInfo = serverInfo;
        [kAppManager loginStateDidChanage:AppState_login];
        [serverInfo ydd_writeModelForKey:kUserLastLoginInfo];
    }
    
}
- (void)pushLogonViewController
{
    YDDLogonViewController *logonView = [[YDDLogonViewController alloc] init];
    [self.navigationController pushViewController:logonView animated:YES];
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
