//
//  YDDTransitionViewController.m
//  YDDExercise
//
//  Created by ydd on 2019/7/24.
//  Copyright © 2019 QH. All rights reserved.
//

#import "YDDTransitionViewController.h"
#import "YDDTransition.h"


@interface YDDTransitionViewController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;

@property (nonatomic, assign) BOOL interactiving;

@property (nonatomic, assign) BOOL hasInteractive;

@end

@implementation YDDTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    
    if (self.hasInteractive) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.hasInteractive) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (UIView *)transitionAnmateView
{
    return nil;
}

/// 添加滑动pop手势
- (void)addPopInteractiveTransition
{
    if (!self.navigationController) {
        return;
    }
    
    self.hasInteractive = YES;
    
    UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    pangesture.delegate = self;
    [self.navigationController.view addGestureRecognizer:pangesture];
    
    self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];

}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}


- (void)panGestureAction:(UIPanGestureRecognizer *)gesture
{
    UIView* view = gesture.view;
    CGPoint location = [gesture locationInView:view];
    CGPoint translation = [gesture translationInView:view];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            _interactiving = YES;
            if (location.x < CGRectGetMidX(view.bounds) && self.navigationController.viewControllers.count > 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            CGFloat fraction = fabs(translation.x / view.bounds.size.width);
            
            NSLog(@"滑动转场动画 ： %f", fraction);
            [_interactiveTransition updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            _interactiving = NO;
            CGFloat fraction = fabs(translation.x / view.bounds.size.width);
            if (fraction < 0.5 || [gesture velocityInView:view].x < 0 || gesture.state == UIGestureRecognizerStateCancelled) {
                [_interactiveTransition cancelInteractiveTransition];
            } else {
                [_interactiveTransition finishInteractiveTransition];
            }
            
            break;
        }
        default:
            break;
    }
}


/**
 为这个动画添加用户交互
 */
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController NS_AVAILABLE_IOS(7_0)
{
    
    
    return self.hasInteractive ? self.interactiving ? self.interactiveTransition : nil : nil;
}

/**
 用来自定义转场动画
 要返回一个准守UIViewControllerInteractiveTransitioning协议的对象,并在里面实现动画即可
 1.创建继承自 NSObject 并且声明 UIViewControllerAnimatedTransitioning 的的动画类。
 2.重载 UIViewControllerAnimatedTransitioning 中的协议方法。
 */
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0)
{
    if (![fromVC respondsToSelector:@selector(transitionAnmateView)] ||
        ![toVC respondsToSelector:@selector(transitionAnmateView)]) {
        return nil;
    }
    
    YDDTransition *transition = [[YDDTransition alloc] init];
    if (self.activePush && operation == UINavigationControllerOperationPush) {
        
        transition.animationStatus = AnimationStatus_push;
        return transition;
        
    }
    
    if (self.activePop && operation == UINavigationControllerOperationPop) {
        
        transition.animationStatus = AnimationStatus_pop;
        return transition;
    }
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
