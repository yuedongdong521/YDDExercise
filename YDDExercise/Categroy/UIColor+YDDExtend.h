//
//  UIColor+YDDExtend.h
//  YDDExercise
//
//  Created by ydd on 2021/2/1.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define UIColorLightAndDark(light, dark) [UIColor lightColor:light darkColor:dark]

@interface UIColor (YDDExtend)


+ (UIColor *)lightColor:(UIColor *)lightColor darkColor:(nullable UIColor *)darkColor;

@end

NS_ASSUME_NONNULL_END
