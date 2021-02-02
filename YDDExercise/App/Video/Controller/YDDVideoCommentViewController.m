//
//  YDDVideoCommentViewController.m
//  YDDExercise
//
//  Created by ydd on 2020/6/22.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoCommentViewController.h"
#import "YDDVideoCommentInputView.h"
#import "YDDVideoCommentTableViewCell.h"
#import "YDDVideoCommentModel.h"

#import "YDDVideoCommentView.h"


@interface YDDVideoCommentViewController ()<YDDVideoCommentViewDelegate>

@property (nonatomic, copy) void(^callBackCommentTotal)(NSInteger total);

@property (nonatomic, strong) YDDVideoCommentView *commentView;


@end

@implementation YDDVideoCommentViewController

+ (YDDVideoCommentViewController *)presnetWithVideoModel:(YDDVideoShowModel *)videoModel
                                                superVC:(nullable UIViewController *)superVC
                                   callBackCommentTotal:(nonnull void (^)(NSInteger total))callBackCommentTotal
{
    YDDVideoCommentViewController *commentVC = [[YDDVideoCommentViewController alloc] init];
    commentVC.videoModel = videoModel;
    commentVC.callBackCommentTotal = callBackCommentTotal;
    if (superVC) {
        [superVC presentViewController:commentVC animated:YES completion:nil];
    } else {
        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:commentVC animated:YES completion:^{
            
        }];
    }
    
    return commentVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    self.commentView.videoModel = self.videoModel;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 进入页面更新键盘状态
//    [self.inputView uploadKeyBoardStatus];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIModalPresentationStyle)modalPresentationStyle
{
    return UIModalPresentationOverCurrentContext;
}


#pragma mark - YDDVideoCommentViewDelegate
- (void)closeCommentView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)openUserInfoWithCommentModel:(YDDVideoCommentModel *)model
{
    [self pushUserInfoWithCommentModel:model];
}

- (void)pushUserInfoWithCommentModel:(YDDVideoCommentModel *)model {}

- (YDDVideoCommentView *)commentView
{
    if (!_commentView) {
        _commentView = [[YDDVideoCommentView alloc] init];
        _commentView.superVC = self;
        _commentView.delegate = self;
        @weakify(self);
        _commentView.callBackCommentTotal = ^(NSInteger total) {
            @strongify(self);
            if (self.callBackCommentTotal) {
                self.callBackCommentTotal(total);
            }
        };
    }
    return _commentView;
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
