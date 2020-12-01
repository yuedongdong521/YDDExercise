//
//  YDDTransition.m
//  YDDExercise
//
//  Created by ydd on 2019/7/24.
//  Copyright © 2019 QH. All rights reserved.
//

#import "YDDTransition.h"
#import "YDDTransitionViewController.h"
#import "UIView+YYAdd.h"

@interface YDDTransition ()

@end

@implementation YDDTransition

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.animationDuration = 0.5;
    }
    return self;
}


- (void)pushAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    YDDTransitionViewController *fromVC = [self fromVC:transitionContext];
    YDDTransitionViewController *toVC = [self toVC:transitionContext];
    if (![fromVC isKindOfClass:[YDDTransitionViewController class]] ||
        ![toVC isKindOfClass:[YDDTransitionViewController class]]) {
        return;
    }
    UIView *fromView = [fromVC transitionAnmateView];
    
    UIView *toView = [toVC transitionAnmateView];
    
    if (!fromView || !toView) {
        return;
    }
    UIView *containerView =  [transitionContext containerView];
    [containerView addSubview:toVC.view];
    toVC.view.hidden = YES;
    
      // fromView相对于window的位置
    CGRect fromFrame = [fromView convertRect:fromView.bounds toView:nil];
    CGRect toFrame = [toView convertRect:toView.bounds toView:nil];
    __block UIImageView *toImageView = [[UIImageView alloc] initWithImage:[toView snapshotImage]];
    toImageView.frame = toFrame;
    
    __block UIImageView *fromImageView = [[UIImageView alloc] initWithImage:[fromView snapshotImage]];
    fromImageView.frame = fromFrame;

    [containerView addSubview:fromImageView];
    
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        fromImageView.frame = toFrame;
    } completion:^(BOOL finished) {
        toVC.view.hidden = NO;
        [fromImageView removeFromSuperview];
        fromImageView = nil;
        [transitionContext completeTransition:YES];
    }];
}

- (void)popAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    YDDTransitionViewController *fromVC = [self fromVC:transitionContext];
    YDDTransitionViewController *toVC = [self toVC:transitionContext];
    if (![fromVC isKindOfClass:[YDDTransitionViewController class]] ||
        ![toVC isKindOfClass:[YDDTransitionViewController class]]) {
        return;
    }
    UIView *fromView = [fromVC transitionAnmateView];
    UIView *toView = [toVC transitionAnmateView];
    if (!fromView || !toView) {
        return;
    }
    
    UIView *containerView =  [transitionContext containerView];
    [containerView addSubview:fromVC.view];
    fromVC.view.hidden = YES;
    
    CGRect fromFrame = [fromView convertRect:fromView.bounds toView:nil];
    CGRect toFrame = [toView convertRect:toView.bounds toView:nil];
    __block UIImageView *toImageView = [[UIImageView alloc] initWithImage:[toView snapshotImage]];
    toImageView.frame = toFrame;
    
    __block UIImageView *fromImageView = [[UIImageView alloc] initWithImage:[fromView snapshotImage]];
    fromImageView.frame = fromFrame;

    
    
    [containerView addSubview:toImageView];
    [containerView addSubview:fromImageView];
    
   
    fromImageView.hidden = YES;
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        toImageView.frame = fromFrame;;
    } completion:^(BOOL finished) {
        fromImageView.hidden = NO;
        [toImageView removeFromSuperview];
        toImageView = nil;
        [transitionContext completeTransition:YES];
    }];
}


#pragma mark - UIViewControllerAnimatedTransitioning
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.animationStatus) {
        case AnimationStatus_push:
            [self pushAnimateTransition:transitionContext];
            break;
        case AnimationStatus_pop:
            [self popAnimateTransition:transitionContext];
            break;
        default:
            break;
    }
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return self.animationDuration;
}

- (YDDTransitionViewController *)fromVC:(nonnull id<UIViewControllerContextTransitioning>)context
{
    return (YDDTransitionViewController *)[context viewControllerForKey:UITransitionContextFromViewControllerKey];
}

- (YDDTransitionViewController *)toVC:(nonnull id<UIViewControllerContextTransitioning>)context
{
    return (YDDTransitionViewController *)[context viewControllerForKey:UITransitionContextToViewControllerKey];
}


@end

/**
获取 view 中 point坐标点在 toView中的坐标
- (CGPoint)convertPoint:(CGPoint)point toView:(nullable UIView *)view;
 获取fromView中point坐标相对于当前view中的坐标
- (CGPoint)convertPoint:(CGPoint)point fromView:(nullable UIView *)view;
 
- (CGRect)convertRect:(CGRect)rect toView:(nullable UIView *)view;
- (CGRect)convertRect:(CGRect)rect fromView:(nullable UIView *)view
*/
