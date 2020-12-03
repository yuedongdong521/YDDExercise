//
//  YDDDefine.h
//  YDDExercise
//
//  Created by ydd on 2020/12/3.
//  Copyright © 2020 ydd. All rights reserved.
//

#ifndef YDDDefine_h
#define YDDDefine_h


#define weakObj(obj) __weak typeof(obj) weak##obj = obj
#define strongObj(type,obj) __strong typeof(type) strong##type = obj

#define ScreenScale [UIScreen mainScreen].scale
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height
#define ScreenWidth   [UIScreen mainScreen].bounds.size.width
#define ViewX(view) view.frame.origin.x
#define ViewY(view) view.frame.origin.y
#define ViewW(view) view.frame.size.width
#define ViewH(view) view.frame.size.height


#define kNavBarHeight (IS_iPhoneX ? 88 : 64)
#define kSafeBottom (IS_iPhoneX ? 34 : 0)
#define kSafeTop (IS_iPhoneX ? 44 : 0)

#define kTabBarHeight (49 + kSafeBottom)

#define UIColorHexRGBA(rgb,a) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0x00FF00) >> 8))/255.0 blue:((float)(rgb & 0x0000FF))/255.0 alpha:((float)a)]


#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0 && IS_IPHONE;\
}\
(isPhoneX);})

#define kHeadIconDefault [UIImage imageNamed:@"headIcon"]
#define kImagePlaceholder [UIImage imageNamed:@"defaultIcon"]


//================ 字体 ================//
//   苹方-简 常规体
//　　font-family: PingFangSC-Regular, sans-serif;
//　　苹方-简 极细体
//　　font-family: PingFangSC-Ultralight, sans-serif;
//　　苹方-简 细体
//　　font-family: PingFangSC-Light, sans-serif;
//　　苹方-简 纤细体
//　　font-family: PingFangSC-Thin, sans-serif;
//　　苹方-简 中黑体
//　　font-family: PingFangSC-Medium, sans-serif;
//　　苹方-简 中粗体
//　　font-family: PingFangSC-Semibold, sans-serif;
/// 苹方-简 常规体
#define kFontPF(f) [UIFont fontWithName:@"PingFangSC-Regular" size:f]
/// 苹方-简 中黑体
#define kFontPFMedium(f) [UIFont fontWithName:@"PingFangSC-Medium" size:f]
/// 苹方-简 中粗体
#define kFontPFSemibold(f) [UIFont fontWithName:@"PingFangSC-Semibold" size:f]

#endif /* YDDDefine_h */
