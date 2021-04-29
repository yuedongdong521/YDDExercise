//
//  YDDIBDebugView.m
//  YDDExercise
//
//  Created by ydd on 2021/4/19.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDIBDebugView.h"
IB_DESIGNABLE
@implementation YDDIBDebugView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIView *cView = [[UIView alloc] init];
        [self addSubview:cView];
        cView.backgroundColor = [UIColor redColor];
        
        [cView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        
    }
    return self;
}


@end
