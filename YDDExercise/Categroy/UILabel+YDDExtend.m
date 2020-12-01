//
//  UILabel+YDDExtend.m
//  YDDExercise
//
//  Created by ydd on 2019/7/20.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "UILabel+YDDExtend.h"

@implementation UILabel (YDDExtend)

+ (instancetype)ydd_labelAlignment:(NSTextAlignment)alignment
                          fontSize:(CGFloat)fontSize
                              text:(NSString *)text
{
    return [self ydd_labelAlignment:alignment fontName:nil fontSize:fontSize textColor:nil backgroundColor:nil text:text];
}

+ (instancetype)ydd_labelAlignment:(NSTextAlignment)alignment
                          fontName:(NSString *)fontName
                          fontSize:(CGFloat)fontSize
                              text:(NSString *)text
{
    return [self ydd_labelAlignment:alignment fontName:fontName fontSize:fontSize textColor:nil backgroundColor:nil text:text];
}

+ (instancetype)ydd_labelAlignment:(NSTextAlignment)alignment
                              font:(UIFont *)font
                              text:(NSString *)text
{
    return [self ydd_labelAlignment:alignment font:font textColor:nil backgroundColor:nil text:text];
}

+ (instancetype)ydd_labelAlignment:(NSTextAlignment)alignment
                          fontName:(NSString *)fontName
                          fontSize:(CGFloat)fontSize
                         textColor:(UIColor *)textColor
                   backgroundColor:(UIColor *)backgroundColor
                              text:(NSString *)text
{
    fontSize = fontSize > 0 ? fontSize : 16;
    UIFont *font = nil;
    if (fontName.length > 0) {
        font = [UIFont fontWithName:fontName size:fontSize];
    }
    if (!font) {
        font = [UIFont systemFontOfSize:fontSize];
    }
    return [self ydd_labelAlignment:alignment font:font textColor:textColor backgroundColor:backgroundColor text:text];
}

+ (instancetype)ydd_labelAlignment:(NSTextAlignment)alignment
                              font:(UIFont *)font
                         textColor:(UIColor *)textColor
                   backgroundColor:(UIColor *)backgroundColor
                              text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = alignment;
    if (font) {
        label.font = font;
    }
    if (textColor) {
        label.textColor = textColor;
    }
    if (backgroundColor) {
        label.backgroundColor = backgroundColor;
    }
    if (text.length > 0) {
        label.text = text;
    }
    return label;
}


@end
