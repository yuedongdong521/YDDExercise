//
//  YDDVideoLiveingView.m
//  YDDExercise
//
//  Created by ydd on 2020/6/18.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoLiveingView.h"

@implementation YDDVideoLiveingView

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
        
        [self addSubview:self.boxView];
        
        [self addSubview:self.headImageView];
        
        [self addSubview:self.statueImageView];
        
        [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        
        [self.statueImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)setIsLiveing:(BOOL)isLiveing
{
    _isLiveing = isLiveing;
    
    self.boxView.hidden = !isLiveing;
    self.statueImageView.hidden = !isLiveing;
}


- (void)startAnimation
{
    [self removeAnimation];
    
    if (!_isLiveing) {
        return;
    }
    
    CAKeyframeAnimation *headAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    headAnimation.duration = 1;
    headAnimation.repeatCount = MAXFLOAT;
    headAnimation.values = @[@(1.0), @(0.85), @(1.0)];
    [self.headImageView.layer addAnimation:headAnimation forKey:@"headscale-animation"];
    
    CAKeyframeAnimation *boxAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    boxAnimation.duration = 1;
    boxAnimation.repeatCount = MAXFLOAT;
    boxAnimation.values = @[@(1.0), @(1.15), @(1.0)];
    [self.boxView.layer addAnimation:boxAnimation forKey:@"boxscale-animation"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)removeAnimation
{
    [_headImageView.layer removeAnimationForKey:@"headscale-animation"];
    [_boxView.layer removeAnimationForKey:@"boxscale-animation"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 24;
        _headImageView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.7].CGColor;
        _headImageView.layer.borderWidth = 1;
        _headImageView.backgroundColor = [UIColor whiteColor];
    }
    return _headImageView;
}

- (UIImageView *)statueImageView
{
    if (!_statueImageView) {
        _statueImageView = [[UIImageView alloc] init];
        _statueImageView.contentMode = UIViewContentModeScaleAspectFill;
        _statueImageView.image = [UIImage imageNamed:@"homepage_avatar_live_img"];
        _statueImageView.clipsToBounds = YES;
    }
    return _statueImageView;
}

- (UIView *)boxView
{
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.layer.borderColor = [UIColor colorWithHexString:@"#29FFC9"].CGColor;
        _boxView.layer.borderWidth = 1;
        _boxView.layer.cornerRadius = 24;
        _boxView.layer.masksToBounds = YES;
        _boxView.userInteractionEnabled = NO;
    }
    return _boxView;
}



@end
