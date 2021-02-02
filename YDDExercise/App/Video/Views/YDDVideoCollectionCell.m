//
//  YDDVideoCollectionCell.m
//  YDDExercise
//
//  Created by ydd on 2020/6/17.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoCollectionCell.h"

@interface YDDVideoCollectionCell ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *cellBgView;

@end

@implementation YDDVideoCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.cellBgView];
        [self.cellBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        [self addSubview:self.bgImageView];
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        [self addSubview:self.topView];
        [self.topView.layer addSublayer:self.topLayer];
        [self addSubview:self.bottomView];
        [self.bottomView.layer addSublayer:self.bottomLayer];
        
        [self addSubview:self.controlView];
        [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, kSafeBottom, 0));
        }];
        
        [self.controlView addSubview:self.supportBtn];
        [self.supportBtn addSubview:self.likeImageView];
        
        [self.controlView addSubview:self.commentBtn];
        [self.controlView addSubview:self.shareBtn];
        [self.controlView addSubview:self.liveingView];
        [self.controlView addSubview:self.addFollowBtn];
        [self.addFollowBtn addSubview:self.addFollowImageView];
        
        [self.controlView addSubview:self.audioBgView];
        
        [self.controlView addSubview:self.contentLabel];
        [self.controlView addSubview:self.nameLabel];
        
        
        [self.controlView addSubview:self.locationView];
        
        [self.controlView addSubview:self.audioAnimationView];
        
        [self.controlView addSubview:self.videoLoadingView];
        
//        [self.controlView addSubview:self.progressView];
        
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-85);
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(58);
        }];
        
        [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.shareBtn);
            make.bottom.mas_equalTo(self.shareBtn.mas_top).mas_offset(-16);
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(58);
        }];
        
        [self.supportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.shareBtn);
            make.bottom.mas_equalTo(self.commentBtn.mas_top).mas_offset(-16);
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(58);
        }];
        
        [self.likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.supportBtn.imageView);
            make.size.mas_equalTo(60);
        }];
        
        [self.liveingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.supportBtn.mas_centerX);
            make.width.mas_equalTo(48);
            make.height.mas_equalTo(48);
            make.bottom.mas_equalTo(self.supportBtn.mas_top).mas_offset(-27);
        }];
        
        [self.addFollowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(30);
            make.centerX.mas_equalTo(self.liveingView.mas_centerX);
            make.bottom.mas_equalTo(self.liveingView.mas_bottom).mas_offset(12);
        }];
        
        [self.addFollowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.addFollowBtn);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.audioBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.bottom.mas_equalTo(-16);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(kWidthIPHONE6(153) + 14);
        }];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-107);
            make.bottom.mas_equalTo(self.audioBgView.mas_top).mas_offset(-6);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.bottom.mas_equalTo(self.contentLabel.mas_top).mas_offset(-2);
            make.height.mas_equalTo(25);
        }];
        
//        [self.controlView addSubview:self.certificationImageView];
//        [self.certificationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.nameLabel.mas_right).mas_offset(5);
//            make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
//            make.size.mas_equalTo(CGSizeMake(38, 15));
//        }];
        
        [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.bottom.mas_equalTo(self.nameLabel.mas_top).mas_offset(-2);
            make.height.mas_equalTo(21);
            make.right.mas_equalTo(-100);
        }];
        
        [self.videoLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(kNavBarHeight + 4);
        }];
        
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.locationView.mas_top);
        }];
        
//        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.mas_equalTo(0);
//            make.height.mas_equalTo(KVideoProgressH);
//        }];
//
        [self createTextScroll];
        
        [self addGesture];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.topLayer.frame = self.topView.bounds;
    self.bottomLayer.frame = self.bottomView.bounds;
}

- (void)addGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.controlView addGestureRecognizer:tap];
    
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.delegate = self;
    
    [self.controlView addGestureRecognizer:doubleTap];
    [tap requireGestureRecognizerToFail:doubleTap];
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.controlView];
    __block BOOL respends = YES;
    [self.controlView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(CGRectInset(obj.frame, -10, -10), p)) {
            respends = NO;
            *stop = YES;
        }
    }];
    return respends;
}


- (void)setVideoModel:(YDDVideoShowModel *)videoModel
{
    _videoModel = videoModel;
    [self updateBgViewMode];
    self.contentLabel.text = videoModel.text;
    
    if (!videoModel.nickName) {
        self.nameLabel.text = @"@ ";
    }else{
        self.nameLabel.text = [NSString stringWithFormat:@"@%@", videoModel.nickName];
    }
    if (videoModel.videoMusicName.length > 0) {
        [self.textScrollView updataContent:[NSString stringWithFormat:@"@%@", videoModel.videoMusicName]];
        self.audioBgView.hidden = NO;
        [self.audioBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
        }];
    } else {
        [self.textScrollView updataContent:@""];
        self.audioBgView.hidden = YES;
        [self.audioBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    [self.liveingView.headImageView yy_setImageWithURL:[NSURL URLWithString:videoModel.avatarUrl] placeholder:[UIImage imageNamed:@"headIcon"]];
   
    self.liveingView.isLiveing = videoModel.isPlaying == 1;
    
    [self updateFollowStatue];
    [self updateLikeStatue];
    
    [self updateShareCount];
    [self updateCommentTotal:videoModel.commentsTotal];
    [self setupLikeTotal];
    
    
    [self.locationView updateLocation:self.videoModel.address distance:self.videoModel.distance];
    
    [self.audioAnimationView.audioImageView yy_setImageWithURL:[NSURL URLWithString:videoModel.avatarUrl] placeholder:[UIImage imageNamed:@"headIcon"]];
    
    [self endLoadMoreAnimation];
//    [_progressView updateProgress:0 duration:0];
    
}

#pragma mark 更新画布填充方式
- (void)updateBgViewMode
{
    if (self.videoModel.video.high > self.videoModel.video.wide) {
        self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    } else {
         self.bgImageView.contentMode =  UIViewContentModeScaleAspectFit;
    }
    [self.bgImageView yy_setImageWithURL:[NSURL URLWithString:self.videoModel.video.videoCoverUrl] placeholder:nil];
}

#pragma mark 更新关注状态
- (void)updateFollowStatue
{
    if (!self.addFollowBtn.enabled) {
        return;
    }
    if ([self.videoModel.relationship isEqualToString:YDDAttention_unknown] ||
        [self.videoModel.relationship isEqualToString:YDDAttention_unAttention]) {
        self.addFollowBtn.hidden = NO;
        self.addFollowImageView.hidden = NO;
        self.addFollowImageView.image = [UIImage imageNamed:@"add_attention_0"];
        self.addFollowBtn.enabled = YES;
    } else {
        self.addFollowBtn.hidden = YES;
        self.addFollowImageView.hidden = YES;
    }
}
#pragma mark 更新直播状态
- (void)updateLiveingStatue
{
    if (self.videoModel.isPlaying == 1) {
        self.liveingView.isLiveing = YES;
        [self.liveingView startAnimation];
    } else {
        self.liveingView.isLiveing = NO;
        [self.liveingView removeAnimation];
    }
}

- (void)viewWillAppear
{
    [_textScrollView startTimer];
    [_audioAnimationView startAnimation];
    [_liveingView startAnimation];
    [self updateFollowStatue];
}

- (void)viewDidDisAppear
{
    [_textScrollView closeTimer];
    [_audioAnimationView stopAnimation];
    [_liveingView removeAnimation];
    [self videoLoadingAnimation:NO];
}

#pragma mark 上拉加载更多动画 {
- (void)startLoadMoreAnimation
{
    [self endLoadMoreAnimation];
    [self addSubview:self.loadMoreView];
    [self.loadMoreView startAnimation];
}

- (void)endLoadMoreAnimation
{
    if (_loadMoreView) {
        [_loadMoreView stopAnimation];
        [_loadMoreView removeFromSuperview];
        _loadMoreView = nil;
    }
}

- (void)endLoadMoreAnimationDelay:(BOOL)delay completed:(void(^)(void))completed
{
    if (delay) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self endLoadMoreAnimation];
            if (completed) {
                completed();
            }
        });
    } else {
        [self endLoadMoreAnimation];
        if (completed) {
            completed();
        }
    }
}
#pragma mark }


#pragma mark 单击
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (self.doubleTapResponed) {
        [self startSupportAnimationCompleted:nil center:[tap locationInView:self]];
        return;
    }
    [self.textScrollView changeTimerState];
    [self.audioAnimationView pauseOrResumeAnimation];
    if (self.playBlock) {
        self.playBlock(self.videoModel);
    }
}


#pragma mark 双击
- (void)doubleTapAction:(UITapGestureRecognizer *)tap
{
    self.doubleTapResponed = YES;

    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(endDoubleResponedStatue) object:nil];
    [self performSelector:@selector(endDoubleResponedStatue) withObject:nil afterDelay:1.3];
    
    if (!self.videoModel.dirty) {
        self.videoModel.dirty = YES;
        [self likeBlockActionCompleted:^{
            
        }];
        [self.likeImageView startAnimating];
    }

    [self startSupportAnimationCompleted:nil center:[tap locationInView:self]];
}


- (void)endDoubleResponedStatue
{
    self.doubleTapResponed = NO;
}

- (void)startSupportAnimationCompleted:(void(^)(BOOL finished))completed center:(CGPoint)center
{
    if (!self) {
        return;
    }
    UIImage *image = [UIImage imageNamed:@"homepage_userguide02_img"];
    if (!image) {
        return;
    }
    
    if (CGPointEqualToPoint(center, CGPointZero)) {
        center = self.center;
    }
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(center.x - image.size.width * 0.5, center.y - image.size.height * 0.5, image.size.width, image.size.height);
    [self addSubview:imageView];
    
//    CGFloat x = self.frame.size.width;
//
//    CGFloat a = 0;
//    if (center.x < x * 0.3) {
//        a = -0.15;
//    } else if (center.x < x * 0.6) {
//        a = 0;
//    } else {
//        a = 0.15;
//    }
    
    NSArray *rotates = @[@(0), @(-0.15), @(0.15)];
    
    CGFloat a = [rotates[arc4random()%rotates.count] floatValue];
    
    CGAffineTransform transForm = CGAffineTransformRotate(CGAffineTransformIdentity, a * M_PI);
    imageView.transform = CGAffineTransformScale(transForm, 1.3, 1.3);
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        imageView.transform = CGAffineTransformScale(transForm, 1, 1);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.8 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
                imageView.transform = CGAffineTransformScale(transForm, 3, 3);
                imageView.alpha = 0;
            } completion:^(BOOL finished) {
                [imageView removeFromSuperview];
                if (completed) {
                    completed(NO);
                }
            }];
        } else {
            [imageView removeFromSuperview];
            if (completed) {
                completed(NO);
            }
        }
        
    }];
}


#pragma mark 点赞数
- (void)updateLikeTotal
{
    self.videoModel.likedTotal += (self.videoModel.dirty ? 1 : -1);
    [self setupLikeTotal];
}

- (void)setupLikeTotal
{
    if (self.videoModel.likedTotal <= 0) {
        self.videoModel.likedTotal = 0;
        self.supportBtn.titleLbale.text = @"赞赏";
    } else {
        self.supportBtn.titleLbale.text = [NSString stringWithFormat:@"%ld", (long)self.videoModel.likedTotal];
    }
}



#pragma mark 点赞状态
- (void)updateLikeStatue
{
    NSString *name = self.videoModel.dirty ? @"video_like_gif_15" : @"video_like_gif_0";
    self.likeImageView.image = [UIImage imageNamed:name];
}

#pragma mark 点赞
- (void)supportAction:(YDDCustomButton *)btn
{
    btn.enabled = NO;
    
    dispatch_group_t group = dispatch_group_create();
    
    self.videoModel.dirty = !self.videoModel.dirty;
    dispatch_group_enter(group);
    [self likeBlockActionCompleted:^{
        dispatch_group_leave(group);
    }];
    if (self.videoModel.dirty) {
        if (!self.likeImageView.animating) {
            [self.likeImageView startAnimating];
            dispatch_group_enter(group);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.48 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_group_leave(group);
            });

        }
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        btn.enabled = YES;
    });
}



#pragma mark 点赞请求
- (void)likeBlockActionCompleted:(void(^)(void))completed
{
    [self updateLikeStatue];
    [self updateLikeTotal];
    if (_supportBlock) {
        @weakify(self);
        _supportBlock(self.videoModel, ^(YDDVideoShowModel *model, BOOL success){
            @strongify(self);
            if ([model.pubId isEqualToString:self.videoModel.pubId]) {
                if (!success) {
                    self.videoModel.dirty = !self.videoModel.dirty;
                    [self updateLikeStatue];
                    [self updateLikeTotal];
                }
            }
            if (completed) {
                completed();
            }
        });
    }
}

- (void)updateCommentTotal:(NSInteger)total
{
    total = total > 0 ? total : 0;
    self.videoModel.commentsTotal = total;
    if (total > 0) {
        self.commentBtn.titleLbale.text = [NSString stringWithFormat:@"%ld", (long)self.videoModel.commentsTotal];
    } else {
        self.commentBtn.titleLbale.text = @"评论";
    }
    
}

- (void)updateUserId:(NSInteger)userId isAttention:(BOOL)isAttention
{
    if (self.videoModel.userId == userId) {
//        self.videoModel.relationship = isAttention ? @"ATTENTION" : @"UNATTENTION";
        [self updateFollowStatue];
    }
}


- (void)updateShareCount
{
    if (self.videoModel.sharedCount > 0) {
        self.shareBtn.titleLbale.text = [NSString stringWithFormat:@"%ld", (long)self.videoModel.sharedCount];
    } else {
        self.shareBtn.titleLbale.text = @"分享";
    }
    
}

- (void)updateProgress:(CGFloat)progress duration:(CGFloat)duration
{
//    [_progressView updateProgress:progress duration:duration];
}

- (void)commentAction:(YDDCustomButton *)btn
{
    if (_commentBlock) {
        _commentBlock(self.videoModel);
    }
}

- (void)shareBtnAction:(YDDCustomButton *)btn
{
    if (_shareBlock) {
        _shareBlock(self.videoModel, _bgImageView.image);
    }
}

- (void)liveingAction:(YDDVideoLiveingView *)view
{
    if (_liveBlock) {
        _liveBlock(self.videoModel);
    }
}

- (void)videoLoadingAnimation:(BOOL)isLoading
{
    if (isLoading) {
        [self.videoLoadingView startAnimation];
        self.videoLoadingView.hidden = NO;
    } else {
        [self.videoLoadingView stopAnimation];
        self.videoLoadingView.hidden = YES;
    }
}

#pragma mark 关注
- (void)addFollowBtnAction:(UIButton *)btn
{
    if (_followBlock) {
        self.addFollowBtn.enabled = NO;
        @weakify(self);
        _followBlock(self.videoModel,^(YDDVideoShowModel *model, BOOL success){
            @strongify(self);
            if (model.userId == self.videoModel.userId && success) {
                self.addFollowImageView.image = [UIImage imageNamed:@"add_attention_13"];
                [self.addFollowImageView startAnimating];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.25 animations:^{
                        self.addFollowImageView.alpha = 0;
                    } completion:^(BOOL finished) {
                        self.addFollowImageView.hidden = YES;
                        self.addFollowBtn.hidden = YES;
                        self.addFollowBtn.enabled = YES;
                        self.addFollowImageView.alpha = 1;
                    }];
                    
                    
                });
            }
            
        });
    }
}

- (UIImageView *)cellBgView
{
    if (!_cellBgView) {
        _cellBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kxVideoDefalutImage"]];
        _cellBgView.contentMode = UIViewContentModeScaleAspectFill;
        _cellBgView.clipsToBounds = YES;
    }
    return _cellBgView;
}

- (YDDCustomButton *)supportBtn
{
    if (!_supportBtn) {
        _supportBtn = [[YDDCustomButton alloc] init];
        _supportBtn.titleLbale.text = @"";
        [_supportBtn addTarget:self action:@selector(supportAction:) forControlEvents:UIControlEventTouchUpInside];
        _supportBtn.titleLbale.textColor = [UIColor colorWithWhite:1 alpha:0.8];
        _supportBtn.titleLbale.shadowColor = [UIColor colorWithWhite:0 alpha:0.2];
        _supportBtn.titleLbale.shadowOffset = CGSizeMake(0, 2);
    }
    return _supportBtn;
}

- (UIImageView *)likeImageView
{
    if (!_likeImageView) {
        _likeImageView = [[UIImageView alloc] init];
        _likeImageView.contentMode = UIViewContentModeScaleAspectFit;
        _likeImageView.clipsToBounds = YES;
        NSMutableArray *images = [NSMutableArray array];
        for (int i = 0; i < 16; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"video_like_gif_%d", i]];
            if (image) {
                [images addObject:image];
            }
        }
        _likeImageView.animationDuration = 0.67;
        _likeImageView.animationRepeatCount = 1;
        _likeImageView.animationImages = images;
    }
    return _likeImageView;
}

- (YDDCustomButton *)commentBtn
{
    if (!_commentBtn) {
        _commentBtn = [[YDDCustomButton alloc] init];
        _commentBtn.titleLbale.text = @"";
        _commentBtn.imageView.image = [UIImage imageNamed:@"homepage_comment_btn"];
        [_commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        _commentBtn.titleLbale.textColor = [UIColor colorWithWhite:1 alpha:0.8];
        _commentBtn.titleLbale.shadowColor = [UIColor colorWithWhite:0 alpha:0.2];
        _commentBtn.titleLbale.shadowOffset = CGSizeMake(0, 2);
    }
    return _commentBtn;
}


- (YDDCustomButton *)shareBtn
{
    if (!_shareBtn) {
        _shareBtn = [[YDDCustomButton alloc] init];
        _shareBtn.titleLbale.text = @"";
        _shareBtn.imageView.image = [UIImage imageNamed:@"homepage_share_btn"];
        [_shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn.titleLbale.textColor = [UIColor colorWithWhite:1 alpha:0.8];
        _shareBtn.titleLbale.shadowColor = [UIColor colorWithWhite:0 alpha:0.2];
        _shareBtn.titleLbale.shadowOffset = CGSizeMake(0, 2);
    }
    return _shareBtn;
}

- (YDDVideoLiveingView *)liveingView
{
    if (!_liveingView) {
        _liveingView = [[YDDVideoLiveingView alloc] init];
        [_liveingView addTarget:self action:@selector(liveingAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _liveingView;
}

- (void)createTextScroll
{
    UIImageView *scrollImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homepage_music_icon"]];
    scrollImage.contentMode = UIViewContentModeScaleAspectFill;
    scrollImage.clipsToBounds = YES;
    [self.audioBgView addSubview:scrollImage];
    
    [scrollImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(2);
        make.size.mas_equalTo(CGSizeMake(10, 16));
    }];
    
    
    CGRect rect =  CGRectMake(14, 0, kWidthIPHONE6(153), 20);
    self.textScrollBgView = [[UIView alloc] initWithFrame:rect];
    [self.audioBgView addSubview:self.textScrollBgView];
    
    id color0 = (id)[UIColor colorWithWhite:0 alpha:0].CGColor;
    id color1 = (id)[[UIColor colorWithWhite:0 alpha:0.5] CGColor];
    id color2 = (id)[[UIColor colorWithWhite:0 alpha:1] CGColor];
    
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    NSArray *colors = @[color0, color1, color2, color2, color1, color0];
    [maskLayer setColors:colors];
    [maskLayer setLocations:@[@(0), @(0.05), @(0.1), @(0.9), @(0.95), @(1)]];
    [maskLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
    [maskLayer setEndPoint:CGPointMake(1.0f, 0.0f)];
    maskLayer.frame = self.textScrollBgView.bounds;
   
    self.textScrollBgView.layer.mask = maskLayer;
    [self.textScrollBgView addSubview:self.textScrollView];
    self.textScrollView.frame = self.textScrollBgView.bounds;
    
}

- (UIView *)audioBgView
{
    if (!_audioBgView) {
        _audioBgView = [[UIView alloc] init];
    }
    return _audioBgView;
}

- (YDDTextScrollView *)textScrollView
{
    if (!_textScrollView) {
        _textScrollView = [[YDDTextScrollView alloc] initWithFrame:CGRectZero inteval:20 fontSize:kFontPFMedium(14)];
    }
    return _textScrollView;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [UILabel ydd_labelAlignment:NSTextAlignmentLeft font:kFontPFMedium(14) textColor:[UIColor whiteColor]];
        _contentLabel.numberOfLines = 3;
    }
    return _contentLabel;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel ydd_labelAlignment:NSTextAlignmentLeft font:kFontPFMedium(17) textColor:[UIColor whiteColor]];
    }
    return _nameLabel;
}

- (UIImageView *)certificationImageView
{
    if (!_certificationImageView) {
        _certificationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"real_tag"]];
        _certificationImageView.contentMode = UIViewContentModeScaleAspectFit;
        _certificationImageView.clipsToBounds = YES;
    }
    return _certificationImageView;
}

- (YDDVideoLocationView *)locationView
{
    if (!_locationView) {
        _locationView = [[YDDVideoLocationView alloc] init];
        @weakify(self);
        _locationView.tapBlock = ^{
            @strongify(self);
            if (self.locationBlock) {
                self.locationBlock(self.videoModel);
            }
        };
    }
    return _locationView;
}

- (UIButton *)addFollowBtn
{
    if (!_addFollowBtn) {
        _addFollowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addFollowBtn addTarget:self action:@selector(addFollowBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addFollowBtn;
}

- (UIImageView *)addFollowImageView
{
    if (!_addFollowImageView) {
        _addFollowImageView = [[UIImageView alloc] init];
        _addFollowImageView.contentMode = UIViewContentModeScaleAspectFill;
        _addFollowImageView.clipsToBounds = YES;
        NSMutableArray *images = [NSMutableArray array];
        for (int i = 0; i < 14; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"add_attention_%d", i]];
            if (image) {
                [images addObject:image];
            }
        }
        _addFollowImageView.image = images.firstObject;
        _addFollowImageView.animationImages = images;
        _addFollowImageView.animationDuration = 0.7;
        _addFollowImageView.animationRepeatCount = 1;
    }
    return _addFollowImageView;
}


- (YDDAudioAnimationView *)audioAnimationView
{
    if (!_audioAnimationView) {
        _audioAnimationView = [[YDDAudioAnimationView alloc] initWithFrame:CGRectMake(self.frame.size.width - 59, self.frame.size.height - 36 - 16 - kSafeBottom, 41, 36)];
    }
    return _audioAnimationView;
}


- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bgImageView.clipsToBounds = YES;
    }
    return _bgImageView;
}


- (UIView *)controlView
{
    if (!_controlView) {
        _controlView = [[UIView alloc] init];
    }
    return _controlView;
}

- (YDDVideoLoadMoreView *)loadMoreView
{
    if (!_loadMoreView) {
        _loadMoreView = [[YDDVideoLoadMoreView alloc] initWithFrame:CGRectMake(0, self.height - 2, self.width, 2)];
    }
    return _loadMoreView;
}

- (YDDVideoLoadMoreView *)videoLoadingView
{
    if (!_videoLoadingView) {
        _videoLoadingView = [[YDDVideoLoadMoreView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
        _videoLoadingView.hidden = YES;
    }
    return _videoLoadingView;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
}

- (CAGradientLayer *)topLayer
{
    if (_topLayer) {
        _topLayer = [[CAGradientLayer alloc] init];
        _topLayer.colors = @[(id)([UIColor colorWithWhite:0 alpha:0.5].CGColor),(id)([UIColor colorWithWhite:0 alpha:0].CGColor)];
        _topLayer.locations = @[@(0), @(1)];
        _topLayer.size = CGSizeZero;
        _topLayer.startPoint = CGPointMake(1, 0);
        _topLayer.endPoint = CGPointMake(1, 1);
    }
    return _topLayer;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

- (CAGradientLayer *)bottomLayer
{
    if (!_bottomLayer) {
        _bottomLayer = [[CAGradientLayer alloc] init];
        _bottomLayer.colors = @[(id)([UIColor colorWithWhite:0 alpha:0].CGColor),(id)([UIColor colorWithWhite:0 alpha:0.5].CGColor)];
        _bottomLayer.locations = @[@(0), @(1)];
        _bottomLayer.size = CGSizeZero;
        _bottomLayer.startPoint = CGPointMake(1, 0);
        _bottomLayer.endPoint = CGPointMake(1, 1);
    }
    return _bottomLayer;
}

- (YDDVideoProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[YDDVideoProgressView alloc] init];
        @weakify(self);
        _progressView.changeProgress = ^(CGFloat progress) {
            @strongify(self);
            if (self.updateVideoPreogressBlock) {
                return self.updateVideoPreogressBlock(progress);
            }
            return -1;
        };
    }
    return _progressView;
}

@end
