//
//  YDDVideoProgressView.h
//  YDDExercise
//
//  Created by ydd on 2020/7/9.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define KVideoProgressH 16

@interface YDDVideoProgressView : UIView

/// progress : 0~1
@property (nonatomic, copy) int(^changeProgress)(CGFloat progress);


- (void)updateProgress:(CGFloat)progress duration:(CGFloat)duration;


@end

NS_ASSUME_NONNULL_END
