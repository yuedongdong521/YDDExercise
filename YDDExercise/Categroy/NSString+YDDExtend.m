//
//  NSString+YDDExtend.m
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "NSString+YDDExtend.h"

@implementation NSString (YDDExtend)

+ (YDDNumber)ydd_maxFourNum:(NSInteger)num
{
    YDDNumber number = {@"0", @""};
    if (num < 1e4) {
        number.value = [NSString stringWithFormat:@"%ld", (long)num];
        number.unit = @"";
        return number;
    }
    NSDecimalNumber *decNum = [[NSDecimalNumber alloc] initWithInteger:num];
    NSDecimalNumber *num1 = [[NSDecimalNumber alloc] initWithDouble:1e4];
    
    NSDecimalNumber *valueNum = [decNum decimalNumberByDividingBy:num1];

    
    CGFloat value = valueNum.floatValue;
    if (value < 1e4) {
        number.value = [self subFourNumber:valueNum];
        number.unit = @"万";
        return number;
    }
    
    NSDecimalNumber *num2 = [[NSDecimalNumber alloc] initWithDouble:1e8];
    valueNum = [decNum decimalNumberByDividingBy:num2];
    
    value = valueNum.floatValue;
    if (value < 1e4) {
        number.value = [self subFourNumber:valueNum];
        number.unit = @"亿";
        return number;
    }
    
    number.value = [NSString stringWithFormat:@"%ld", (long)[valueNum integerValue]];
    number.unit = @"亿";
    return number;
}

+ (NSString *)subFourNumber:(NSDecimalNumber *)number
{
    CGFloat value = [number floatValue];
    
    NSString *result = @"";
    if (value >= 1e3) {
        result = [self decimalWithDeciNum:number scale:0];
    } else if (value >= 1e2) {
        result = [self decimalWithDeciNum:number scale:1];
    } else if (value >= 1e1) {
        result = [self decimalWithDeciNum:number scale:2];
    } else {
        result = [self decimalWithDeciNum:number scale:3];
    }
    return result;
}


+ (NSString *)decimalWithDeciNum:(NSDecimalNumber *)num scale:(short)scale
{
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *newNum = [num decimalNumberByRoundingAccordingToBehavior:behavior];
    return [newNum stringValue];
}



/// 截取指定字节长度
- (NSString *)ydd_subStringToByteIndex:(NSInteger)index
{
    NSInteger sum = 0;
    NSString *subStr = [[NSString alloc] init];
    for(int i = 0; i<[self length]; i++){
        unichar strChar = [self characterAtIndex:i];
        if(strChar < 256){
            sum += 1;
        }
        else {
            sum += 2;
        }
        if (sum > index) {
            subStr = [self substringToIndex:i];
            return subStr;
        }
    }
    return self;
}

/// 从指定字节长度开始截取
- (NSString *)ydd_subStringFormByteIndex:(NSInteger)index
{
    NSInteger sum = 0;
    NSString *subStr = [[NSString alloc] init];
    for(int i = 0; i<[self length]; i++){
        unichar strChar = [self characterAtIndex:i];
        if(strChar < 256){
            sum += 1;
        }
        else {
            sum += 2;
        }
        if (sum > index) {
            subStr = [self substringFromIndex:i];
            return subStr;
        }
    }
    return self;
}


- (NSURL *)ydd_coverUrl
{
    if (self.length == 0) {
        return nil;
    }
    if ([self hasPrefix:@"http:"] || [self hasPrefix:@"https:"]) {
        return [NSURL URLWithString:self];
    } else {
        NSURL *url = [NSURL fileURLWithPath:self];
        if (url) {
            return url;
        }
    }
    if ([self hasPrefix:@"file"] || [self containsString:@"/users/"]) {
        return [NSURL fileURLWithPath:self];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:self ofType:@""];
    if (path) {
        return [NSURL fileURLWithPath:path];
    }
    return nil;
}

- (CGSize)ydd_textSize:(CGSize)maxSize font:(UIFont *)font
{
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName : font}];
    return [att boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
}


- (NSString *)ydd_filterWithRegex:(NSString *)regexStr
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length) withTemplate:@""];
    return result;
}

/// 筛选中国人名（汉字，少数名族名字包含 ∙ ）
- (NSString *)ydd_filterChinesName
{
    return [self ydd_filterWithRegex:@"[^\u4e00-\u9fa5∙•· ]"];
}

/// 验证6-18位同时包含数字、大小写字母密码
- (BOOL)ydd_judgePassWordRegex
{
    BOOL result ;
    // 判断长度大于6位后再接着判断是否同时包含数字和大小写字母
    NSString * regex =@"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,18}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:self];
    return result;
}




@end
