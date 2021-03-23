//
//  YDDProxyObj.m
//  YDDExercise
//
//  Created by ydd on 2021/3/17.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDProxyObj.h"

@interface YDDProxyObj ()

@property (nonatomic, weak) id weakTarget;

@end

@implementation YDDProxyObj

+ (instancetype)ydd_proxyWithTarget:(id)target {
    YDDProxyObj *obj = [[YDDProxyObj alloc] init];
    obj.weakTarget = target;
    return obj;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.weakTarget;
}


@end
