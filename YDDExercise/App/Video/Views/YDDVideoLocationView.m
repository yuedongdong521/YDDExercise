//
//  YDDVideoLocationView.m
//  YDDExercise
//
//  Created by ydd on 2020/6/18.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoLocationView.h"


@implementation YDDVideoLocationView

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
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgView];
        
        [self addSubview:self.locationImage];
        [self.locationImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.size.mas_equalTo(CGSizeMake(10, 12));
            make.centerY.equalTo(self);
        }];
        
        [self addSubview:self.locationName];
        [self.locationName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.locationImage.mas_right).mas_offset(3);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(17);
            make.width.mas_lessThanOrEqualTo(150);
        }];
        
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(6);
            make.centerY.equalTo(self);
            make.left.mas_equalTo(self.locationName.mas_right).mas_offset(5);
        }];
        
        [self addSubview:self.distance];
        [self.distance mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.mas_equalTo(self.lineView.mas_right).mas_offset(5);
            make.height.mas_equalTo(14);
        }];
        
//        [self addSubview:self.goView];
        
//        [self.goView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self);
//            make.left.mas_equalTo(self.distance.mas_right).mas_offset(5);
//            make.size.mas_equalTo(CGSizeMake(8, 8));
//        }];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(0);
            make.right.mas_equalTo(self.distance.mas_right).mas_offset(5);
        }];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
        
    }
    return self;
}

- (void)updateLocation:(NSString *)address distance:(NSString *)distance
{
    if ([address isEqualToString:@"火星"] || [distance isEqualToString:@"火星"]) {
        distance = @"";
        address = @"火星";
    }
    self.locationName.text = address;
    self.distance.text = distance;
    if (distance.length > 0) {
        self.lineView.hidden = NO;
        [self.distance mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.mas_equalTo(self.lineView.mas_right).mas_offset(5);
            make.height.mas_equalTo(14);
        }];
    } else {
        self.lineView.hidden = YES;
        [self.distance mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.mas_equalTo(self.locationName.mas_right).mas_offset(0);
            make.height.mas_equalTo(14);
        }];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (_tapBlock) {
        _tapBlock();
    }
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [_bgView cutRadius:2];
    }
    return _bgView;
}

- (UIImageView *)locationImage
{
    if (!_locationImage) {
        _locationImage = [[UIImageView alloc] init];
        _locationImage.contentMode = UIViewContentModeScaleAspectFit;
        _locationImage.clipsToBounds = YES;
        _locationImage.image = [UIImage imageNamed:@"homepage_location_icon"];
    }
    return _locationImage;
}

- (UILabel *)locationName
{
    if (!_locationName) {
        _locationName = [[UILabel alloc] init];
        _locationName.font = kFontPFMedium(12);
        _locationName.textColor = [UIColor colorWithWhite:1 alpha:0.9];
    }
    return _locationName;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorHexRGBA(0xEBEAE9, 0.5);
    }
    return _lineView;
}

- (UILabel *)distance
{
    if (!_distance) {
        _distance = [[UILabel alloc] init];
        _distance.font = kFontPFMedium(10);
        _distance.textColor = [UIColor colorWithWhite:1 alpha:0.5];
    }
    return _distance;
}

- (UIImageView *)goView
{
    if (!_goView) {
        _goView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homepage_location_arrow"]];
        _goView.contentMode = UIViewContentModeScaleAspectFit;
        _goView.clipsToBounds = YES;
    
    }
    return _goView;
}

@end
