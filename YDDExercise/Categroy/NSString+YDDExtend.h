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

+ (NSString *)getPathForDocumentWithDirName:(NSString *)dirName fileName:(nullable NSString *)fileName;

+ (YDDNumber)maxFourNum:(NSInteger)num;

@end

NS_ASSUME_NONNULL_END
