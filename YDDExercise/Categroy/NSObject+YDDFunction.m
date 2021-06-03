//
//  NSObject+YDDFunction.m
//  YDDExercise
//
//  Created by ydd on 2021/6/1.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "NSObject+YDDFunction.h"
#import <objc/runtime.h>

static const void *kback = &kback;

@implementation NSObject (YDDFunction)

- (void)debounce:(CGFloat)time back:(void(^)(void))back
{
    self.back = back;
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayDebounce) object:nil];
    [self performSelector:@selector(delayDebounce) afterDelay:time];
}

- (void)delayDebounce
{
    if (self.back) {
        self.back();
    }
}

- (void(^)(void))back {
    id back = objc_getAssociatedObject(self, kback);
    return back;
}


- (void)setBack:(void (^)(void))back
{
    objc_setAssociatedObject(self, kback, back, OBJC_ASSOCIATION_COPY);
}


- (void)throttle:(CGFloat)time back:(void(^)(void))back
{
    static NSInteger count = 0;
    if (count != 0) {
        return;
    }
    count++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (back) {
            back();
        }
        count = 0;
    });
}




@end
