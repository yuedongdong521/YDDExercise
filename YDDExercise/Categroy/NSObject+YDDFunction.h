//
//  NSObject+YDDFunction.h
//  YDDExercise
//
//  Created by ydd on 2021/6/1.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YDDFunction)

@property (nonatomic, copy) void(^back)(void);


/// 防抖动， 在time时间间隔内响应最后一次，在间隔时间内调用充值间隔时间
/// @param time 间隔时间
/// @param back <#back description#>
- (void)debounce:(CGFloat)time back:(void(^)(void))back;

/// 节流
/// @param time <#time description#>
/// @param back <#back description#>
- (void)throttle:(CGFloat)time back:(void(^)(void))back;

@end

NS_ASSUME_NONNULL_END
