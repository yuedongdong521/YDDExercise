//
//  YDDVideoRecommendViewController.h
//  YDDExercise
//
//  Created by ydd on 2020/6/17.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDBaseViewController.h"
@class YDDVideoShowModel;
NS_ASSUME_NONNULL_BEGIN

@interface YDDVideoRecommendViewController : YDDBaseViewController

@property (nonatomic, copy) void(^shareBlock)(YDDVideoShowModel *model, UIImage *coverImage);

@property (nonatomic, copy) void(^pullRefreshOffsetY)(CGFloat offsetY, BOOL isBegan, BOOL isRefresh);

@property (nonatomic, copy) void(^followBlock)(YDDVideoShowModel *model, void(^completed)(YDDVideoShowModel *model, BOOL success));

@property (nonatomic, copy) void(^likeBlock)(YDDVideoShowModel *model, void(^completed)(YDDVideoShowModel *model, BOOL success));

@property (nonatomic, copy) void(^liveBlock)(YDDVideoShowModel *model);

- (void)updateUserId:(NSInteger)userId isAttention:(BOOL)isAttention;

- (void)updateOpenLiveingStatueWithAnchorId:(NSInteger)anchorId;

- (void)loadNewDataCompleted:(nullable void(^)(void))completed;

- (void)downloadVideo;

- (void)updateShareCountWithModel:(YDDVideoShowModel *)model;

@end

NS_ASSUME_NONNULL_END
