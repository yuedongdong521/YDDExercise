//
//  YDDVideoTransition.m
//  YDDExercise
//
//  Created by ydd on 2020/6/23.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoTransition.h"
#import "YDDTransitionViewController.h"
#import <YYCategories/UIView+YYAdd.h>

@implementation YDDVideoTransition


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.animationDuration = 0.3;
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
        [transitionContext completeTransition:YES];
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
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.transitionType) {
        case YDDVideoTransitionType_push:
            [self pushAnimateTransition:transitionContext];
            break;
        case YDDVideoTransitionType_pop:
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
