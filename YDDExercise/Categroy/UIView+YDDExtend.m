//
//  UIView+YDDExtend.m
//  YDDExercise
//
//  Created by ydd on 2019/7/20.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "UIView+YDDExtend.h"

@implementation UIView (YDDExtend)

- (void)cutRadius:(CGFloat)radius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

- (void)cutRadius:(CGFloat)radius
      borderWidth:(CGFloat)borderWidth
      borderColor:(UIColor *)borderColor
{
    [self cutRadius:radius];
    [self setBorderWidth:borderWidth
             borderColor:borderColor];
    
}

- (void)setBorderWidth:(CGFloat)borderWidth
           borderColor:(UIColor *)borderColor
{
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)cutRoundingCorners:(UIRectCorner)corner radius:(CGFloat)radius
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setGradientColors:(NSArray <UIColor*>*)colors
{
    [self setGradientColors:colors locations:nil
                 startPoint:CGPointZero
                   endPoint:CGPointZero];
}

- (void)setGradientColors:(NSArray <UIColor*>*)colors
                locations:(NSArray <NSNumber*>*)locations
{
    [self setGradientColors:colors locations:locations
                 startPoint:CGPointZero
                   endPoint:CGPointZero];
}

- (void)setGradientColors:(NSArray <UIColor*>*)colors
                locations:(NSArray <NSNumber*>*)locations
               startPoint:(CGPoint)startPoint
                 endPoint:(CGPoint)endPoint
{
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    NSMutableArray *mutArr = [NSMutableArray array];
    NSMutableArray *mutLocations = locations.count > 0 ? nil : [NSMutableArray array];
    CGFloat count = (CGFloat)colors.count;
    [colors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [mutArr addObject:(__bridge id)obj.CGColor];
        [mutLocations addObject:@(idx / count)];
    }];
    layer.colors = mutArr;
   
    layer.locations = mutLocations != nil ? mutLocations : locations;
    startPoint = CGPointEqualToPoint(startPoint, CGPointZero) ? CGPointMake(0, 1) : startPoint;
    layer.startPoint = startPoint;
    endPoint = CGPointEqualToPoint(endPoint, CGPointZero) ? CGPointMake(1, 1) : endPoint;
    layer.endPoint = endPoint;
    [self.layer insertSublayer:layer atIndex:0];
}

- (UIViewController *)superViewController
{
    UIResponder *nextResponder = self.nextResponder;
    while (nextResponder) {
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
        nextResponder = nextResponder.nextResponder;
    }
    return nil;
}

@end
