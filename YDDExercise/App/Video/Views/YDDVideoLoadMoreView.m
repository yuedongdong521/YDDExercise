//
//  YDDVideoLoadMoreView.m
//  YDDExercise
//
//  Created by ydd on 2020/7/2.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoLoadMoreView.h"

#define KXPullupMaskAnimationKey @"KXPullupMaskAnimationKey"

@interface YDDVideoLoadMoreView ()

@property (nonatomic, strong) UIView *animationView;

@property (nonatomic, assign) BOOL isAnimationing;

@property (nonatomic, assign) BOOL needRestAnimation;

@end

@implementation YDDVideoLoadMoreView

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
        _isAnimationing = NO;
        _needRestAnimation = NO;
        self.backgroundColor = [UIColor clearColor];
        self.animationView = [[UIView alloc] initWithFrame:self.bounds];
        self.animationView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.animationView];
        [self addObserver];
    }
    return self;
}

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)appWillResignActive
{
    if (_isAnimationing) {
        [self stopAnimation];
        _needRestAnimation = YES;
    }
}

- (void)appDidBecomeActive
{
    if (_needRestAnimation) {
        _needRestAnimation = NO;
        [self startAnimation];
        
    }
}


- (void)startAnimation
{
    _isAnimationing = YES;
    CAGradientLayer *makeLayer = [[CAGradientLayer alloc]init];
    makeLayer.frame = self.animationView.bounds;
    NSArray *startLocations = @[@(0), @(0.4), @(0.5), @(0.6), @(1)];
    NSArray *endLocations = @[@(0), @(0), @(0.5), @(1), @(1)];
    makeLayer.locations = startLocations;
    makeLayer.startPoint = CGPointMake(0, 1);
    makeLayer.endPoint = CGPointMake(1, 1);
    
    id color1 = (id)[UIColor colorWithWhite:0 alpha:0.0].CGColor;
    id color2 = (id)[UIColor colorWithWhite:0 alpha:0].CGColor;
    id color3 = (id)[UIColor colorWithWhite:0 alpha:1].CGColor;
    
    [makeLayer setColors:@[color1, color2, color3, color2, color1]];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    animation.fromValue = startLocations;
    animation.toValue = endLocations;
    animation.duration = 0.3;
    animation.repeatCount = MAXFLOAT;
    self.animationView.layer.mask = makeLayer;
    [makeLayer addAnimation:animation forKey:KXPullupMaskAnimationKey];
}

- (void)stopAnimation
{
    [self.animationView.layer.mask removeAllAnimations];
    self.animationView.layer.mask = nil;
    _isAnimationing = NO;
}

- (void)dealloc
{
    [self stopAnimation];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
