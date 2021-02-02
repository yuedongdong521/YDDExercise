//
//  YDDTabBarBgView.m
//  YDDExercise
//
//  Created by ydd on 2021/2/2.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDTabBarBgView.h"

@implementation YDDTabBarBgView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}


- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
    }
    return _lineView;
}




@end
