//
//  YDDVideoTransition.h
//  YDDExercise
//
//  Created by ydd on 2020/6/23.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    YDDVideoTransitionType_push = 0,
    YDDVideoTransitionType_pop,
} YDDVideoTransitionType;

@interface YDDVideoTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) YDDVideoTransitionType transitionType;

@property (nonatomic, assign) CGFloat animationDuration;

@end

NS_ASSUME_NONNULL_END
