//
//  YDDVideoProgressView.m
//  YDDExercise
//
//  Created by ydd on 2020/7/9.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoProgressView.h"

@interface YDDVideoProgressView ()

@property (nonatomic, strong) UIView *thumbView;

@property (nonatomic, strong) UIView *sliderView;

@property (nonatomic, assign) BOOL beganPan;

@end

@implementation YDDVideoProgressView

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
        [self addSubview:self.sliderView];
        [self.sliderView addSubview:self.thumbView];
        
        self.sliderView.frame = CGRectMake(0, KVideoProgressH - 1, 0, 1);
        self.thumbView.frame = CGRectMake(-2.5, -2, 5, 5);
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:pan];
        
    }
    return self;
}

- (void)updateProgress:(CGFloat)progress duration:(CGFloat)duration
{
    if (self.beganPan) {
        return;
    }
    if (duration <= 0 || progress <= 0) {
        self.sliderView.frame = CGRectMake(0, KVideoProgressH - 1, 0, 1);
        self.thumbView.frame = CGRectMake(-2.5, -2, 5, 5);
        return;
    }
    CGRect sliderFrame = self.sliderView.frame;
    CGRect thunbFrame = self.thumbView.frame;
    CGFloat w = ceilf(progress / duration * self.bounds.size.width);
    sliderFrame.size.width = w;
    self.sliderView.frame = sliderFrame;
    NSLog(@"&&&&&&&&&&&&&&& progress : %f, duration : %f, w : %f", progress, duration, w);
    thunbFrame.origin.x = w - 2.5;
    self.thumbView.frame = thunbFrame;
}

- (void)panAction:(UIPanGestureRecognizer *)pan
{
    CGPoint move = [pan translationInView:self];
    CGPoint lp = [pan locationInView:self];
    if (lp.x < 0) {
        lp.x = 0;
    } else if (lp.x > self.bounds.size.width) {
        lp.x = self.bounds.size.width;
    }
    
    NSLog(@"progress : %f", move.y);
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            self.beganPan = YES;
            CGRect sliderViewFrame = self.sliderView.frame;
            sliderViewFrame.size.height = 2;
            sliderViewFrame.size.width = lp.x;
            self.sliderView.frame = sliderViewFrame;
            
            CGRect thumbViewFrame = self.thumbView.frame;
            thumbViewFrame.origin.y = -1.5;
            thumbViewFrame.origin.x = lp.x - 2.5;
            self.thumbView.frame = thumbViewFrame;
            self.thumbView.hidden = NO;
        }
            
            break;
        case UIGestureRecognizerStateChanged: {
            CGRect sliderViewFrame = self.sliderView.frame;
            sliderViewFrame.size.height = 2;
            sliderViewFrame.size.width = lp.x;
            self.sliderView.frame = sliderViewFrame;
            
            CGRect thumbViewFrame = self.thumbView.frame;
            thumbViewFrame.origin.y = -1.5;
            thumbViewFrame.origin.x = lp.x - 2.5;
            self.thumbView.frame = thumbViewFrame;
            
        }
            break;
        
        case UIGestureRecognizerStateEnded: {
            CGFloat progress = lp.x / self.bounds.size.width;
            if (self.changeProgress) {
                self.changeProgress(progress);
            }
            [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(resetProgressStatue) object:nil];
            [self performSelector:@selector(resetProgressStatue) withObject:nil afterDelay:3];
            self.beganPan = NO;
        }
            break;
            
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled: {
            
            self.beganPan = NO;
            [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(resetProgressStatue) object:nil];
            [self performSelector:@selector(resetProgressStatue) withObject:nil afterDelay:3];
        }
            break;
            
        default:
            break;
    }
}


- (void)resetProgressStatue
{
    CGRect sliderViewFrame = self.sliderView.frame;
    sliderViewFrame.size.height = 1;
    self.sliderView.frame = sliderViewFrame;
    
    CGRect thumbViewFrame = self.thumbView.frame;
    thumbViewFrame.origin.y = -2;
    self.thumbView.frame = thumbViewFrame;
    self.thumbView.hidden = YES;
}

- (UIView *)thumbView
{
    if (!_thumbView) {
        _thumbView = [[UIView alloc] init];
        _thumbView.backgroundColor = [UIColor whiteColor];
        [_thumbView cutRadius:2.5];
        _thumbView.hidden = YES;
    }
    return _thumbView;
}

- (UIView *)sliderView
{
    if (!_sliderView) {
        _sliderView = [[UIView alloc] init];
        _sliderView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    }
    return _sliderView;
}


@end
