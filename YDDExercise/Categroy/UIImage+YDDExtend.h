//
//  UIImage+YDDExtend.h
//  Yddworkspace
//
//  Created by ydd on 2018/12/7.
//  Copyright © 2018 QH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YDDGradientType) {
    YDDGradientType_TopToBottom = 0,//从上到下
    YDDGradientType_LeftToRight = 1,//从左到右
    YDDGradientType_UpleftToLowright = 2,//左上到右下
    YDDGradientType_UprightToLowleft = 3,//右上到左下
    YDDGradientType_LowRightToUpLeft = 4,//右下到左上
};


@interface UIImage (ydd)
/**
 截取视频、动画等view 时用 layer渲染会导致画面布局异常，建议不用 layer 渲染。
 截取静态图片建议使用 layer 渲染。
 */
+ (UIImage*)screenShotView:(UIView*)view shotLayer:(BOOL)isShotLayer;
+ (UIImage*)mergeImageWithImages:(NSArray<UIImage*>*)images;
/**
 生成二维码
 
 
 */
+ (UIImage*)createQrCodeImageWithQrContent:(NSString*)qrContent
                                    qrSize:(CGFloat)qrSize
                                   qrLevel:(NSString*)qrLevel
                                 logoImage:(UIImage*)logoImage
                             logoSizeScale:(CGFloat)logoSizeScale;
+ (NSString*)scanCodeImage:(UIImage*)image;


/// 生成3*3的纯色图
/// @param color <#color description#>
+ (UIImage *)ydd_imageWithColor:(UIColor *)color;


/// 生成纯色图片
/// @param color <#color description#>
/// @param size <#size description#>
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/// 生成渐变图片
+ (UIImage *)ydd_gradientColors:(NSArray*)colors
                   gradientType:(YDDGradientType)gradientType
                        imgSize:(CGSize)imgSize;

/// 生成渐变色图片
/// @param colors <#colors description#>
/// @param gradientType <#gradientType description#>
/// @param imgSize <#imgSize description#>
/// @param startPoint <#startPoint description#>
/// @param endPoint <#endPoint description#>
+ (UIImage *)ydd_imageFromGradientColors:(NSArray*)colors
                            gradientType:(YDDGradientType)gradientType
                                 imgSize:(CGSize)imgSize
                              startPoint:(CGPoint)startPoint
                                endPoint:(CGPoint)endPoint;

/// 调整图片方向
/// @param orientation <#orientation description#>
- (UIImage *)ydd_rotation:(UIImageOrientation)orientation;

/// 缩放图片
/// @param scallSize <#scallSize description#>
- (UIImage *)scallImageWidthScallSize:(CGSize)scallSize;

/// 对图片切圆角
/// @param radius <#radius description#>
- (UIImage *)ydd_cornerRadius:(CGFloat)radius;

/// 切圆角 带边框
/// @param borderWidth <#borderWidth description#>
/// @param borderColor <#borderColor description#>
- (UIImage *)ydd_circleBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/// 修改图片透明通道
/// @param alpha <#alpha description#>
- (UIImage *)ydd_alpha:(CGFloat)alpha;

/// 图片转 rgba buffer
- (CVPixelBufferRef)ydd_coverCVPixelBufferRef;

/// 在图片上添加文字
/// @param attributes <#attributes description#>
/// @param point <#point description#>
- (UIImage *)ydd_drawAttributes:(NSAttributedString *)attributes point:(CGPoint)point;

/// 将图片变成灰度图
- (UIImage *)ydd_changeGray;

@end

NS_ASSUME_NONNULL_END
