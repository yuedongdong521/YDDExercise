//
//  NSString+YDDExtend.h
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct YDDNumber {
    NSString *value;
    NSString *unit;
};
typedef struct YDDNumber YDDNumber;

@interface NSString (YDDExtend)


/// 将数字转成四位数
/// @param num <#num description#>
+ (YDDNumber)ydd_maxFourNum:(NSInteger)num;

/// 截取指定字节长度
- (NSString *)ydd_subStringToByteIndex:(NSInteger)index;

/// 从指定字节长度开始截取
- (NSString *)ydd_subStringFormByteIndex:(NSInteger)index;

/// 转换url
- (NSURL *)ydd_coverUrl;

- (CGSize)ydd_textSize:(CGSize)maxSize font:(UIFont *)font;

/// 筛选正则匹配的内容
/// @param regexStr 正则表达式
- (NSString *)ydd_filterWithRegex:(NSString *)regexStr;

/// 筛选中国人名（汉字，少数名族名字包含 ∙ ）
- (NSString *)ydd_filterChinesName;

/// 验证6-18位同时包含数字、大小写字母密码
- (BOOL)ydd_judgePassWordRegex;

@end

NS_ASSUME_NONNULL_END
