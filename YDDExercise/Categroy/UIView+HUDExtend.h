//
//  UIView+HUDExtend.h
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HUDExtend)

- (void)hud_showTips:(NSString *)tips;

- (void)hud_showTips:(NSString *)tips
            animated:(BOOL)animated;


- (void)hud_showTips:(NSString *)tips
                mode:(MBProgressHUDMode)mode
               delay:(CGFloat)delay
            animated:(BOOL)animated;

- (void(^)(CGFloat progress, BOOL finish))hud_loading:(NSString *)loading;

- (void(^)(CGFloat progress, BOOL finish))hud_loading:(NSString *)loading
                                                 mode:(MBProgressHUDMode)mode
                                             animated:(BOOL)animated;


@end

NS_ASSUME_NONNULL_END
