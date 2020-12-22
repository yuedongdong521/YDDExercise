//
//  YDDAnimationContentViewController.h
//  YDDExercise
//
//  Created by ydd on 2020/12/3.
//  Copyright © 2020 ydd. All rights reserved.
//

#import "YDDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AnimationType) {
    /// 力学动画
    AnimationType_Dynamics = 0,
    /// 坐标系
    AnimationType_System
};

@interface YDDAnimationContentViewController : YDDBaseViewController



- (instancetype)initWithType:(AnimationType)type;


@end

NS_ASSUME_NONNULL_END
