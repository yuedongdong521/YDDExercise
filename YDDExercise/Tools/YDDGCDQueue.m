//
//  YDDGCDQueue.m
//  YDDExercise
//
//  Created by ydd on 2021/5/10.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDGCDQueue.h"

@interface YDDGCDQueue ()
{
    void* _queueTag;
}

@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, assign) YDDCGDQueueType queueType;


@end

@implementation YDDGCDQueue

+ (instancetype)createQueueWithLabel:(const char *)label queueType:(YDDCGDQueueType)type
{
    YDDGCDQueue *queue = [[YDDGCDQueue alloc] initWithLabel:label queueType:type];
    return queue;
}

- (instancetype)initWithLabel:(const char *)label queueType:(YDDCGDQueueType)type
{
    self = [super init];
    if (self) {
        _queueType = type;
        
        dispatch_queue_attr_t attr = type == YDDCGDQueueType_SERIAL ? DISPATCH_QUEUE_SERIAL : DISPATCH_QUEUE_CONCURRENT;
        
        _queue = dispatch_queue_create(label, attr);
        
        _queueTag = &_queueTag;
        dispatch_queue_set_specific(_queue, _queueTag, _queueTag, NULL);
    }
    return self;
}

- (void)dispatchAsync:(void(^)(void))block
{
    if (!block) {
        return;
    }
    if (dispatch_get_specific(_queueTag)) {
        block();
    } else {
        dispatch_async(_queue, block);
    }
}

- (void)dispatchSync:(void(^)(void))block
{
    if (!block) {
        return;
    }
    if (dispatch_get_specific(_queueTag)) {
        block();
    } else {
        dispatch_sync(_queue, block);
    }
}


@end
