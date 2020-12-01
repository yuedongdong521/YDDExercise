//
//  NSString+YDDExtend.m
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "NSString+YDDExtend.h"

@implementation NSString (YDDExtend)


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


+ (NSString *)getPathForDocumentWithDirName:(NSString *)dirName fileName:(NSString *)fileName
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSFileManager *manager = [NSFileManager defaultManager];
    path = [path stringByAppendingPathComponent:dirName];
    BOOL isDir = NO;
    BOOL isEx = [manager fileExistsAtPath:path isDirectory:&isDir];
    if (!isDir || !isEx) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (!fileName) {
        fileName = [NSString stringWithFormat:@"%lu.png", (NSUInteger)[[NSDate date] timeIntervalSince1970] * 1000];
    }
    
    return [path stringByAppendingPathComponent:fileName];
}

@end
