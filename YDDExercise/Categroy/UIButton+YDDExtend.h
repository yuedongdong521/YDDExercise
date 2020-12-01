//
//  UIButton+YDDExtend.h
//  YDDExercise
//
//  Created by ydd on 2019/7/20.
//  Copyright © 2019 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (YDDExtend)

+ (instancetype)ydd_buttonType:(UIButtonType)type
                        target:(id)target
                        action:(SEL)action;

+ (instancetype)ydd_buttonType:(UIButtonType)type
                         title:(NSString *)title
                        target:(id)target
                        action:(SEL)action;

+ (instancetype)ydd_buttonType:(UIButtonType)type
                         image:(UIImage *)image
                        target:(id)target
                        action:(SEL)action;

+ (instancetype)ydd_buttonType:(UIButtonType)type
                         title:(NSString *)title
               backgroundImage:(UIImage *)backgroundImage
                        target:(id)target
                        action:(SEL)action;

+ (instancetype)ydd_buttonType:(UIButtonType)type
                         title:(NSString *)title
               backgroundColor:(UIColor *)backgroundColor
                        target:(id)target
                        action:(SEL)action;

+ (instancetype)ydd_buttonType:(UIButtonType)type
                         frame:(CGRect)frame
                         title:(nullable NSString *)title
                         image:(nullable UIImage *)image
               backgroundImage:(nullable UIImage *)backgroundImage
               backgroundColor:(nullable UIColor*)backgroundColor
                           tag:(NSInteger)tag
                        target:(id)target
                        action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
