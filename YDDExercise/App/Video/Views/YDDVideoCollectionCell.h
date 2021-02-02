//
//  YDDVideoCollectionCell.h
//  YDDExercise
//
//  Created by ydd on 2020/6/17.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDDVideoShowModel.h"
#import "YDDCustomButton.h"
#import "YDDVideoLiveingView.h"
#import "YDDTextScrollView.h"
#import "YDDVideoLocationView.h"
#import "YDDAudioAnimationView.h"
#import "YDDVideoLoadMoreView.h"
#import "YDDVideoProgressView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^VideoControlBlock)(YDDVideoShowModel *videoModel);

typedef void(^VideoShareBlock)(YDDVideoShowModel *videoModel, UIImage *coverImage);

typedef void(^VideoUserResponesBlock)(YDDVideoShowModel *videoModel, void(^completed)(YDDVideoShowModel *videoModel, BOOL success));

@interface YDDVideoCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *bgImageView;


@property (nonatomic, strong) YDDCustomButton *supportBtn;
@property (nonatomic, strong) UIImageView *likeImageView;

@property (nonatomic, strong) YDDCustomButton *commentBtn;

@property (nonatomic, strong) YDDCustomButton *shareBtn;

@property (nonatomic, strong) YDDVideoLiveingView *liveingView;

@property (nonatomic, strong) UIButton *addFollowBtn;
@property (nonatomic, strong) UIImageView *addFollowImageView;

@property (nonatomic, strong) UIView *audioBgView;
@property (nonatomic, strong) UIView *textScrollBgView;
@property (nonatomic, strong) YDDTextScrollView *textScrollView;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *certificationImageView;

@property (nonatomic, strong) YDDVideoLocationView *locationView;

@property (nonatomic, strong) YDDAudioAnimationView *audioAnimationView;

@property (nonatomic, assign) BOOL doubleTapResponed;

@property (nonatomic, strong) YDDVideoLoadMoreView * _Nullable loadMoreView;

@property (nonatomic, strong) YDDVideoLoadMoreView *videoLoadingView;

@property (nonatomic, assign) NSInteger tapCount;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) CAGradientLayer *topLayer;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) CAGradientLayer *bottomLayer;

@property (nonatomic, strong) YDDVideoProgressView *progressView;



@property (nonatomic, strong) UIView *controlView;

@property (nonatomic, copy) VideoControlBlock commentBlock;

@property (nonatomic, copy) VideoShareBlock shareBlock;

@property (nonatomic, copy) VideoControlBlock liveBlock;

@property (nonatomic, copy) VideoUserResponesBlock supportBlock;

@property (nonatomic, copy) VideoUserResponesBlock followBlock;

@property (nonatomic, copy) VideoControlBlock playBlock;

@property (nonatomic, copy) VideoControlBlock locationBlock;

@property (nonatomic, copy) int(^updateVideoPreogressBlock)(CGFloat progress);


@property (nonatomic, strong) YDDVideoShowModel *videoModel;

- (void)viewWillAppear;

- (void)viewDidDisAppear;

- (void)startLoadMoreAnimation;

- (void)endLoadMoreAnimationDelay:(BOOL)delay completed:(void(^)(void))completed;

- (void)updateCommentTotal:(NSInteger)total;

- (void)updateUserId:(NSInteger)userId isAttention:(BOOL)isAttention;

- (void)updateLiveingStatue;

- (void)updateProgress:(CGFloat)progress duration:(CGFloat)duration;

- (void)updateShareCount;

- (void)videoLoadingAnimation:(BOOL)isLoading;


@end

NS_ASSUME_NONNULL_END
