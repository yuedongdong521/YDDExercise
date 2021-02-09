//
//  YDDVideoHomePlayerView.m
//  YDDExercise
//
//  Created by ydd on 2020/6/18.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoHomePlayerView.h"
#import <AFNetworking/AFNetworking.h>
#import "YDDPhotoSaveLibraryManager.h"

@implementation YDDVideoHomePlayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self addSubview:self.player];
        [self.player mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        [self addSubview:self.pauseImageView];
        [self.pauseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-10);
            make.size.mas_equalTo(CGSizeMake(75, 74));
        }];
        
        
    }
    return self;
}

- (void)updatePlayRenderWithModel:(YDDVideoInfo *)videoModel
{
    if (videoModel.high > videoModel.wide) {
        self.player.videoMode = AVLayerVideoGravityResizeAspectFill;
    } else {
        self.player.videoMode = AVLayerVideoGravityResizeAspect;
    }
}

- (void)saveVideoCompleted:(void (^)(BOOL))completed
{
    
    NSString *videoPath = [YDDFileManager ydd_readKTVCacheWithPath:self.player.curUrl];
    [YDDPhotoSaveLibraryManager saveVideo:[NSURL fileURLWithPath:videoPath] toAlbumName:YDDALBUM needTips:NO completionHandler:^(BOOL success) {
        if (!success) {
            [self downloadVideo];
        } else {
            [MBProgressHUD cus_showMessage:@"下载成功"];
        }
    }];
}

- (NSString *)downloadDire
{
    NSString *dire = NSTemporaryDirectory();
    dire = [dire stringByAppendingPathComponent:@"JXVideoDownload"];
    BOOL isDire;
    
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:dire isDirectory:&isDire];
    
    if (!isDire || !exist) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dire withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dire;
}

- (void)downloadVideo
{
    /*
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.videoUrl]];
    
    NSString *savePath = [self downloadDire];
//    savePath = [NSString stringWithFormat:@"%@%lu.mp4", savePath, (unsigned long)[self.videoUrl hash]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:savePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    
    [[manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = ((CGFloat)downloadProgress.completedUnitCount) / ((CGFloat)downloadProgress.totalUnitCount);
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:savePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            if (!error) {
                [YDDPhotoSaveLibraryManager saveVideo:[NSURL fileURLWithPath:savePath] toAlbumName:YDDALBUM needTips:NO completionHandler:^(BOOL success) {
                    if (!success) {
                        
                    } else {
                        [MBProgressHUD cus_showMessage:@"下载成功"];
                    }
                }];
            }
        });
        
    }] resume];
    */
}


- (void)pause
{
    [self.player pause];
    _pauseImageView.hidden = NO;
    
}

- (BOOL)playerURLStr:(NSString *)urlStr
{
    BOOL statue = [self.player play:urlStr];
    _pauseImageView.hidden = YES;
    return statue;
}

- (void)resume
{
    [self.player play];
    _pauseImageView.hidden = YES;
}

- (BOOL)isPlaying
{
    return _player.isPlaying;
}

- (NSString *)videoUrl
{
    return _player.curUrl;
}

- (int)updateVideoProgress:(CGFloat)progress
{
//    return [self.player seek:progress * self.player.duration];
    return 0;
}

- (UIImageView *)pauseImageView
{
    if (!_pauseImageView) {
        _pauseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homepage_play_btn"]];
        _pauseImageView.clipsToBounds = YES;
        _pauseImageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _pauseImageView;
}


- (YDDVideoPlayer *)player
{
    if (!_player) {
        _player = [[YDDVideoPlayer alloc] initWithFrame:CGRectZero];
    }
    return _player;
}

@end
