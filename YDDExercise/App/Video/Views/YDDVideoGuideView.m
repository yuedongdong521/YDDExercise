//
//  YDDVideoGuideView.m
//  YDDExercise
//
//  Created by ydd on 2020/6/23.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoGuideView.h"

#define kVideoTapGuideShowFlagKey @"VideoTapGuideShowFlagKey"
#define kVideoPanGuideShowFlagKey @"VideoPanGuideShowFlagKey"

@interface YDDVideoGuideView ()<UIGestureRecognizerDelegate>

@property (nonatomic, copy) void(^dismissBlock)(void);

@property (nonatomic, strong) UIImageView *guideImageView;

@end

@implementation YDDVideoGuideView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (void)showVideoPanGuideViewCompleted:(void(^)(CGFloat offsetY, BOOL isEnd, BOOL changed))completed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:kVideoPanGuideShowFlagKey]) {
        return;
    }
    [defaults setBool:YES forKey:kVideoPanGuideShowFlagKey];
    
    YDDVideoGuideView *guideView = [[YDDVideoGuideView alloc] initWithType:KXVideoGuideType_pan dismissBlock:^{
        
    }];
    
    guideView.scrollOffsetY = completed;
    [[UIApplication sharedApplication].keyWindow addSubview:guideView];
}

+ (void)showVideoTapGuideView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:kVideoTapGuideShowFlagKey]) {
        return;
    }
    [defaults setBool:YES forKey:kVideoTapGuideShowFlagKey];

    YDDVideoGuideView *guideView = [[YDDVideoGuideView alloc] initWithType:KXVideoGuideType_tap dismissBlock:^{
        
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:guideView];
}


- (instancetype)initWithType:(KXVideoGuideType)guideType dismissBlock:(void(^)(void))dismissBlock
{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        
        _dismissBlock = dismissBlock;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        
        _guideImageView = [[UIImageView alloc] init];
        if (guideType == KXVideoGuideType_pan) {
            NSMutableArray <UIImage *>* images = [NSMutableArray array];
            NSInteger scale = [UIScreen mainScreen].scale;
            scale = scale == 3 ? 3 : 2;
            for (NSInteger i = 0; i < 24; i++) {
                NSString *name = [NSString stringWithFormat:@"VideoGuideScroll_%ld@%ldx", (long)i, (long)scale];
                NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
                if (path.length > 0) {
                    UIImage *image = [UIImage imageWithContentsOfFile:path];
                    if (image) {
                        [images addObject:image];
                    }
                }
            }
            UIImage *image = images.firstObject;
            _guideImageView.image = image;
            _guideImageView.animationImages = images;
            _guideImageView.animationDuration = 1.5;
            _guideImageView.animationRepeatCount = 6;
            [self addSubview:_guideImageView];
            [_guideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(187, 187));
                make.centerX.mas_equalTo(self.mas_centerX);
                make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-44);
            }];
            
            [_guideImageView startAnimating];
            [self performSelector:@selector(delayDestory) withObject:nil afterDelay:6 * 1.5];
            
        } else {
            UIImage *image = [UIImage imageNamed:@"homepage_userguide02_img"];
            _guideImageView.image = image;
            [self addSubview:_guideImageView];
            [_guideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(image.size);
                make.centerX.mas_equalTo(self.mas_centerX);
                make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-44);
            }];
        }
        
        UILabel *label = [[UILabel alloc] init];
        label.font = kFontPFMedium(20);
        label.textColor = [UIColor colorWithWhite:1 alpha:0.8];
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.guideImageView);
            make.top.mas_equalTo(self.guideImageView.mas_bottom).mas_offset(guideType == KXVideoGuideType_pan ? 20 : 10);
            make.height.mas_equalTo(28);
        }];
        
        label.text = guideType == KXVideoGuideType_pan ? @"上滑查看更多视频" : @"双击视频快速点赞";
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        
        if (guideType == KXVideoGuideType_pan) {
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
            pan.delegate = self;
            [self addGestureRecognizer:pan];
            [tap requireGestureRecognizerToFail:pan];
        }
        
    }
    return self;
}

- (void)delayDestory
{
    [_guideImageView stopAnimating];
    _guideImageView.animationImages = nil;
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

/*
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
//    CGPoint p = [gestureRecognizer translationInView:gestureRecognizer.view];
//    if (fabs(p.y) > fabs(p.x)) {
//        return YES;
//    }
//    if (p.y < 0) {
//        return YES;
//    }
//    return NO;
    
    return YES;
}
 */

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayDestory) object:nil];
    [self delayDestory];
}

- (void)panAction:(UIPanGestureRecognizer *)pan
{
    CGPoint move = [pan translationInView:pan.view];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            if (self.scrollOffsetY) {
                self.scrollOffsetY(move.y, NO, NO);
            }
        }
            break;
        case UIGestureRecognizerStateChanged: {
            if (self.scrollOffsetY) {
                self.scrollOffsetY(move.y, NO, NO);
            }
        }
            break;
            
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            
            CGPoint v = [pan velocityInView:pan.view];
            [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayDestory) object:nil];
            [self delayDestory];
            if (self.scrollOffsetY) {
                self.scrollOffsetY(move.y, YES, v.y < 0);
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

@end
