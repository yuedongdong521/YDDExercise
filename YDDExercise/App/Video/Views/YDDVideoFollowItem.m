//
//  YDDVideoFollowItem.m
//  YDDExercise
//
//  Created by ydd on 2020/6/19.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoFollowItem.h"


@implementation YDDVideoFollowItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:self.label];
        [self addSubview:self.imageView];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(4);
            make.bottom.mas_equalTo(-4);
            make.left.mas_equalTo(10);
        }];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
    }
    return self;
}

- (void)updateNum:(NSInteger)num
{
    self.label.text = [NSString stringWithFormat:@"%ld个直播", (long)num];
    
    [self.label sizeToFit];
    
    CGFloat w = self.label.frame.size.width;
    if (!self.superview) {
        return;
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(w + 20 + 4 + 10);
    }];
    
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = kFontPFMedium(12);
        _label.textColor = [UIColor colorWithWhite:1 alpha:0.8];
        _label.textAlignment = NSTextAlignmentRight;
    }
    return _label;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_commet_spread_arrow"]];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}



@end
