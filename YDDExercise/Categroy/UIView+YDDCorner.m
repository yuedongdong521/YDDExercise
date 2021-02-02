//
//  UIView+YDDCorner.m
//  YDDExercise
//
//  Created by ydd on 2021/1/28.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "UIView+YDDCorner.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, YDDCornerType) {
    YDDCornerType_LeftTop,
    YDDCornerType_RightTop,
    YDDCornerType_LeftBottom,
    YDDCornerType_RightBottom,
};

@interface YDDCornerModel : NSObject

@property (nonatomic, strong) CAShapeLayer *layer;

@property (nonatomic, assign) YDDCornerType type;

@property (nonatomic, assign) CGFloat radius;

@end

@implementation YDDCornerModel


- (CAShapeLayer *)layer
{
    if (!_layer) {
        _layer = [[CAShapeLayer alloc] init];
    }
    return _layer;
}

- (void)setCornerType:(YDDCornerType)type radius:(CGFloat)radius color:(UIColor *)color
{
    _type = type;
    _radius = radius;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    switch (type) {
        case YDDCornerType_LeftTop:
            [path moveToPoint:CGPointMake(radius, 0)];
            [path addLineToPoint:CGPointMake(0, 0)];
            [path addLineToPoint:CGPointMake(0, radius)];
            [path addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI endAngle:M_PI * 1.5 clockwise:YES];
            [path closePath];
            break;
        case YDDCornerType_RightTop:
            [path moveToPoint:CGPointMake(0, 0)];
            [path addLineToPoint:CGPointMake(radius, 0)];
            [path addLineToPoint:CGPointMake(radius, radius)];
            /// clockwise ：YES 顺时针， NO 逆时针
            [path addArcWithCenter:CGPointMake(0, radius) radius:radius startAngle:2 * M_PI endAngle:1.5 * M_PI clockwise:NO];
            [path closePath];
            break;
            
        case YDDCornerType_LeftBottom:
            [path moveToPoint:CGPointMake(0, 0)];
            [path addLineToPoint:CGPointMake(0, radius)];
            [path addLineToPoint:CGPointMake(radius, radius)];
            [path addArcWithCenter:CGPointMake(radius, 0) radius:radius startAngle:0.5 * M_PI endAngle:M_PI clockwise:YES];
            [path closePath];
            break;
        case YDDCornerType_RightBottom:
            [path moveToPoint:CGPointMake(0, radius)];
            [path addLineToPoint:CGPointMake(radius, radius)];
            [path addLineToPoint:CGPointMake(radius, 0)];
            [path addArcWithCenter:CGPointMake(0, 0) radius:radius startAngle:0 endAngle:0.5 * M_PI clockwise:YES];
            [path closePath];
            break;
        default:
            break;
    }
    
    self.layer.path = path.CGPath;
    self.layer.fillColor = color.CGColor;
    self.layer.strokeColor = [UIColor clearColor].CGColor;
    
    
}


@end


const void* _cornerArr;

const void* _cornerRadius;

@implementation UIView (YDDCorner)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod([self class], @selector(layoutSubviews));
        Method cornerMethod = class_getInstanceMethod([self class], @selector(cornerLayoutSubviews));
        
        method_exchangeImplementations(originMethod, cornerMethod);
        
    });
}


- (void)cornerLayoutSubviews
{
    [self cornerLayoutSubviews];
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
    NSArray <YDDCornerModel *>* arr = [self cornerArr];
    [arr enumerateObjectsUsingBlock:^(YDDCornerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (obj.type) {
            case YDDCornerType_LeftTop:
                obj.layer.frame = CGRectMake(0, 0, obj.radius, obj.radius);
                break;
            case YDDCornerType_RightTop:
                obj.layer.frame = CGRectMake(w - obj.radius, 0, obj.radius, obj.radius);
                break;
            case YDDCornerType_LeftBottom:
                obj.layer.frame = CGRectMake(0, h - obj.radius, obj.radius, obj.radius);
                break;
            case YDDCornerType_RightBottom:
                obj.layer.frame = CGRectMake(w - obj.radius, h - obj.radius, obj.radius, obj.radius);
                break;
            default:
                break;
        }
    }];
    
    
}


- (void)cutCorners:(YDDCornerStyle)cornerType radius:(CGFloat)radius color:(UIColor *)color
{
    if (radius <= 0) {
        [self clearLayer];
        return;
    }
    
    NSMutableArray *arry = [NSMutableArray array];
    
    if ((cornerType & YDDCornerStyle_LeftTop) || (cornerType & YDDCornerStyle_all)) {
        YDDCornerModel *mode = [[YDDCornerModel alloc] init];
        [self.layer addSublayer:mode.layer];
        [mode setCornerType:YDDCornerType_LeftTop radius:radius color:color];
        [arry addObject:mode];
    }
    
    if ((cornerType & YDDCornerStyle_LeftBottom) || (cornerType & YDDCornerStyle_all)) {
        YDDCornerModel *mode = [[YDDCornerModel alloc] init];
        [self.layer addSublayer:mode.layer];
        [mode setCornerType:YDDCornerType_LeftBottom radius:radius color:color];
        [arry addObject:mode];
    }
    
    if ((cornerType & YDDCornerStyle_RightTop) || (cornerType & YDDCornerStyle_all)) {
        YDDCornerModel *mode = [[YDDCornerModel alloc] init];
        [self.layer addSublayer:mode.layer];
        [mode setCornerType:YDDCornerType_RightTop radius:radius color:color];
        [arry addObject:mode];
    }
    
    if ((cornerType & YDDCornerStyle_RightBottom) || (cornerType & YDDCornerStyle_all)) {
        YDDCornerModel *mode = [[YDDCornerModel alloc] init];
        [self.layer addSublayer:mode.layer];
        [mode setCornerType:YDDCornerType_RightBottom radius:radius color:color];
        [arry addObject:mode];
    }
    
    [self setCornerArr:arry];
}

- (void)clearLayer
{
    NSArray <YDDCornerModel*>* arr = [self cornerArr];
    [arr enumerateObjectsUsingBlock:^(YDDCornerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.layer.superlayer) {
            [obj.layer removeFromSuperlayer];
        }
    }];
    [self setCornerArr:nil];
}
- (NSArray *)cornerArr
{
    id arr = objc_getAssociatedObject(self, _cornerArr);
    if ([arr isKindOfClass:[NSArray class]]) {
        return (NSArray *)arr;
    }
    return nil;
}

- (void)setCornerArr:(NSArray *)arr
{
    objc_setAssociatedObject(self, _cornerArr, arr, OBJC_ASSOCIATION_COPY);
}

- (CGFloat)cornerRadius
{
    id radius = objc_getAssociatedObject(self, _cornerRadius);
    if (radius) {
        return [objc_getAssociatedObject(self, _cornerRadius) floatValue];
    }
    return 0;
}

- (void)setCornerRadius:(CGFloat)radius
{
    objc_setAssociatedObject(self, _cornerRadius, @(radius), OBJC_ASSOCIATION_ASSIGN);
}

@end
