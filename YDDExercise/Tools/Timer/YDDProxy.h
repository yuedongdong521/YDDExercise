//
//  YDDProxy.h
//  YDDExercise
//
//  Created by ydd on 2021/3/17.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDDProxy : NSProxy

+ (instancetype)ydd_proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
