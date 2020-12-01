//
//  NSObject+YDDExtend.h
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YDDExtend)

+(NSArray<NSString*>*)ydd_GetAllProperty:(id)object;
+ (void)ydd_GoThroughAllProperty:(id)object
                   propertyBlock:(void(^)(NSString *propertyName))propertyBlcok;

+ (id)ydd_readModelForKey:(NSString *)key;

- (void)ydd_writeModelForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
