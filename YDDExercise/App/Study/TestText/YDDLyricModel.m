//
//  YDDLyricModel.m
//  YDDExercise
//
//  Created by ydd on 2021/1/22.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDLyricModel.h"

@implementation YDDLyricModel

- (CGFloat)speed
{
    if (self.duration > 0) {
        return 0.1 / self.duration;
    }
    return 0;
}


@end
