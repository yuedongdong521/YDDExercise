//
//  YDDHomeCollectionViewCell.m
//  YDDExercise
//
//  Created by ydd on 2019/7/23.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "YDDHomeCollectionViewCell.h"
#import "YDDHomeModel.h"
#import "UIView+YDDCorner.h"
@interface YDDHomeCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *label;

@end

@implementation YDDHomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, kLabelHeight, 0));
        }];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageView.mas_bottom);
            make.left.right.bottom.mas_equalTo(0);
        }];
        
//        [self.imageView cutRadius:10];
        [self.imageView cutCorners:YDDCornerStyle_all radius:10 color:[UIColor whiteColor]];
    }
    return self;
}

- (void)setModel:(YDDHomeModel *)model
{
    if (_model != model) {
        _model = model;
    }
    
    [_imageView yy_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholder:kImagePlaceholder];
    _label.text = model.name;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [UILabel ydd_labelAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14] text:nil];
    }
    return _label;
}

@end
