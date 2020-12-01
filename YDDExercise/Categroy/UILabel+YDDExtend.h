//
//  UILabel+YDDExtend.h
//  YDDExercise
//
//  Created by ydd on 2019/7/20.
//  Copyright © 2019 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (YDDExtend)

+ (instancetype)ydd_labelAlignment:(NSTextAlignment)alignment
                          fontSize:(CGFloat)fontSize
                              text:(nullable NSString *)text;

+ (instancetype)ydd_labelAlignment:(NSTextAlignment)alignment
                          fontName:(NSString *)fontName
                          fontSize:(CGFloat)fontSize
                              text:(nullable NSString *)text;

+ (instancetype)ydd_labelAlignment:(NSTextAlignment)alignment
                              font:(UIFont *)font
                              text:(nullable NSString *)text;

+ (instancetype)ydd_labelAlignment:(NSTextAlignment)alignment
                          fontName:(nullable NSString *)fontName
                          fontSize:(CGFloat)fontSize
                         textColor:(nullable UIColor *)textColor
                   backgroundColor:(nullable UIColor *)backgroundColor
                              text:(nullable NSString *)text;

+ (instancetype)ydd_labelAlignment:(NSTextAlignment)alignment
                              font:(nullable UIFont *)font
                         textColor:(nullable UIColor *)textColor
                   backgroundColor:(nullable UIColor *)backgroundColor
                              text:(nullable NSString *)text;


@end

NS_ASSUME_NONNULL_END
