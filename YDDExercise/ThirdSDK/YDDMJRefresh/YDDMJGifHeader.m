//
//  YDDMJGifHeader.m
//  YDDExercise
//
//  Created by ydd on 2021/4/15.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDMJGifHeader.h"

@implementation YDDMJGifHeader

- (void)prepare
{
    [super prepare];
    
    NSMutableArray *loadingImages = [NSMutableArray array];
    for (int i = 0; i < 24; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pullRefresh%d", i]];
        if (image) {
            [loadingImages addObject:image];
        }
    }
    //
    UIImage *normalImage = loadingImages.firstObject;
    if (normalImage) {
        NSArray *normalImages = [NSArray arrayWithObjects:normalImage, nil];
        [self setImages:normalImages forState:MJRefreshStateIdle];
        [self setImages:normalImages forState:MJRefreshStatePulling];
    }
    //
    [self setImages:loadingImages duration:1 forState:MJRefreshStateRefreshing];
}


@end
