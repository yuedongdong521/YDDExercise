//
//  YDDMJGifFooter.m
//  YDDExercise
//
//  Created by ydd on 2021/4/15.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDMJGifFooter.h"

@implementation YDDMJGifFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
    [self setImages:loadingImages duration:1 forState:MJRefreshStateRefreshing];
}


@end
