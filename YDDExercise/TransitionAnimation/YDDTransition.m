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


- (YDDTransitionViewController *)fromVC:(nonnull id<UIViewControllerContextTransitioning>)context
{
    return (YDDTransitionViewController *)[context viewControllerForKey:UITransitionContextFromViewControllerKey];
}

- (YDDTransitionViewController *)toVC:(nonnull id<UIViewControllerContextTransitioning>)context
{
    return (YDDTransitionViewController *)[context viewControllerForKey:UITransitionContextToViewControllerKey];
}



- (void)pushAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    /// 当前VC
    YDDTransitionViewController *fromVC = [self fromVC:transitionContext];
    /// 被push出来的VC
    YDDTransitionViewController *toVC = [self toVC:transitionContext];
    if (![fromVC isKindOfClass:[YDDTransitionViewController class]] ||
        ![toVC isKindOfClass:[YDDTransitionViewController class]]) {
        return;
    }
    
    [toVC.view setNeedsLayout];
    [toVC.view layoutIfNeeded];
    
    UIView *fromView = [fromVC transitionAnmateView];
    
    UIView *toView = [toVC transitionAnmateView];
    
    if (!fromView || !toView) {
        return;
    }
    UIView *containerView =  [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
      // fromView相对于window的位置
    CGRect fromFrame = [fromView convertRect:fromView.bounds toView:nil];
    
    
    
    CGRect toFrame = [toView convertRect:toView.bounds toView:nil];
    
    __block UIImageView *toImageView = [[UIImageView alloc] initWithImage:[toView snapshotImage]];
    
    toImageView.frame = toFrame;
    toImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    __block UIImageView *fromImageView = [[UIImageView alloc] initWithImage:[fromView snapshotImage]];
    fromImageView.frame = fromFrame;

    [containerView addSubview:fromImageView];
    
    CGAffineTransform transform = [self transformWithfromFrame:fromFrame toFrame:toFrame];
    
    toVC.view.alpha = 0;
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromImageView.transform = transform;
    } completion:^(BOOL finished) {
        
        toVC.view.alpha = 1;
        [fromImageView removeFromSuperview];
        fromImageView = nil;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
}

- (void)popAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    /// 当前VC
    YDDTransitionViewController *fromVC = [self fromVC:transitionContext];
    /// pop出来的VC
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
    
    CGRect fromFrame = [fromView convertRect:fromView.bounds toView:nil];
    CGRect toFrame = [toView convertRect:toView.bounds toView:nil];
    
    __block UIImageView *fromImageView = [[UIImageView alloc] initWithImage:[fromView snapshotImage]];
    fromImageView.frame = fromFrame;
    
    
    CGAffineTransform transform = [self transformWithfromFrame:fromFrame toFrame:toFrame];
    [containerView addSubview:fromImageView];
    
    fromImageView.alpha = 1;
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromImageView.transform = transform;
    } completion:^(BOOL finished) {
        
        fromImageView.alpha = 0;
        [fromImageView removeFromSuperview];
        fromImageView = nil;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
}

- (CGAffineTransform)transformWithfromFrame:(CGRect)fromFrame toFrame:(CGRect)toFrame
{
    CGPoint fromCenter = CGPointMake(CGRectGetMidX(fromFrame), CGRectGetMidY(fromFrame));
    CGPoint toCenter = CGPointMake(CGRectGetMidX(toFrame), CGRectGetMidY(toFrame));
    
    
    CGFloat a = 1, d = 1;
    if (fromFrame.size.width != 0) {
        a = toFrame.size.width / fromFrame.size.width;
    }
    if (fromFrame.size.height != 0) {
        d = toFrame.size.height / fromFrame.size.height;
    }
    
    CGFloat scale = MAX(a, d);
    
    CGFloat tx = toCenter.x - fromCenter.x;
    CGFloat ty = toCenter.y - fromCenter.y;
    CGAffineTransform transform = CGAffineTransformMake(scale, 0, 0, scale, tx, ty);
    return transform;
}




#pragma mark - UIViewControllerAnimatedTransitioning
/// 执行具体转场动画
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

/// 返回转场动画执行时间
- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return self.animationDuration;
}


/// 转场动画结束
- (void)animationEnded:(BOOL) transitionCompleted {
    
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
