//
//  YDDVideoRecommendViewController.m
//  YDDExercise
//
//  Created by ydd on 2020/6/17.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoRecommendViewController.h"
#import "YDDVideoCollectionView.h"
#import "YDDVideoHomePlayerView.h"
#import "YDDVideoCommentViewController.h"
#import "YDDVideoGuideView.h"
#import "YDDVideoEmptyView.h"

@interface YDDVideoRecommendViewController ()<YDDVideoCollectionViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) YDDVideoCollectionView *collectionView;

@property (nonatomic, strong) YDDVideoHomePlayerView *playerView;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger pageSize;

/// 纬度
@property (nonatomic, assign)   double latitude;
/// 经度
@property (nonatomic, assign)   double longitude;

@property (nonatomic, assign) BOOL didAppear;




@end

@implementation YDDVideoRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.pageNum = 1;
    self.pageSize = 50;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    
    [self loadTestData];
}



- (void)initUI
{
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)loadTestData
{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video" ofType:@"json"]];
    
    NSArray *arr = [NSArray yy_modelArrayWithClass:[YDDVideoShowModel class] json:dic[@"data"]];
    [self.collectionView updateVideoList:arr scorllTop:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.didAppear = YES;
//    self.playerView.playerIsAppear = YES;
    [self.collectionView fristScrollViewLoad];
    [self addVideoGuideView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     self.didAppear = NO;
//    self.playerView.playerIsAppear = NO;
    [self.playerView.player pause];
    [_collectionView viewWillDisAppear];
   
}

- (void)firstLoadData
{
    @weakify(self);
//    [self showWhiteGifLoading];
//    [self.collectionView showDYLoadingView];
    [self loadNewDataCompleted:^{
        @strongify(self);
//        [self hideLoading];
//        [self.collectionView hiddenDYLoadingView];
        [self addVideoGuideView];
    }];
}

- (void)addVideoGuideView
{
    if (!self.didAppear) {
        return;
    }
    if (self.collectionView.videoListCount == 0) {
        return;
    }
    
    @weakify(self);
    [YDDVideoGuideView showVideoPanGuideViewCompleted:^(CGFloat offsetY, BOOL isEnd, BOOL changed) {
        @strongify(self);
        [self.collectionView scrollOffsetY:offsetY end:isEnd changed:changed];
    }];
}

- (void)anchorCloseLiveingNotify:(NSNotification *)notify {
    NSInteger anchorId = [notify.userInfo[@"anchorId"] integerValue];
    [self.collectionView updateLiveingStatueWithAnchorId:anchorId liveing:NO];
}


- (void)attentionRequestNotify:(NSNotification *)notify
{
    NSDictionary *dic = notify.userInfo;
    NSInteger userId = [dic[@"userId"] integerValue];
    NSInteger type = [dic[@"type"] integerValue];
    if (userId > 0) {
        [self updateUserId:userId isAttention:type != 1];
    }
}


- (void)updateUserId:(NSInteger)userId isAttention:(BOOL)isAttention
{
    [self.collectionView updateUserId:userId isAttention:isAttention];
}

- (void)updateOpenLiveingStatueWithAnchorId:(NSInteger)anchorId
{
    [self.collectionView updateLiveingStatueWithAnchorId:anchorId liveing:YES];
}

- (void)updateShareCountWithModel:(YDDVideoShowModel *)model
{
    [self.collectionView updateShareCountWithModel:model];
}


- (void)downloadVideo
{
    [self.playerView saveVideoCompleted:^(BOOL success) {
        if (success) {

        } else {

        }
        NSLog(@"downloadVideo statue : %d", success);
    }];
}

- (void)loadNewDataCompleted:(void (^)(void))completed
{}

- (void)loadMoreDataCompleted:(void(^)(void))completed
{}

- (void)requestDataComplteted:(void(^)(NSArray <YDDVideoShowModel*>* videoList, BOOL success))completed
{}


- (void)videoCollectionView:(YDDVideoCollectionView *)view
       didEndDisplayingCell:(YDDVideoCollectionCell *)cell
                      index:(NSIndexPath *)index
{
    if (self.playerView.curIndex == index.item) {
        [self.playerView removeFromSuperview];
        self.playerView.player.mute = YES;
        
    }
}

- (void)videoCollectionView:(YDDVideoCollectionView *)view
              scrollEndCell:(YDDVideoCollectionCell *)cell
                      index:(NSIndexPath *)index
{
    NSLog(@"scrollEndCell step 1");
    if (!cell) {
        NSLog(@"scrollEndCell step 2");
        return;
    }
    
    if (index.item == 1) {
        [YDDVideoGuideView showVideoTapGuideView];
    }
    
    if (self.playerView.isPlaying) {
        if ([self.playerView.videoUrl isEqualToString:cell.videoModel.video.videoUrl] && self.playerView.curIndex == index.item && self.playerView.superview == cell.bgImageView) {
            NSLog(@"scrollEndCell step 3");
            return;
        }
    }
    
    if (self.playerView.superview) {
        [self.playerView removeFromSuperview];
    }
    [self.playerView.player pause];
    
    if (!self.didAppear) {
        return;
    }
    
    @weakify(self);
    cell.updateVideoPreogressBlock = ^int(CGFloat progress) {
//        @strongify(self);
//        return [self.playerView updateVideoProgress:progress];
        return 0;
    };
    
    [self.playerView updatePlayRenderWithModel: cell.videoModel.video];
    self.playerView.curIndex = index.item;
    [cell.bgImageView addSubview:self.playerView];
    
    [self.playerView playerURLStr:cell.videoModel.video.videoUrl];
    self.playerView.player.mute = NO;
    
}

- (void)presentCommentViewController:(YDDVideoShowModel *)videoModel
{
    @weakify(self);
    YDDVideoCommentViewController *vc = [YDDVideoCommentViewController presnetWithVideoModel:videoModel superVC:nil callBackCommentTotal:^(NSInteger total) {
        @strongify(self);
        [self.collectionView updateCommentTotal:total];
    }];
    vc.attentionCallBack = ^(NSInteger userId, BOOL isAttention) {
        @strongify(self);
        [self.collectionView updateUserId:userId isAttention:isAttention];
    };
    vc.changePlayerStatue = ^(BOOL isPause) {
//        @strongify(self);
        if (isPause) {
//            [self.playerView pause];
        } else {
//            [self.playerView resume];
        }
    };
}

- (YDDVideoCollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[YDDVideoCollectionView alloc] initWithType:YDDVideoCollectionViewType_recommend];
        _collectionView.delegate = self;
        
        @weakify(self);
        _collectionView.supportBlock = ^(YDDVideoShowModel * _Nonnull videoModel, void (^ _Nonnull completed)(YDDVideoShowModel * _Nonnull, BOOL)) {
            @strongify(self);
            if (self.likeBlock) {
                self.likeBlock(videoModel, completed);
            }
        };
        
        _collectionView.commentBlock = ^(YDDVideoShowModel * _Nonnull videoModel) {
            @strongify(self);
            [self presentCommentViewController:videoModel];
        };
        
        _collectionView.shareBlock = ^(YDDVideoShowModel * _Nonnull videoModel, UIImage *coverImage) {
            @strongify(self);
            if (self.shareBlock) {
                self.shareBlock(videoModel, coverImage);
            }
            [self downloadVideo];
        };
        
        
        _collectionView.followBlock = ^(YDDVideoShowModel * _Nonnull videoModel, void (^ _Nonnull completed)(YDDVideoShowModel * _Nonnull, BOOL)) {
            @strongify(self);
            if (self.followBlock) {
                self.followBlock(videoModel, completed);
            }
        };
        
        _collectionView.liveBlock = ^(YDDVideoShowModel * _Nonnull videoModel) {
            @strongify(self);
            if (self.liveBlock) {
                self.liveBlock(videoModel);
            }
        };
        
        _collectionView.playBlock = ^(YDDVideoShowModel * _Nonnull videoModel) {
//            @strongify(self);
//            if (self.playerView.isPlaying) {
//                [self.playerView pause];
//            } else {
//                [self.playerView resume];
//            }
        };
        
        _collectionView.pullRefreshOffsetY = ^(CGFloat offsetY, BOOL isBegan, BOOL isRefresh) {
            @strongify(self);
            if (self.pullRefreshOffsetY) {
                self.pullRefreshOffsetY(offsetY, isBegan, isRefresh);
            }
        };
        
        _collectionView.loadMoreBlock = ^(void (^ _Nonnull completed)(void)) {
            @strongify(self);
            [self loadMoreDataCompleted:completed];
        };
        
        
    }
    return _collectionView;
}

- (YDDVideoHomePlayerView *)playerView
{
    if (!_playerView) {
        _playerView = [[YDDVideoHomePlayerView alloc] init];
        _playerView.frame = self.collectionView.bounds;
        @weakify(self);
        _playerView.player.playerProgressBlock = ^(CGFloat progress, CGFloat duration) {
            @strongify(self);
            [self.collectionView updateProgress:progress duration:duration];
        };

        _playerView.player.loadStatueBlock = ^(BOOL isLoadingComplete) {
            @strongify(self);
            [self.collectionView videoLoading:!isLoadingComplete];
        };
    }
    return _playerView;
}



- (void)dealloc
{
    [_playerView.player destory];
    _playerView = nil;
}


@end
