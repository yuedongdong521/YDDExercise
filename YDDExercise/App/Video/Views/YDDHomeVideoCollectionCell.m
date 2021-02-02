//
//  YDDHomeVideoCollectionCell.m
//  YDDExercise
//
//  Created by ydd on 2020/7/9.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDHomeVideoCollectionCell.h"

@implementation YDDHomeVideoCollectionCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.controlView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, kTabBarHeight, 0));
        }];
        
        CGRect audioViewFrame = self.audioAnimationView.frame;
        audioViewFrame.origin.y -= 49;
        self.audioAnimationView.frame = audioViewFrame;
    }
    return self;
}


@end
