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
