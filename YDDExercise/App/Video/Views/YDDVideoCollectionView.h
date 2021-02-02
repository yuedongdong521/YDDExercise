//
//  YDDVideoCollectionView.h
//  YDDExercise
//
//  Created by ydd on 2020/6/17.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDDHomeVideoCollectionCell.h"

#import "YDDVideoShowModel.h"

typedef enum : NSUInteger {
    YDDVideoCollectionViewType_follow = 0,
    YDDVideoCollectionViewType_recommend = 1,
    YDDVideoCollectionViewType_player = 2,
} YDDVideoCollectionViewType;


@class YDDVideoCollectionView;


NS_ASSUME_NONNULL_BEGIN

@protocol YDDVideoCollectionViewDelegate <NSObject>

- (void)videoCollectionView:(YDDVideoCollectionView *)view
       didEndDisplayingCell:(YDDVideoCollectionCell*)cell
                      index:(NSIndexPath *)index;

- (void)videoCollectionView:(YDDVideoCollectionView *)view
              scrollEndCell:(YDDVideoCollectionCell*)cell
                      index:(NSIndexPath *)index;

@end

@interface YDDVideoCollectionView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, weak) id<YDDVideoCollectionViewDelegate> delegate;
/// 品论
@property (nonatomic, copy) VideoControlBlock commentBlock;
/// 分享
@property (nonatomic, copy) VideoShareBlock shareBlock;
/// 直播、个人中心
@property (nonatomic, copy) VideoControlBlock liveBlock;
/// 点赞
@property (nonatomic, copy) VideoUserResponesBlock supportBlock;
/// 关注
@property (nonatomic, copy) VideoUserResponesBlock followBlock;
/// 关注的主播正在直播数
@property (nonatomic, copy) void(^showFollowItem)(BOOL hidden);
/// 下拉刷新
@property (nonatomic, copy) void(^pullRefreshOffsetY)(CGFloat offsetY, BOOL isBegan, BOOL isRefresh);
/// 播放、暂停
@property (nonatomic, copy) VideoControlBlock playBlock;
/// 位置
@property (nonatomic, copy) VideoControlBlock locationBlock;

/// 是否响应，处理下拉刷新冲突
@property (nonatomic, assign) BOOL respendEnable;
/// 是否显示除视频之外的控件
@property (nonatomic, assign) BOOL showControllView;
/// 关注模块的y偏移量
@property (nonatomic, assign) CGFloat collectionViewY;
/// 是否有更多数据
@property (nonatomic, assign) BOOL hasLoadMore;

@property (nonatomic, assign) BOOL loadMoreing;

@property (nonatomic, copy) void(^loadMoreBlock)(void(^completed)(void));

@property (nonatomic, assign, readonly) NSInteger videoListCount;
@property (nonatomic, strong, readonly) YDDVideoShowModel *lastVideoModel;

- (instancetype)initWithType:(YDDVideoCollectionViewType)viewType;

- (void)updateVideoList:(nullable NSArray<YDDVideoShowModel *> *)videoList scorllTop:(BOOL)scrollTop;

- (void)addVideoList:(nullable NSArray<YDDVideoShowModel *> *)videoList;


- (void)updateVideoList:(nullable NSArray<YDDVideoShowModel *> *)videoList index:(NSInteger)index;

- (void)viewWillDisAppear;
- (void)fristScrollViewLoad;

- (void)moveCollectionView:(BOOL)isOrigin
                 animation:(BOOL)animation
                 completed:(void(^)(void))completed;


- (void)scrollOffsetY:(CGFloat)offsetY end:(BOOL)isEnd changed:(BOOL)changed;

- (void)updateCommentTotal:(NSInteger)total;

- (void)updateUserId:(NSInteger)userId isAttention:(BOOL)isAttention;

- (void)videoLoading:(BOOL)isLoading;

- (void)followVCUpdateUserId:(NSInteger)userId attentionType:(NSInteger)type;

- (void)updateLiveingStatueWithAnchorId:(NSInteger)anchorId liveing:(BOOL)isLiveing;

- (void)updateProgress:(CGFloat)progress duration:(CGFloat)duration;

- (void)updateShareCountWithModel:(YDDVideoShowModel *)model;

@end

NS_ASSUME_NONNULL_END
