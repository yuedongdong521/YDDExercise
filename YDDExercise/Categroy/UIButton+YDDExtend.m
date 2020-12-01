//
//  UIButton+YDDExtend.m
//  YDDExercise
//
//  Created by ydd on 2019/7/20.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "UIButton+YDDExtend.h"

@implementation UIButton (YDDExtend)

+ (instancetype)ydd_buttonType:(UIButtonType)type
                        target:(id)target
                        action:(SEL)action
{
    return [self ydd_buttonType:type
                          frame:CGRectZero
                          title:@""
                          image:nil
                backgroundImage:nil
                backgroundColor:[UIColor clearColor]
                            tag:0 target:target
                         action:action];
}

+ (instancetype)ydd_buttonType:(UIButtonType)type
                         title:(NSString *)title
                        target:(id)target
                        action:(SEL)action
{
    return [self ydd_buttonType:type
                          frame:CGRectZero
                          title:title
                          image:nil
                backgroundImage:nil
                backgroundColor:[UIColor clearColor]
                            tag:0 target:target
                         action:action];
}


+ (instancetype)ydd_buttonType:(UIButtonType)type
                         image:(UIImage *)image
                        target:(id)target
                        action:(SEL)action
{
    return [self ydd_buttonType:type
                          frame:CGRectZero
                          title:nil
                          image:image
                backgroundImage:nil
                backgroundColor:[UIColor clearColor]
                            tag:0 target:target
                         action:action];
}

+ (instancetype)ydd_buttonType:(UIButtonType)type
                         title:(NSString *)title
               backgroundImage:(UIImage *)backgroundImage
                        target:(id)target
                        action:(SEL)action
{
    return [self ydd_buttonType:type
                          frame:CGRectZero
                          title:title
                          image:nil
                backgroundImage:backgroundImage
                backgroundColor:[UIColor clearColor]
                            tag:0 target:target
                         action:action];
}

+ (instancetype)ydd_buttonType:(UIButtonType)type
                         title:(NSString *)title
               backgroundColor:(UIColor *)backgroundColor
                        target:(id)target
                        action:(SEL)action
{
    return [self ydd_buttonType:type
                          frame:CGRectZero
                          title:title
                          image:nil
                backgroundImage:nil
                backgroundColor:backgroundColor
                            tag:0
                         target:target
                         action:action];
}

+ (instancetype)ydd_buttonType:(UIButtonType)type
                         frame:(CGRect)frame
                         title:(NSString *)title
                         image:(UIImage *)image
               backgroundImage:(UIImage *)backgroundImage
               backgroundColor:(UIColor *)backgroundColor
                           tag:(NSInteger)tag
                        target:(id)target
                        action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:type];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    if (backgroundImage) {
        [btn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    } else {
        if (backgroundColor) {
            btn.backgroundColor = backgroundColor;
        }
    }
    btn.tag = tag;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


@end
