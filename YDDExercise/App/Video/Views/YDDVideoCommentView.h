//
//  YDDVideoCommentView.h
//  YDDExercise
//
//  Created by ydd on 2020/8/6.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDDVideoShowModel.h"
#import "YDDVideoCommentModel.h"

@class YDDVideoCommentView;
NS_ASSUME_NONNULL_BEGIN

@protocol YDDVideoCommentViewDelegate <NSObject>

- (void)closeCommentView;

- (void)openUserInfoWithCommentModel:(YDDVideoCommentModel *)model;

@end

@interface YDDVideoCommentView : UIView

@property (nonatomic, strong) YDDVideoShowModel *videoModel;

@property (nonatomic, copy) void(^callBackCommentTotal)(NSInteger total);

@property (nonatomic, copy) void(^attentionCallBack)(NSInteger userId, BOOL isAttention);

@property (nonatomic, copy) void(^changePlayerStatue)(BOOL isPause);

@property (nonatomic, weak) id<YDDVideoCommentViewDelegate> delegate;

@property (nonatomic, weak) UIViewController *superVC;

+ (YDDVideoCommentView *)presnetWithVideoModel:(YDDVideoShowModel *)videoModel
                                      superVC:(nonnull UIViewController *)superVC
                         callBackCommentTotal:(nonnull void (^)(NSInteger total))callBackCommentTotal;


@end

NS_ASSUME_NONNULL_END
