//
//  YDDGCDQueue.h
//  YDDExercise
//
//  Created by ydd on 2021/5/10.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    YDDCGDQueueType_SERIAL = 0,
    YDDCGDQueueType_CONCURRENT,
} YDDCGDQueueType;

@interface YDDGCDQueue : NSObject

@property (nonatomic, strong, readonly) dispatch_queue_t queue;

@property (nonatomic, assign, readonly) YDDCGDQueueType queueType;

+ (instancetype)createQueueWithLabel:(const char *)label queueType:(YDDCGDQueueType)type;

- (instancetype)initWithLabel:(const char *)label queueType:(YDDCGDQueueType)type;

- (void)dispatchAsync:(void(^)(void))block;

- (void)dispatchSync:(void(^)(void))block;


@end

NS_ASSUME_NONNULL_END
