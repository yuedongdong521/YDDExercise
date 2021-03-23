//
//  YDDProxy.m
//  YDDExercise
//
//  Created by ydd on 2021/3/17.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDProxy.h"

@interface YDDProxy ()

@property (nonatomic, weak) id weakTarget;

@end

@implementation YDDProxy

+ (instancetype)ydd_proxyWithTarget:(id)target {
    
    YDDProxy *proxy = [YDDProxy alloc];
    proxy.weakTarget = target;
    return proxy;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:self.weakTarget];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.weakTarget methodSignatureForSelector:sel];
}

@end
