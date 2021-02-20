//
//  YDDBaseNavigationController.m
//  YDDExercise
//
//  Created by ydd on 2021/2/20.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDBaseNavigationController.h"

@interface YDDBaseNavigationController ()

@end

@implementation YDDBaseNavigationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //去掉导航栏底部阴影
    [self.navigationBar.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (@available(iOS 10.0, *)) {
            //iOS10,导航栏的私有接口为_UIBarBackground
            if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                [view.subviews firstObject].hidden = YES;
            }
        }else{
            //iOS10之前导航栏的私有接口为_UINavigationBarBackground
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                [view.subviews firstObject].hidden = YES;
            }
        }
    }];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationBar setTranslucent:YES];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    /// push二级页面隐藏tabBar
    viewController.hidesBottomBarWhenPushed = self.viewControllers.count > 0;
    [super pushViewController:viewController animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
