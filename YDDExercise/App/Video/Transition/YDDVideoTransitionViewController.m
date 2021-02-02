//
//  YDDVideoTransitionViewController.m
//  YDDExercise
//
//  Created by ydd on 2020/6/23.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoTransitionViewController.h"
#import "YDDVideoTransition.h"

@interface YDDVideoTransitionViewController ()<UINavigationControllerDelegate>

@end

@implementation YDDVideoTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (UIView *)transitionAnmateView
{
    return nil;
}


- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController NS_AVAILABLE_IOS(7_0)
{
    
    
    return nil;
}


- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0)
{
    if (![fromVC isKindOfClass:[YDDVideoTransitionViewController class]] ||
        ![toVC isKindOfClass:[YDDVideoTransitionViewController class]]) {
        return nil;
    }
    
    UIView *fromView = [(YDDVideoTransitionViewController *)fromVC transitionAnmateView];
    UIView *toView =  [(YDDVideoTransitionViewController *)toVC transitionAnmateView];
    if (!fromView || !toView) {
        return nil;
    }
    
    YDDVideoTransition *transition = [[YDDVideoTransition alloc] init];
    if (operation == UINavigationControllerOperationPush) {
        if (self.hiddenPushAnimation) {
            return nil;
        }
        transition.transitionType = YDDVideoTransitionType_push;
    } else if (operation == UINavigationControllerOperationPop) {
        if (self.hiddenPopAnimation) {
            return nil;
        }
        transition.transitionType = YDDVideoTransitionType_pop;
    }
    return transition;
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
