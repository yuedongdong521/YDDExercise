//
//  YDDKeychainTool.h
//  YDDExercise
//
//  Created by ydd on 2021/5/10.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDDKeychainTool : NSObject

+ (instancetype)share;

- (void)setObject:(id)object forKey:(CFStringRef)key;

- (id)objectForKey:(CFStringRef)key;

@end

NS_ASSUME_NONNULL_END
