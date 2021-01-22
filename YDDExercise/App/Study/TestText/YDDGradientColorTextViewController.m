//
//  YDDGradientColorTextViewController.m
//  YDDExercise
//
//  Created by ydd on 2021/1/21.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDGradientColorTextViewController.h"

#import "YDDGradientLabel.h"

#import "YDDLyricModel.h"

#import "YDDLyricView.h"



@interface YDDGradientColorTextViewController ()

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;


@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) YDDGradientLabel *gradientLabel;

@property (nonatomic, copy) NSArray <YDDLyricModel *>*lyricList;

@property (nonatomic, strong) YDDLyricView *lyricView;


@end


@implementation YDDGradientColorTextViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @weakify(self);
    self.navBarView.leftBlock = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:self.textLabel];
    
    self.textLabel.text = @"脱掉漂亮却磨脚的高跟鞋";
    [self.textLabel sizeToFit];
    
    CGFloat w = self.textLabel.bounds.size.width + 1;
    
    self.textLabel.frame = CGRectMake(20, 100, w, 30);
    
    [self.view addSubview:self.gradientLabel];
    
    self.gradientLabel.text = @"锁门关灯背对着喧闹的世界";
    
    CGSize size = [self.gradientLabel textSizeWithMaxSize:CGSizeMake(1000, 30)];
    
    self.gradientLabel.frame = CGRectMake(20, 150, size.width, 30);
    
    self.gradientLabel.textColors = @[[UIColor greenColor],  [UIColor greenColor], self.textLabel.textColor, self.textLabel.textColor];
    self.gradientLabel.locations = @[@(0), @(self.progress), @(self.progress), @(1)];
    
    self.progress = 0.5;
    
    self.gradientLayer.colors = @[(id)[UIColor greenColor].CGColor,  (id)[UIColor greenColor].CGColor,(id)self.textLabel.textColor.CGColor, (id)self.textLabel.textColor.CGColor];
    self.gradientLayer.startPoint = CGPointMake(0, 0.5);
    self.gradientLayer.endPoint = CGPointMake(1, 0.5);
    self.gradientLayer.locations = @[@(0), @(self.progress), @(self.progress), @(1)];
    self.gradientLayer.frame = self.textLabel.frame;
    [self.view.layer addSublayer:self.gradientLayer];
    self.gradientLayer.mask = self.textLabel.layer;
    self.textLabel.frame = self.textLabel.bounds;
    
    [self startTimer];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"start" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn.frame = CGRectMake(20, 200, 80, 30);
    
    [self.view addSubview:self.lyricView];
    
    self.lyricView.frame = CGRectMake(20, 250, ScreenWidth - 40, ScreenHeight - 300);
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopTimer];
}


- (void)btnAction:(UIButton *)btn
{
    [self.lyricView start];
}

- (void)timerAction
{
    self.progress += 0.01;
    
    if (self.progress > 1.01) {
        self.progress = 0;
    } else if (self.progress == 1.01) {
        self.progress = 1;
    }
    self.gradientLayer.locations = @[@(0), @(self.progress), @(self.progress), @(1)];
    
    self.gradientLabel.locations = @[@(0), @(self.progress), @(self.progress), @(1)];
    
}

- (void)startTimer
{
    [self stopTimer];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer fire];
}



- (void)stopTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}


- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor grayColor];
        _textLabel.backgroundColor = [UIColor clearColor];
    }
    return _textLabel;
}

- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer) {
        _gradientLayer = [[CAGradientLayer alloc]init];
    }
    return _gradientLayer;
}


- (YDDGradientLabel *)gradientLabel
{
    if (!_gradientLabel) {
        _gradientLabel = [[YDDGradientLabel alloc] init];
    }
    return _gradientLabel;
}


- (YDDLyricView *)lyricView
{
    if (!_lyricView) {
        _lyricView = [[YDDLyricView alloc] initWithFrame:CGRectZero line:12];
    }
    return _lyricView;
}

@end
