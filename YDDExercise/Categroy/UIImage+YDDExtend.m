//
//  UIImage+YDDExtend.m
//  Yddworkspace
//
//  Created by ydd on 2018/12/7.
//  Copyright © 2018 QH. All rights reserved.
//

#import "UIImage+YDDExtend.h"

static NSString* const kQRCodeFilterName = @"CIQRCodeGenerator";
static NSString* const kFilterKeyPath = @"inputMessage";
static NSString* const kInputCorrectionLevel = @"inputCorrectionLevel";

@implementation UIImage (ydd)
/**
  截取视频、动画等view 时用 layer渲染会导致画面布局异常，建议不用 layer 渲染。
  截取静态图片建议使用 layer 渲染。
 */
+ (UIImage*)screenShotView:(UIView*)view shotLayer:(BOOL)isShotLayer {
  UIGraphicsBeginImageContextWithOptions(view.frame.size, NO,
                                         [UIScreen mainScreen].scale);
  [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
  if (isShotLayer) {
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
  }
  UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

+ (UIImage*)mergeImageWithImages:(NSArray<UIImage*>*)images {
  CGFloat locationX = 0;
  CGFloat locationY = 0;
  CGSize mergedSize = CGSizeZero;

  for (int i = 0; i < images.count; i++) {
    UIImage* image = images[i];
    mergedSize = CGSizeMake(MAX(mergedSize.width, image.size.width),
                            mergedSize.height + image.size.height);
  }
  UIGraphicsBeginImageContext(mergedSize);
  for (int i = 0; i < images.count; i++) {
    UIImage* image = images[i];
    [image drawInRect:CGRectMake(locationX, locationY, image.size.width,
                                 image.size.height)];
    locationY += image.size.height;
  }
  UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

+ (UIImage*)createQrCodeImageWithQrContent:(NSString*)qrContent
                                    qrSize:(CGFloat)qrSize
                                   qrLevel:(NSString*)qrLevel
                                 logoImage:(UIImage*)logoImage
                             logoSizeScale:(CGFloat)logoSizeScale {
  // 创建过滤器
  CIFilter* filter = [CIFilter filterWithName:kQRCodeFilterName];

  // 过滤器恢复默认
  [filter setDefaults];

  // 将NSString格式转化成NSData格式
  NSData* data = [qrContent dataUsingEncoding:NSUTF8StringEncoding];
  [filter setValue:data forKeyPath:kFilterKeyPath];
  /*
   设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
   L　: 7%
   M　: 15%
   Q　: 25%
   H　: 30%
   */
  NSString* level = qrLevel ? qrLevel : @"H";
  [filter setValue:level forKey:kInputCorrectionLevel];
  // 获取二维码过滤器生成的二维码
  CIImage* outputImage = [filter outputImage];
  // 将获取到的二维码添加到imageview上
  if (!outputImage) {
    return nil;
  }
  UIImage* qrImage = [self createNonInterpolatedUIImageFormCIImage:outputImage
                                                          withSize:qrSize];
  if (!logoImage) {
    return qrImage;
  }
  UIImage* mergedImage =
      [self mergedImage:qrImage subImage:logoImage subLevel:logoSizeScale];
  return mergedImage;
}

+ (UIImage*)mergedImage:(UIImage*)image
               subImage:(UIImage*)subImage
               subLevel:(CGFloat)subLevel {
  CGSize mergedSize = image.size;
  UIGraphicsBeginImageContext(mergedSize);

  [image drawInRect:CGRectMake(0, 0, mergedSize.width, mergedSize.height)];
  CGFloat size = MIN(mergedSize.width * subLevel, mergedSize.height * subLevel);
  CGFloat scale = MIN(size / subImage.size.width, size / subImage.size.height);
  CGFloat logoWidth = scale * subImage.size.width;
  CGFloat logoHeight = scale * subImage.size.height;
  CGRect logoRect =
      CGRectMake((mergedSize.width - logoWidth) * 0.5,
                 (mergedSize.height - logoHeight) * 0.5, logoWidth, logoHeight);
  [subImage drawInRect:logoRect];
  UIImage* mergedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return mergedImage;
}

+ (UIImage*)createNonInterpolatedUIImageFormCIImage:(CIImage*)image
                                           withSize:(CGFloat)size {
  CGRect extent = CGRectIntegral(image.extent);
  CGFloat scale =
      MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));

  // 创建bitmap;
  size_t width = CGRectGetWidth(extent) * scale;
  size_t height = CGRectGetHeight(extent) * scale;
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
  CGContextRef bitmapRef = CGBitmapContextCreate(
      nil, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);

  CIContext* context = [CIContext contextWithOptions:nil];
  CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
  CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
  CGContextScaleCTM(bitmapRef, scale, scale);
  CGContextDrawImage(bitmapRef, extent, bitmapImage);

  // 保存bitmap到图片
  CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
  UIImage* finalmage = [UIImage imageWithCGImage:scaledImage];

  CGColorSpaceRelease(colorSpace);
  CGImageRelease(scaledImage);
  CGContextRelease(bitmapRef);
  CGImageRelease(bitmapImage);

  return finalmage;
}

+ (NSString*)scanCodeImage:(UIImage*)image {
  //
  if (!image) {
    return @"";
  }
  CIContext* context = [CIContext
      contextWithOptions:
          [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                      forKey:kCIContextUseSoftwareRenderer]];
  if (!context) {
    return @"";
  }
  CIDetector* detector = [CIDetector
      detectorOfType:CIDetectorTypeQRCode
             context:context
             options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
  CIImage* ciImage = [CIImage imageWithCGImage:image.CGImage];
  if (!ciImage) {
    return @"";
  }
  NSArray* features = [detector featuresInImage:ciImage];
  CIQRCodeFeature* feature = [features firstObject];
  if (!feature) {
    return @"";
  }
  NSString* message = feature.messageString;
  return message ? message : @"";
}

+ (UIImage *)ydd_imageWithColor:(UIColor *)color
{
    CGFloat imageW = 3;
    CGFloat imageH = 3;
    // 1.开启基于位图的图形上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), NO, 0.0);
    // 2.画一个color颜色的矩形框
    [color set];
    UIRectFill(CGRectMake(0, 0, imageW, imageH));
    
    // 3.拿到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}


/**生成纯色图片*/
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    size = CGSizeMake(size.width*[UIScreen mainScreen].scale, size.height*[UIScreen mainScreen].scale);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *myImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myImage;
}


+ (UIImage *)ydd_gradientColors:(NSArray*)colors
                   gradientType:(YDDGradientType)gradientType
                        imgSize:(CGSize)imgSize {
    
    if (colors.count < 1) {
        return [UIImage imageWithColor:[UIColor blackColor] size:imgSize];
    }
    
    if (colors.count == 1) {
        return [UIImage imageWithColor:colors.firstObject size:imgSize];
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (UIColor *c in colors) {
        [arr addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)arr, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case YDDGradientType_TopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        case YDDGradientType_LeftToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, 0.0);
            break;
        case YDDGradientType_UpleftToLowright:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, imgSize.height);
            break;
        case YDDGradientType_UprightToLowleft:
            start = CGPointMake(imgSize.width, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        case YDDGradientType_LowRightToUpLeft:
            start = CGPointMake(imgSize.width, imgSize.height);
            end = CGPointMake(0, 0);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end,kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    //CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)ydd_imageFromGradientColors:(NSArray*)colors
                            gradientType:(YDDGradientType)gradientType
                                 imgSize:(CGSize)imgSize
                              startPoint:(CGPoint)startPoint
                                endPoint:(CGPoint)endPoint {
    if (colors.count < 1) {
        return [UIImage imageWithColor:[UIColor blackColor] size:imgSize];
    }
    
    if (colors.count == 1) {
        return [UIImage imageWithColor:colors.firstObject size:imgSize];
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (UIColor *c in colors) {
        [arr addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)arr, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case YDDGradientType_TopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        case YDDGradientType_LeftToRight:
            start = startPoint;
            end = CGPointMake(imgSize.width+endPoint.x, endPoint.y);
            break;
        case YDDGradientType_UpleftToLowright:
            start = startPoint;
            end = CGPointMake(imgSize.width+endPoint.x, imgSize.height+endPoint.y);
            break;
        case YDDGradientType_UprightToLowleft:
            start = CGPointMake(imgSize.width+startPoint.x, startPoint.y);
            end = CGPointMake(endPoint.x, imgSize.height+endPoint.y);
            break;
        case YDDGradientType_LowRightToUpLeft:
            start = CGPointMake(imgSize.width+startPoint.x, imgSize.height+startPoint.y);
            end = CGPointMake(endPoint.x, endPoint.y);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end,kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    //CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)ydd_rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
        {
            rotate =M_PI_2;
            rect =CGRectMake(0,0,self.size.height, self.size.width);
            translateX=0;
            translateY= -rect.size.width;
            scaleY =rect.size.width/rect.size.height;
            scaleX =rect.size.height/rect.size.width;
        }
            break;
        case UIImageOrientationRight:
        {
            rotate =3 *M_PI_2;
            rect =CGRectMake(0,0,self.size.height, self.size.width);
            translateX= -rect.size.height;
            translateY=0;
            scaleY =rect.size.width/rect.size.height;
            scaleX =rect.size.height/rect.size.width;
        }
            break;
        case UIImageOrientationDown:
        {
            rotate =M_PI;
            rect =CGRectMake(0,0,self.size.width, self.size.height);
            translateX= -rect.size.width;
            translateY= -rect.size.height;
        }
            break;
        default:
        {
            rotate =0.0;
            rect =CGRectMake(0,0,self.size.width, self.size.height);
            translateX=0;
            translateY=0;
        }
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX,translateY);
    
    CGContextScaleCTM(context, scaleX,scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0,0,rect.size.width, rect.size.height), self.CGImage);
    
    UIImage *newPic =UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}


- (UIImage *)scallImageWidthScallSize:(CGSize)scallSize {
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = scallSize.width;
    CGFloat scaledHeight = scallSize.height;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (!CGSizeEqualToSize(self.size, scallSize))
    {
        CGFloat widthFactor = scaledWidth / width;
        CGFloat heightFactor = scaledHeight / height;
        
        scaleFactor = MAX(widthFactor, heightFactor);
        
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (scallSize.height - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (scallSize.width - scaledWidth) * 0.5;
        }
    }
    CGRect rect;
    rect.origin = thumbnailPoint;
    rect.size = CGSizeMake(scaledWidth, scaledHeight);
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  image;
}


- (UIImage *)ydd_cornerRadius:(CGFloat)radius
{
    CGRect rect = (CGRect){0.f, 0.f, self.size};
    UIGraphicsBeginImageContextWithOptions(self.size, NO,
                                           UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect
                                                cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



- (UIImage *)ydd_circleBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 1.加载原图
    UIImage *oldImage = self;
    // 2.开启上下文
    CGFloat imageW = oldImage.size.width + 2 * borderWidth;
    CGFloat imageH = oldImage.size.height + 2 * borderWidth;
    
    CGFloat size = imageW > imageH ? imageH : imageW;
    CGSize  imageSize = CGSizeMake(size, size);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    
    // 3.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = size * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)ydd_alpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    [self drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:alpha];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (CVPixelBufferRef)ydd_coverCVPixelBufferRef {
    CGSize size = self.size;
    size = CGSizeMake(720, 720/size.width*size.height);
    CGImageRef image = [self CGImage];
    
    BOOL hasAlpha = CGImageRefContainsAlpha(image);
    CFDictionaryRef empty = CFDictionaryCreate(kCFAllocatorDefault, NULL, NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             empty, kCVPixelBufferIOSurfacePropertiesKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, inputPixelFormat(), (__bridge CFDictionaryRef) options, &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    uint32_t bitmapInfo = bitmapInfoWithPixelFormatType(inputPixelFormat(), (bool)hasAlpha);
    
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width, size.height, 8, CVPixelBufferGetBytesPerRow(pxbuffer), rgbColorSpace, bitmapInfo);
    NSParameterAssert(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    return pxbuffer;
}

static OSType inputPixelFormat(){
    return kCVPixelFormatType_32BGRA;
}

static uint32_t bitmapInfoWithPixelFormatType(OSType inputPixelFormat, bool hasAlpha){
    
    if (inputPixelFormat == kCVPixelFormatType_32BGRA) {
        uint32_t bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host;
        if (!hasAlpha) {
            bitmapInfo = kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Host;
        }
        return bitmapInfo;
    }else if (inputPixelFormat == kCVPixelFormatType_32ARGB) {
        uint32_t bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big;
        return bitmapInfo;
    }else{
        NSLog(@"不支持此格式");
        return 0;
    }
}

// alpha的判断
BOOL CGImageRefContainsAlpha(CGImageRef imageRef) {
    if (!imageRef) {
        return NO;
    }
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    BOOL hasAlpha = !(alphaInfo == kCGImageAlphaNone ||
                      alphaInfo == kCGImageAlphaNoneSkipFirst ||
                      alphaInfo == kCGImageAlphaNoneSkipLast);
    return hasAlpha;
}


/// 数字机游戏结果图片
- (UIImage *)ydd_drawAttributes:(NSAttributedString *)attributes point:(CGPoint)point {
    
    if (attributes.length == 0) {
        return nil;
    }

   
    UIGraphicsBeginImageContextWithOptions(self.size,NO,0.0);
    
    [self drawAtPoint:CGPointMake(0,0)];
    // 获得一个位图图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawPath(context,kCGPathStroke);
    
    
    [attributes drawAtPoint:point];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)ydd_changeGray {
    if (@available(iOS 11.0, *)) {
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *superImage = [CIImage imageWithCGImage:self.CGImage];
        CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
        if (superImage) {
            [lighten setValue:superImage forKey:kCIInputImageKey];
        }

        // 修改亮度   -1---1   数越大越亮
        [lighten setValue:@(0) forKey:@"inputBrightness"];
        // 修改饱和度  0---2
        [lighten setValue:@(0) forKey:@"inputSaturation"];
        // 修改对比度  0---4
        [lighten setValue:@(1) forKey:@"inputContrast"];
        CIImage *result = [lighten valueForKey:kCIOutputImageKey];
        CGImageRef cgImage = [context createCGImage:result fromRect:[superImage extent]];
        UIImage *newImage =  [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        return newImage;
    }
    else {
        int width = self.size.width ;
        int height = self.size.height ;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray ();
        CGContextRef context = CGBitmapContextCreate ( nil , width, height, 8 , 0 , colorSpace, kCGImageAlphaPremultipliedLast );
        CGColorSpaceRelease (colorSpace);
        if (!context) {
            return nil;
        }
        CGContextDrawImage (context, CGRectMake ( 0 , 0 , width, height), self.CGImage );
        CGImageRef newImgRef = CGBitmapContextCreateImage (context);
        CGContextRelease (context);
        if (!newImgRef) {
            return nil;
        }
        UIImage *grayImage = [ UIImage imageWithCGImage:newImgRef];
        CGImageRelease (newImgRef);
        return grayImage;
    }
}



@end
