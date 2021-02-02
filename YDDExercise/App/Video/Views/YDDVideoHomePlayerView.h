//
//  YDDVideoHomePlayerView.h
//  YDDExercise
//
//  Created by ydd on 2020/6/18.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDDVideoShowModel.h"
#import "YDDExercise-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDDVideoHomePlayerView : UIView

@property (nonatomic, strong) UIImageView *pauseImageView;

@property (nonatomic, assign) NSInteger curIndex;

@property (nonatomic, strong) YDDVideoPlayer *player;

@property (nonatomic, assign, readonly) BOOL isPlaying;
@property (nonatomic, strong, readonly) NSString *videoUrl;


- (BOOL)playerURLStr:(NSString *)urlStr;

- (void)updatePlayRenderWithModel:(YDDVideoInfo *)videoModel;

- (int)updateVideoProgress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
