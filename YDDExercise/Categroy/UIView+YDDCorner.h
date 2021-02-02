//
//  UIView+YDDCorner.h
//  YDDExercise
//
//  Created by ydd on 2021/1/28.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YDDCornerStyle) {
    YDDCornerStyle_LeftTop = 1 << 0,
    YDDCornerStyle_RightTop = 1 << 1,
    YDDCornerStyle_LeftBottom = 1 << 2,
    YDDCornerStyle_RightBottom = 1 << 3,
    YDDCornerStyle_all = 1 << 4
};


@interface UIView (YDDCorner)

- (void)cutCorners:(YDDCornerStyle)cornerType radius:(CGFloat)radius color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
