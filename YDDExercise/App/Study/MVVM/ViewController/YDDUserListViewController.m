//
//  YDDUserListViewController.m
//  YDDExercise
//
//  Created by ydd on 2021/2/24.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDUserListViewController.h"
#import "YDDUserInfoViewModel.h"
#import "YDDUserListView.h"

@interface YDDUserListViewController ()

@property (nonatomic, strong) YDDUserInfoViewModel *viewModel;

@property (nonatomic, strong) YDDUserListView *userListView;

@end

@implementation YDDUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self bindingViewModel];
    
    [self.view addSubview:self.userListView];
}

- (void)updateViewConstraints
{
    [self.userListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0));
    }];
    [super updateViewConstraints];
}


- (void)bindingViewModel
{
    @weakify(self);
    /// self.rac_willDeallocSignal 当self 被释放是触发信号，
    /// takeUntil：当rac_willDeallocSignal被调用时didClickedSubject终止订阅，不再接受信号，
    /// 所以这里的意思是self释放时终止订阅信号
    [[self.viewModel.didClickedSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSLog(@"did selected");
    }];
}


- (YDDUserInfoViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[YDDUserInfoViewModel alloc] init];
    }
    return _viewModel;
}

- (YDDUserListView *)userListView
{
    if (!_userListView) {
        _userListView = [[YDDUserListView alloc] initWithModel:self.viewModel];
    }
    return _userListView;
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
