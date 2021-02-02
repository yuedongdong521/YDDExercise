//
//  YDDVideoPullRefreshView.m
//  YDDExercise
//
//  Created by ydd on 2020/6/20.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoPullRefreshView.h"

#define KXPullRefreshHeight (kNavBarHeight + 6)

@interface YDDVideoPullRefreshView ()

@property (nonatomic, strong) UIImageView *imageView;


@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) NSInteger imageIndex;


@end

@implementation YDDVideoPullRefreshView

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
        
        self.frame = CGRectMake(0, -KXPullRefreshHeight, ScreenWidth, KXPullRefreshHeight);
        self.backgroundColor = [UIColor blackColor];
        
        self.roat = 0.7;
        self.imageIndex = -1;
        
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10);
            make.width.mas_equalTo(35);
            make.height.mas_equalTo(35);
            make.centerX.mas_equalTo(self.mas_centerX).mas_offset(-30);
        }];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.imageView.mas_centerY);
            make.height.mas_equalTo(21);
            make.centerX.mas_equalTo(self.imageView.mas_centerX).mas_offset(15 + 35);
        }];
    }
    return self;
}


- (void)updatePullOffsetY:(CGFloat)offsetY isBegan:(BOOL)isBegan isRefresh:(BOOL)isRefresh
{
    if (_statue == KXPullRefreshStatue_refreshing ||
        _statue == KXPullRefreshStatue_end) {
        return;
    }
    
    if (isBegan) {
        self.statue = KXPullRefreshStatue_began;
    }
    
    CGRect frame = self.frame;
    
    CGFloat y = -KXPullRefreshHeight + offsetY * self.roat;
    
//    [self updateImageWithOffsetY:offsetY];
    
    y = y > 0 ? 0 : y < -KXPullRefreshHeight ? -KXPullRefreshHeight : y;
    
    frame.origin.y = y;
    self.frame = frame;
    
    
    if (!isRefresh) {
        return;
    }
    
   
    if (y >= 0) {
        self.statue = KXPullRefreshStatue_refreshing;
    } else {
        self.statue = KXPullRefreshStatue_end;
    }
}




- (void)setStatue:(KXPullRefreshStatue)statue
{
    if (statue == _statue) {
        return;
    }
    
    _statue = statue;
    switch (statue) {
        case KXPullRefreshStatue_none:
            
            break;
        case KXPullRefreshStatue_began: {
            if (self.imageView.animating) {
                [self.imageView stopAnimating];
            }
        }
            break;
        case KXPullRefreshStatue_refreshing: {
            if (self.frame.origin.y != 0) {
                self.frame = CGRectMake(0, 0, ScreenWidth, KXPullRefreshHeight);
            }

            [self.imageView startAnimating];
            if (self.beganRefresh) {
                self.beganRefresh();
            }
        }
            break;
        case KXPullRefreshStatue_end: {
            
            if (self.frame.origin.y != -KXPullRefreshHeight) {
                [UIView animateWithDuration:0.3 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.frame = CGRectMake(0, -KXPullRefreshHeight, ScreenWidth, KXPullRefreshHeight);
                } completion:^(BOOL finished) {
                    if (!finished) {
                        self.frame = CGRectMake(0, -KXPullRefreshHeight, ScreenWidth, KXPullRefreshHeight);
                    }
                    [self resetPullRefreshView];
                }];
            } else {
                [self resetPullRefreshView];
            }
        }
        default:
            break;
    }
}

- (void)resetPullRefreshView
{
    self.imageIndex = -1;
    [self.imageView stopAnimating];
    self.statue = KXPullRefreshStatue_none;
}

- (void)updateImageWithOffsetY:(CGFloat)offsetY
{
    CGFloat y = offsetY * self.roat - 40;
    if (y < 0) {
        self.imageIndex = -1;
        self.imageView.image = nil;
        return;
    }
    
    int index = floorf(y / 10);
    index = index > 10 ? 10 : y;
        
    if (_imageIndex != index) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pulllRefresh_0%d", index]];
        if (image) {
            self.imageView.image = image;
        } else {
        }
        
    }
}


- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        
        NSMutableArray *mutAtt = [NSMutableArray array];
        for (int i = 0; i < 24; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pullRefresh%d", i]];
            if (image) {
                [mutAtt addObject:image];
            }
        }
        _imageView.image = mutAtt.firstObject;
        _imageView.animationDuration = 1;
        _imageView.animationImages = mutAtt;
        _imageView.animationRepeatCount = 0;
        
    }
    return _imageView;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [UILabel ydd_labelAlignment:NSTextAlignmentLeft font:kFontPFMedium(14) textColor:[UIColor colorWithWhite:1 alpha:1]];
        _label.text = @"下拉刷新";
    }
    return _label;
}


@end
