//
//  YDDVideoLiveingItem.m
//  YDDExercise
//
//  Created by ydd on 2020/6/19.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoLiveingItem.h"

@interface YDDVideoLiveingItem ()

@property (nonatomic, strong) UIImageView *liveingImageView;

@property (nonatomic, strong) UILabel *numLabel;

@end

@implementation YDDVideoLiveingItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.liveingImageView];
        [self.liveingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 1, 0, 1));
        }];
        
        [self addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)setUnreadCount:(NSInteger)unreadCount
{
    _unreadCount = unreadCount;
    if (_unreadCount < 0) {
        _unreadCount = 0;
    }
    
    UIEdgeInsets edge = UIEdgeInsetsZero;
    if (_unreadCount > 99) {
        self.numLabel.text = [NSString stringWithFormat:@"99+"];
    } else {
        self.numLabel.text = [NSString stringWithFormat:@"%ld", (long)_unreadCount];
        if (_unreadCount < 10) {
            edge = UIEdgeInsetsMake(0, 0, 0, 13);
        }
    }
    
    [self.numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(edge);
    }];
    [self checkShowItem];
}

- (void)setHasLiveing:(BOOL)hasLiveing
{
    _hasLiveing = hasLiveing;
    [self checkShowItem];
}

- (void)checkShowItem
{
    if (self.hasLiveing) {
        self.numLabel.hidden = YES;
        self.liveingImageView.hidden = NO;
        [self.liveingImageView startAnimating];
        self.hidden = NO;
        return;
    }
    self.liveingImageView.hidden = YES;
    [self.liveingImageView stopAnimating];
    if (self.unreadCount > 0) {
        self.numLabel.hidden = NO;
        self.hidden = NO;
    } else {
        self.hidden = YES;
    }
}

- (void)clearLiveItem
{
    self.unreadCount = 0;
    self.hasLiveing = NO;
    self.hidden = YES;
}

- (UIImageView *)liveingImageView
{
    if (!_liveingImageView) {
        _liveingImageView = [[UIImageView alloc] init];
        _liveingImageView.contentMode = UIViewContentModeScaleAspectFit;
        _liveingImageView.clipsToBounds = YES;
        _liveingImageView.animationDuration = 1;
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < 12; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"videoLiveing0000%d", i]];
            if (image) {
                [arr addObject:image];
            }
        }
        _liveingImageView.image = arr.firstObject;
        _liveingImageView.animationImages = arr;
    }
    return _liveingImageView;
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = kFontPFMedium(10);
        _numLabel.textColor = UIColorHexRGBA(0x151416, 1);
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.backgroundColor = UIColorHexRGBA(0xFFDE60, 1);
        [_numLabel cutRadius:7];
    }
    return _numLabel;
}


@end
