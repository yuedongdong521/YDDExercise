//
//  MBProgressHUD+YDDExtend.m
//  YDDExercise
//
//  Created by ydd on 2021/1/29.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "MBProgressHUD+YDDExtend.h"
#import "UIView+HUDExtend.h"

static const NSInteger kLoadingTag = 100000101;
static const CGFloat kDelayTime = 2.0;
static const NSInteger kLoadingImageCount = 24;

@implementation MBProgressHUD (YDDExtend)

+ (void)hud_showTips:(NSString *)tips
{
    [self hud_showTips:tips toView:nil];
}

+ (void)hud_showTips:(NSString *)tips toView:(UIView *)view
{
    if (!view) {
        view = [UIApplication sharedApplication].delegate.window;
    }
    [view hud_showTips:tips];
}



#pragma mark - 显示信息
+ (void)showMsg:(NSString *)message icon:(NSString *)icon toView:(UIView *)view afterDelay:(NSTimeInterval)delay
{
    if (view == nil){
        view = [[[UIApplication sharedApplication] delegate] window];
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.animationType = MBProgressHUDAnimationFade;
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.layer.cornerRadius = 18.5;
    // 设置图片
    if (icon) {
        hud.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:icon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    }
    
    // 文本
    hud.detailsLabel.text = message;
    UIFont *detailFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    hud.detailsLabel.font = detailFont;
    hud.square = NO;

    // 主题颜色
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];

    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.8];
    // 字体颜色
    hud.contentColor = [UIColor whiteColor];
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:delay];
}


#pragma mark - 显示信息
+ (void)cus_showMsg:(NSString *)message toView:(UIView *)view afterDelay:(NSTimeInterval)delay
{
    if (view == nil){
        view = [[[UIApplication sharedApplication] delegate] window];
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 动画
    hud.animationType = MBProgressHUDAnimationFade;
    //
    hud.userInteractionEnabled = NO;
    hud.bezelView.layer.cornerRadius = 6;
    hud.removeFromSuperViewOnHide = YES;// 隐藏时候从父控件中移除
    hud.topMargin = 8;
    hud.mode = MBProgressHUDModeText;
    // 主题颜色
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.8];
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];

    // 文本
    hud.detailsLabel.text = message;
    UIFont *detailFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    hud.detailsLabel.font = detailFont;
    hud.square = NO;
    hud.label.numberOfLines = 0;
    // 字体颜色
    hud.contentColor = [UIColor whiteColor];
    // 2秒之后再消失
    if (delay > 0) {
        [hud hideAnimated:YES afterDelay:delay];
    }else{
        hud.userInteractionEnabled = YES;
    }
}

// 显示页面loading
+ (void)showGifLoading:(NSString *)message toView:(UIView *)view disableTouch:(BOOL)disableTouch{
    if (view == nil)
        view = [[[UIApplication sharedApplication] delegate] window];
    for (MBProgressHUD *subview in view.subviews) {
        if (subview.tag == kLoadingTag) {
            return;
        }
    }

    NSMutableArray *temp = [NSMutableArray array];
    for (NSInteger i = 0; i < kLoadingImageCount; i++) {
        NSString *imageName = [NSString stringWithFormat:@"loading_whit_%ld@2x.png", (long)i];
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
        [temp addObject:path];
    }
    UIImage *image =
    [[YYFrameImage alloc] initWithImagePaths:temp oneFrameDuration:1.0 / kLoadingImageCount loopCount:0];
    UIImageView *animationView = [[YYAnimatedImageView alloc] initWithImage:image];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = disableTouch;
    hud.tag = kLoadingTag;
    hud.label.text = message;
    hud.customView = animationView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.8];
    hud.contentColor = [UIColor colorWithWhite:1 alpha:1];
    UIFont *labelFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    hud.label.font = labelFont;
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
}




///  只显示文字HUD(自动消失)
+ (void)cus_showMessage:(NSString *)message toView:(UIView *)view{
    if (message.length > 0) {
        [self cus_showMsg:message toView:view afterDelay:kDelayTime];
    }
}


/// 显示成功信息提示框
/// @param success 成功信息
/// @param view 指定显示信息的view
+ (void)showSuccess:(NSString *)success toView:(UIView *)view{
      if (success.length > 0) {
          [self showMsg:success icon:nil toView:view afterDelay:kDelayTime];
      }
}


/// 显示失败信息提示框
/// @param error 失败信息
/// @param view 指定显示信息的view
+ (void)showError:(NSString *)error toView:(UIView *)view{
    if (error.length > 0) {
        [self showMsg:error icon:nil toView:view afterDelay:kDelayTime];
    }
}

+ (void)cus_showLoadingNoGifWithMessage:(NSString *)message toView:(UIView *)view{
    if (message.length > 0) {
        [self  cus_showMsg:message toView:view afterDelay:0];
    }
}

+ (void)showLoadingWith:(NSString *)message toView:(UIView *)view{
    [self showGifLoading:message toView:view disableTouch:NO];
}


/// 隐藏
+ (void)hideHUDForView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}








// --------------------   Window   -----------------------//

/// 显示消息提示框
/// @param message 消息
+ (void)cus_showMessage:(NSString *)message {
    if (message.length > 0) {
        [self cus_showMsg:message toView:nil afterDelay:kDelayTime];
    }
    
}

/// 显示成功信息提示框
/// @param success 成功信息
+ (void)showSuccess:(NSString *)success{
    if (success.length > 0) {
        [self showMsg:success icon:nil toView:nil afterDelay:kDelayTime];
    }
}


/// 显示失败信息提示框
/// @param error 失败信息
+ (void)showError:(NSString *)error{
    if (error.length > 0) {
        [self showMsg:error icon:nil toView:nil afterDelay:kDelayTime];
    }
}

+ (void)showLoadingWith:(NSString *)message{
    [self showGifLoading:message toView:nil disableTouch:NO];
}

/// 显示消息提示框,10s消失
/// @param message 消息
+ (void)showLoadingNoGifWithMessage:(NSString *)message{
    if (message.length > 0) {
        [self cus_showMsg:message toView:nil afterDelay:0];
    }
}

/// 隐藏
+ (void)hideHUD{
    UIView *view = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD hideHUDForView:view animated:YES];
}





@end
