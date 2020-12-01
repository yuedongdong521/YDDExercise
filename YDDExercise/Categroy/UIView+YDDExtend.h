//
//  UIView+YDDExtend.h
//  YDDExercise
//
//  Created by ydd on 2019/7/20.
//  Copyright © 2019 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (YDDExtend)

- (void)cutRadius:(CGFloat)radius;

- (void)cutRadius:(CGFloat)radius
      borderWidth:(CGFloat)borderWidth
      borderColor:(UIColor *)borderColor;

- (void)setBorderWidth:(CGFloat)borderWidth
           borderColor:(UIColor *)borderColor;

- (void)cutRoundingCorners:(UIRectCorner)corner
                    radius:(CGFloat)radius;


- (void)setGradientColors:(NSArray <UIColor*>*)colors;

- (void)setGradientColors:(NSArray <UIColor*>*)colors
                locations:(nullable NSArray <NSNumber*>*)locations;

- (void)setGradientColors:(NSArray <UIColor*>*)colors
                locations:(nullable NSArray <NSNumber*>*)locations
               startPoint:(CGPoint)startPoint
                 endPoint:(CGPoint)endPoint;

- (UIViewController *)superViewController;

@end

NS_ASSUME_NONNULL_END
