//
//  YDDVideoLiveingView.h
//  YDDExercise
//
//  Created by ydd on 2020/6/18.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDDVideoLiveingView : UIControl

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UIImageView *statueImageView;

@property (nonatomic, strong) UIView *boxView;

@property (nonatomic, assign) BOOL isLiveing;

- (void)startAnimation;

- (void)removeAnimation;

@end

NS_ASSUME_NONNULL_END
