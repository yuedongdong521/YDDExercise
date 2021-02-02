//
//  YDDVideoCollectionView.m
//  YDDExercise
//
//  Created by ydd on 2020/6/17.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoCollectionView.h"


@interface YDDVideoCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) YDDVideoCollectionCell *currentCell;

@property (nonatomic, strong) NSMutableArray <YDDVideoShowModel*>*videoList;

@property (nonatomic, assign) YDDVideoCollectionViewType viewType;

@end

@implementation YDDVideoCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithType:(YDDVideoCollectionViewType)viewType
{
    self = [super init];
    if (self) {
        _viewType = viewType;
        _respendEnable = YES;
        _showControllView = YES;
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        pan.delegate = self;
        [self addGestureRecognizer:pan];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        [tap requireGestureRecognizerToFail:pan];
        [self.collectionView reloadData];
    }
    return self;
}


- (void)updateLiveingStatueWithAnchorId:(NSInteger)anchorId liveing:(BOOL)isLiveing
{
    if (anchorId > 0) {
        [self.videoList enumerateObjectsUsingBlock:^(YDDVideoShowModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (anchorId == obj.userId) {
                obj.isPlaying = isLiveing ? 1 : 0;
            }
        }];
    }
    [self.currentCell updateLiveingStatue];
}

- (void)setCollectionViewY:(CGFloat)collectionViewY
{
    _collectionViewY = collectionViewY;
}

- (void)updateVideoList:(NSArray<YDDVideoShowModel *> *)videoList scorllTop:(BOOL)scrollTop
{
    if (scrollTop && self.collectionView.contentOffset.y != 0) {
        self.collectionView.contentOffset = CGPointZero;
    }
    [self.videoList removeAllObjects];
    if (videoList.count > 0) {
        [self.videoList addObjectsFromArray:videoList];
    }
    [self reloadDate];
}

- (void)addVideoList:(NSArray<YDDVideoShowModel *> *)videoList
{
    if (videoList.count > 0) {
        [self.videoList addObjectsFromArray:videoList];
        [self reloadDate];
    }
}

- (void)reloadDate
{
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollViewDidEndDecelerating:self.collectionView];
    });
}

- (void)updateVideoList:(NSArray<YDDVideoShowModel *> *)videoList index:(NSInteger)index
{
    [self.videoList addObjectsFromArray:videoList];
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.collectionView numberOfItemsInSection:0] > index) {
            [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.frame.size.height * index) animated:NO];
            [self scrollViewDidEndDecelerating:self.collectionView];
        }
    });
}

- (void)setRespendEnable:(BOOL)respendEnable
{
    _respendEnable = respendEnable;
    _collectionView.scrollEnabled = respendEnable;
}

- (void)setShowControllView:(BOOL)showControllView
{
    _showControllView = showControllView;
    _currentCell.controlView.hidden = !showControllView;
}

- (void)viewWillDisAppear
{
    [_currentCell viewDidDisAppear];
}


- (void)fristScrollViewLoad
{
    [self scrollViewDidEndDecelerating:self.collectionView];
    [_currentCell viewWillAppear];
}

- (void)scrollOffsetY:(CGFloat)offsetY end:(BOOL)isEnd changed:(BOOL)changed
{
    NSLog(@"scrollOffsetY : %f", offsetY);
    
    CGPoint offSet = self.collectionView.contentOffset;
    offSet.y = -offsetY;
    if (!isEnd) {
        if (self.collectionView.contentSize.height >= offSet.y) {
            [self.collectionView setContentOffset:offSet];
        }
    } else {
        if (changed) {
            if ([self.collectionView numberOfItemsInSection:0] > 1) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
            }
        } else {
            offSet.y = 0;
            [self.collectionView setContentOffset:offSet];
        }
    }
}

- (void)updateCommentTotal:(NSInteger)total
{
    [self.currentCell updateCommentTotal:total];
}

- (void)updateShareCountWithModel:(YDDVideoShowModel *)model
{
    [self.videoList enumerateObjectsUsingBlock:^(YDDVideoShowModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.pubId isEqualToString:model.pubId]) {
            obj.sharedCount++;
        }
    }];
    [self.currentCell updateShareCount];
}

- (void)updateUserId:(NSInteger)userId isAttention:(BOOL)isAttention
{
    [self.videoList enumerateObjectsUsingBlock:^(YDDVideoShowModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.userId == userId) {
            obj.relationship = isAttention ? @"ATTENTION" : @"UNATTENTION";
        }
    }];
    [self.currentCell updateUserId:userId isAttention:isAttention];
}

- (void)followVCUpdateUserId:(NSInteger)userId attentionType:(NSInteger)type
{
    if (type != 1) {
        return;
    }
    NSMutableArray <YDDVideoShowModel*>*mutArr = [NSMutableArray array];
    [self.videoList enumerateObjectsUsingBlock:^(YDDVideoShowModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"videoList idx : %lu", (unsigned long)idx);
        if (obj.userId != userId) {
            [mutArr addObject:obj];
        }
    }];
    if (mutArr.count < self.videoList.count) {
        [self updateVideoList:mutArr scorllTop:NO];
    }
}


- (void)updateModel:(YDDVideoShowModel *)model completed:(void(^)(YDDVideoShowModel *model, BOOL success))completed
{
    @weakify(self);
    void(^completedBack)(YDDVideoShowModel * _Nonnull, BOOL success) = ^(YDDVideoShowModel * model, BOOL success) {
        @strongify(self);
        if (success) {
            [self.videoList enumerateObjectsUsingBlock:^(YDDVideoShowModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.userId == model.userId) {
                    obj.relationship = @"ATTENTION";
                }
            }];
        }
        if (completed) {
            completed(model, success);
        }
    };
    
    if (self.followBlock) {
        self.followBlock(model, completedBack);
    }
}

- (void)updateProgress:(CGFloat)progress duration:(CGFloat)duration
{
    [self.currentCell updateProgress:progress duration:duration];
}

- (void)videoLoading:(BOOL)isLoading
{
    [self.currentCell videoLoadingAnimation:isLoading];
}

#pragma mark 关注移动遮挡关注直播列表
- (void)moveCollectionView:(BOOL)isOrigin animation:(BOOL)animation completed:(void(^)(void))completed
{
    CGRect rect = self.frame;
    rect.origin.y = isOrigin ? 0 : self.collectionViewY;
    
    if (!animation) {
        self.frame = rect;
        self.showControllView = isOrigin;
        self.respendEnable = isOrigin;
        if (completed) {
            completed();
        }
        return;
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        if (!finished) {
            self.frame = rect;
        }
        self.showControllView = isOrigin;
        self.respendEnable = isOrigin;
        if (completed) {
            completed();
        }
    }];
    
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.loadMoreing) {
        return NO;
    }
    if (self.collectionView.contentOffset.y >= self.collectionView.frame.size.height) {
        
        if (self.viewType == YDDVideoCollectionViewType_follow) {
            if (self.frame.origin.y == self.collectionViewY) {
                self.respendEnable = NO;
                return YES;
            }
        }
        self.respendEnable = YES;
        return NO;
    }
    
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.viewType == YDDVideoCollectionViewType_follow) {
            if (self.frame.origin.y == self.collectionViewY) {
                self.respendEnable = NO;
                return YES;
            }
        }
        self.respendEnable = YES;
        return NO;
    }
    
    
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint move = [pan translationInView:self];
        if (fabs(move.x) > fabs(move.y)) {
            return NO;
        }
        
        if (move.y > 0) {
            self.respendEnable = NO;
            return YES;
        }
        if (self.viewType == YDDVideoCollectionViewType_follow) {
            if (self.frame.origin.y == self.collectionViewY) {
                self.respendEnable = NO;
                return YES;
            }
        }
        self.respendEnable = YES;
        return NO;
        
    }
    
    self.respendEnable = NO;
    return YES;
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (self.frame.origin.y != 0) {
        [self moveCollectionView:YES animation:YES completed:^{
            if (self.showFollowItem) {
                self.showFollowItem(NO);
            }
        }];
    }
}

- (void)panAction:(UIPanGestureRecognizer *)pan
{
    CGPoint move = [pan translationInView:self.collectionView];
    
    BOOL isPullRefresh = self.collectionView.contentOffset.y < self.collectionView.bounds.size.height;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            if (move.y <= 0) {
                if (self.frame.origin.y != 0) {
                    [self moveCollectionView:YES animation:YES completed:^{
                        if (self.showFollowItem) {
                            self.showFollowItem(NO);
                        }
                    }];
                }
            } else {
                if (isPullRefresh && self.pullRefreshOffsetY) {
                    self.pullRefreshOffsetY(move.y, YES, NO);
                }
            }
        }
            
            break;
        case UIGestureRecognizerStateChanged: {
            
            if (isPullRefresh && self.pullRefreshOffsetY) {
                self.pullRefreshOffsetY(move.y, NO, NO);
            }
        }
            break;
            
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            
            if (isPullRefresh && self.pullRefreshOffsetY) {
                self.pullRefreshOffsetY(move.y, NO, YES);
            }
            self.respendEnable = YES;
        }
            break;
            
        default:
            break;
    }
    
}

- (void)scrollEndUpdateVideo
{
    CGFloat offsetY = self.collectionView.contentOffset.y;
    NSInteger index = ceilf(offsetY / self.collectionView.bounds.size.height);
    if (index >= [self.collectionView numberOfItemsInSection:0]) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    YDDVideoCollectionCell *cell = (YDDVideoCollectionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    _currentCell = cell;
    if ([_delegate respondsToSelector:@selector(videoCollectionView:scrollEndCell:index:)]) {
        [_delegate videoCollectionView:self scrollEndCell:cell index:indexPath];
    }
    
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollEndUpdateVideo];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollEndUpdateVideo];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scroll contentSize : %@", NSStringFromCGSize(scrollView.contentSize));
    CGFloat offsetY = self.collectionView.contentSize.height - scrollView.contentOffset.y - self.collectionView.bounds.size.height;
    NSLog(@"scroll contentOffsetY %f", offsetY);
    if (offsetY <= 0) {
        if (self.hasLoadMore && !self.loadMoreing) {
            self.loadMoreing = YES;
            self.respendEnable = NO;
            [self.currentCell startLoadMoreAnimation];
            @weakify(self);
            if (self.loadMoreBlock) {
                self.loadMoreBlock(^{
                    @strongify(self);
                    [self.currentCell endLoadMoreAnimationDelay:YES completed:^{
                        self.loadMoreing = NO;
                        self.respendEnable = YES;
                    }];
                    
                });
            }
        }
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
   [self scrollEndUpdateVideo];
}

#pragma mark UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.collectionView.bounds.size;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _videoList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YDDVideoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.videoModel = self.videoList[indexPath.item];
    @weakify(self);
    cell.supportBlock = ^(YDDVideoShowModel * _Nonnull videoModel, void (^ _Nonnull completed)(YDDVideoShowModel * _Nonnull, BOOL)) {
        @strongify(self);
        if (self.supportBlock) {
            self.supportBlock(videoModel, completed);
        }
    };
    
    cell.commentBlock = ^(YDDVideoShowModel * _Nonnull videoModel) {
        @strongify(self);
        if (self.commentBlock) {
            self.commentBlock(videoModel);
        }
    };
    
    cell.shareBlock = ^(YDDVideoShowModel * _Nonnull videoModel, UIImage *coverImage) {
        @strongify(self);
        if (self.shareBlock) {
            self.shareBlock(videoModel, coverImage);
        }
    };
    
    
    cell.followBlock = ^(YDDVideoShowModel * _Nonnull videoModel, void (^ _Nonnull completed)(YDDVideoShowModel * _Nonnull, BOOL success)) {
        @strongify(self);
        
        [self updateModel:videoModel completed:completed];
    };
    
    cell.liveBlock = ^(YDDVideoShowModel * _Nonnull videoModel) {
        @strongify(self);
        if (self.liveBlock) {
            self.liveBlock(videoModel);
        }
    };
    cell.playBlock = ^(YDDVideoShowModel * _Nonnull videoModel) {
        @strongify(self);
        if (self.playBlock) {
            self.playBlock(videoModel);
        }
    };
    
    cell.locationBlock = ^(YDDVideoShowModel * _Nonnull videoModel) {
        @strongify(self);
        if (self.locationBlock) {
            self.locationBlock(videoModel);
        }
    };
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    YDDVideoCollectionCell *videoCell = (YDDVideoCollectionCell*)cell;
    [videoCell viewWillAppear];
    videoCell.controlView.hidden = !_showControllView;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(videoCollectionView:didEndDisplayingCell:index:)]) {
        [_delegate videoCollectionView:self didEndDisplayingCell:(YDDVideoCollectionCell *)cell index:indexPath];
    }
    
    [((YDDVideoCollectionCell*)cell) viewDidDisAppear];
}


- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = YES;
        if (_viewType == YDDVideoCollectionViewType_player) {
            [_collectionView registerClass:[YDDVideoCollectionCell class] forCellWithReuseIdentifier:@"cell"];
            
        } else {
            [_collectionView registerClass:[YDDHomeVideoCollectionCell class] forCellWithReuseIdentifier:@"cell"];
            
        }
        
    
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
     return _collectionView;
}

- (NSMutableArray<YDDVideoShowModel *> *)videoList
{
    if (!_videoList) {
        _videoList = [NSMutableArray array];
    }
    return _videoList;
}


- (NSInteger)videoListCount
{
    return self.videoList.count;
}

- (YDDVideoShowModel *)lastVideoModel
{
    return self.videoList.lastObject;
}

@end
