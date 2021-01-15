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

- (NSString *)ydd_subStringToByteIndex:(NSInteger)index;

- (NSString *)ydd_subStringFormByteIndex:(NSInteger)index;

- (NSURL *)ydd_coverUrl;

- (CGSize)ydd_textSize:(CGSize)maxSize font:(UIFont *)font;

+ (NSString *)ydd_pathForDocumentWithDirName:(NSString *)dirName fileName:(nullable NSString *)fileName;

+ (YDDNumber)ydd_maxFourNum:(NSInteger)num;

/// 筛选正则匹配的内容
/// @param regexStr 正则表达式
- (NSString *)ydd_filterWithRegex:(NSString *)regexStr;

/// 筛选中国人名（汉字，少数名族名字包含 ∙ ）
- (NSString *)ydd_filterChinesName;

@end

NS_ASSUME_NONNULL_END
