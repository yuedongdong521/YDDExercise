//
//  YDDVideoAnchorCell.m
//  YDDExercise
//
//  Created by ydd on 2020/6/19.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoAnchorCell.h"


@implementation YDDVideoAnchorCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.animationView];
    
        [self addSubview:self.headBord];
        
        [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(4);
            make.width.height.mas_equalTo(56);
            make.centerX.equalTo(self);
        }];
        
        [self.headBord mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(4);
            make.width.height.mas_equalTo(56);
            make.centerX.equalTo(self);
        }];
        
        
        [self addSubview:self.headImage];
    
        [self addSubview:self.descLabel];
        
        [self addSubview:self.nameLabel];
        
        
        [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(52);
            make.center.equalTo(self.headBord);
        }];
        
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 14));
            make.top.mas_equalTo(self.headBord.mas_bottom).mas_offset(-10);
            make.centerX.equalTo(self.headBord);
        }];
        
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(2);
            make.right.mas_equalTo(-2);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(17);
        }];
    }
    return self;
}

- (void)startAnimation
{
    [self removeAnimation];
    
    CAKeyframeAnimation *headAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    headAnimation.duration = 1;
    headAnimation.repeatCount = MAXFLOAT;
    headAnimation.values = @[@(1.0), @(0.85), @(1.0)];
    [self.headImage.layer addAnimation:headAnimation forKey:@"headscale-animation"];
    
    CAKeyframeAnimation *boxAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    boxAnimation.duration = 1;
    boxAnimation.repeatCount = MAXFLOAT;
    boxAnimation.values = @[@(1.0), @(1.15), @(1.0)];
    [self.animationView.layer addAnimation:boxAnimation forKey:@"boxscale-animation"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

- (void)removeAnimation
{
    [_headImage.layer removeAnimationForKey:@"headscale-animation"];
    [_animationView.layer removeAnimationForKey:@"boxscale-animation"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)updateModel:(YDDAnchorModel *)liveRoomModel
{
    
    self.liveRoomModel = liveRoomModel;
    self.nameLabel.text = liveRoomModel.nickName;
    [self.headImage yy_setImageWithURL:[NSURL URLWithString:liveRoomModel.avatarUrl] placeholder:[UIImage imageNamed:@"headIcon"]];
    [self startAnimation];
}

- (UIView *)headBord
{
    if (!_headBord) {
        _headBord = [[UIView alloc] init];
        _headBord.layer.masksToBounds = YES;
        _headBord.layer.cornerRadius = 28;
        _headBord.layer.borderWidth = 2;
        _headBord.layer.borderColor = [UIColor colorWithHexString:@"#29FFC9"].CGColor;
    }
    return _headBord;
}

- (UIImageView *)headImage
{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] init];
        _headImage.contentMode = UIViewContentModeScaleAspectFill;
        _headImage.clipsToBounds = YES;
        [_headImage cutRadius:26];
    }
    return _headImage;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.text = @"直播中";
        _descLabel.backgroundColor = UIColorHexRGBA(0x29FFC9, 1);
        _descLabel.textColor = [UIColor colorWithWhite:0 alpha:1];
        _descLabel.font = kFontPFMedium(8);
        _descLabel.textAlignment = NSTextAlignmentCenter;
        [_descLabel cutRadius:2];
    }
    return _descLabel;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithWhite:1 alpha:0.8];
        _nameLabel.font = kFontPFMedium(12);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UIView *)animationView
{
    if (!_animationView) {
        _animationView = [[UIView alloc] init];
        _animationView.layer.masksToBounds = YES;
        _animationView.layer.cornerRadius = 28;
        _animationView.layer.borderColor = UIColorHexRGBA(0x29FFC9, 0.4).CGColor;
        _animationView.layer.borderWidth = 1;
    }
    return _animationView;
}


- (void)dealloc
{
    [self removeAnimation];
}

@end
