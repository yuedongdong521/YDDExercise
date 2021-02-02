//
//  MBProgressHUD+YDDExtend.h
//  YDDExercise
//
//  Created by ydd on 2021/1/29.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (YDDExtend)

+ (void)hud_showTips:(NSString *)tips;

+ (void)hud_showTips:(NSString *)tips toView:(nullable UIView *)view;

+ (void)cus_showMessage:(NSString *)message;

+ (void)cus_showMessage:(NSString *)message toView:(UIView *)view;

+ (void)showLoadingWith:(NSString *)message;

/// 隐藏
+ (void)hideHUDForView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
