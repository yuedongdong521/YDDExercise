//
//  YDDCustomButton.m
//  YDDExercise
//
//  Created by ydd on 2020/6/17.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDCustomButton.h"



@implementation YDDCustomButton

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
        [self addSubview:self.imageView];
        [self addSubview:self.titleLbale];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(-8, -8, 6, -8));
        }];
        [self.titleLbale mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.equalTo(self.imageView.mas_bottom).mas_offset(-7);
        }];
    }
    return self;
}



- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)titleLbale
{
    if (!_titleLbale) {
        _titleLbale = [[UILabel alloc] init];
        _titleLbale.font = kFontPFMedium(13);
        _titleLbale.textColor = [UIColor whiteColor];
        _titleLbale.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbale;
}


@end
