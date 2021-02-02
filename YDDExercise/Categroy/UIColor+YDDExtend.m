//
//  UIColor+YDDExtend.m
//  YDDExercise
//
//  Created by ydd on 2021/2/1.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "UIColor+YDDExtend.h"

@implementation UIColor (YDDExtend)


+ (UIColor *)lightColor:(UIColor *)lightColor darkColor:(nullable UIColor *)darkColor
{
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return darkColor ? darkColor : lightColor;
            }
            return lightColor;
        }];
    } else {
        return lightColor;
    }
    
}


@end
