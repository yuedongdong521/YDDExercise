//
//  UIView+HUDExtend.m
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "UIView+HUDExtend.h"


@implementation UIView (HUDExtend)

- (void)hud_showTips:(NSString *)tips
{
    [self hud_showTips:tips mode:MBProgressHUDModeText delay:2.0 animated:NO];
}

- (void)hud_showTips:(NSString *)tips
            animated:(BOOL)animated
{
    [self hud_showTips:tips mode:MBProgressHUDModeIndeterminate delay:2.0 animated:animated];
}

- (void)hud_showTips:(NSString *)tips
                mode:(MBProgressHUDMode)mode
               delay:(CGFloat)delay
            animated:(BOOL)animated
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:animated];
    hud.label.text = tips;
    hud.mode = mode;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [hud setContentColor:[UIColor whiteColor]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [hud hideAnimated:animated];
        
    });
}

- (void(^)(CGFloat progress, BOOL finish))hud_loading:(NSString *)loading
{
    return [self hud_loading:loading
                        mode:MBProgressHUDModeAnnularDeterminate
                    animated:YES];
}

- (void(^)(CGFloat progress, BOOL finish))hud_loading:(NSString *)loading mode:(MBProgressHUDMode)mode animated:(BOOL)animated
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:animated];
    hud.mode = mode;
    hud.label.text = loading;
    
    void (^returnBlock)(CGFloat progress, BOOL finish) = ^(CGFloat progress, BOOL finish) {
        if (finish) {
            [hud hideAnimated:YES];
        } else {
            hud.progress = progress;
        }
    };
    
    return returnBlock;
}

@end
