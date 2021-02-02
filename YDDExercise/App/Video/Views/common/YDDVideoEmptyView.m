//
//  YDDVideoEmptyView.m
//  YDDExercise
//
//  Created by ydd on 2020/6/23.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoEmptyView.h"


#define kVideoEmptyTag 100001

@interface YDDVideoEmptyView ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;


@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, copy) void(^clickBlock)(void);

@end

@implementation YDDVideoEmptyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (void)removeEmptyViewFromSuperView:(UIView *)superView
{
    if (!superView) {
        return;
    }
    UIView *view = [superView viewWithTag:kVideoEmptyTag];
    if ([view isKindOfClass:[YDDVideoEmptyView class]]) {
        [view removeFromSuperview];
    }
}

+ (void)addEmptyViewToSuperView:(UIView *)superView clickBlock:(void(^)(void))clickBlock
{
    if (!superView) {
        return;
    }
    [self removeEmptyViewFromSuperView:superView];
    
    YDDVideoEmptyView *emptyView = [[YDDVideoEmptyView alloc] init];
    emptyView.tag = kVideoEmptyTag;
    emptyView.clickBlock = clickBlock;
    [superView addSubview:emptyView];
    
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    UIImage *image = [UIImage imageNamed:@"kong_no_content"];
    emptyView.imageView.image = image;
    
    emptyView.titleLabel.text = @"呜呼～你的关注列表空空的";
    [emptyView.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(emptyView.imageView.mas_bottom).mas_offset(4);
        make.height.mas_equalTo(20);
        make.centerX.equalTo(emptyView);
        make.centerY.mas_equalTo(emptyView.mas_centerY);
    }];
    
    [emptyView.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(image.size);
        make.centerX.equalTo(emptyView);
        make.bottom.mas_equalTo(emptyView.titleLabel.mas_top).mas_offset(-4);;
    }];
    
    emptyView.subTitleLabel.text = @"为你找到可能感兴趣的人";
    [emptyView.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(emptyView);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(emptyView.titleLabel.mas_bottom).mas_offset(82);
    }];
    
    [emptyView.button setTitle:@"点击前往" forState:UIControlStateNormal];
    [emptyView.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(emptyView.subTitleLabel.mas_bottom).mas_offset(10);
        make.centerX.equalTo(emptyView);
        make.size.mas_equalTo(CGSizeMake(210, 50));
    }];
}

+ (void)addNetworkEmptyViewToSuperView:(UIView *)superView
{
    
    [self addNetworkEmptyViewToSuperView:superView clickBlock:^{
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                
            }];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
        
    }];
}

+ (void)addNetworkEmptyViewToSuperView:(UIView *)superView clickBlock:(void(^)(void))clickBlock
{
    if (!superView) {
        return;
    }
   [self removeEmptyViewFromSuperView:superView];
    
    YDDVideoEmptyView *emptyView = [[YDDVideoEmptyView alloc] init];
    emptyView.tag = kVideoEmptyTag;
    emptyView.clickBlock = clickBlock;
    [superView addSubview:emptyView];
    
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    UIImage *image = [UIImage imageNamed:@"kong_network"];
    emptyView.imageView.image = image;
    
    emptyView.titleLabel.text = @"网络错误";
    
    [emptyView.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.centerX.equalTo(emptyView);
        make.centerY.mas_equalTo(emptyView.mas_centerY);
    }];
    
    [emptyView.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(image.size);
        make.centerX.equalTo(emptyView);
        make.bottom.mas_equalTo(emptyView.titleLabel.mas_top).mas_offset(-4);;
    }];
    
    emptyView.subTitleLabel.text = @"请检查网络连接后重试";
    [emptyView.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(emptyView);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(emptyView.titleLabel.mas_bottom).mas_offset(2);
    }];
    
    [emptyView.button setTitle:@"查看系统设置" forState:UIControlStateNormal];
    [emptyView.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(emptyView.subTitleLabel.mas_bottom).mas_offset(88);
        make.centerX.equalTo(emptyView);
        make.size.mas_equalTo(CGSizeMake(210, 50));
    }];
}

+ (void)addLocationEmptyToSuperView:(UIView *)superView clickBlock:(void(^)(void))clickBlock
{
    
    if (!superView) {
           return;
       }
      [self removeEmptyViewFromSuperView:superView];
       
       YDDVideoEmptyView *emptyView = [[YDDVideoEmptyView alloc] init];
       emptyView.tag = kVideoEmptyTag;
       emptyView.clickBlock = clickBlock;
       [superView addSubview:emptyView];
       
       [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.mas_equalTo(UIEdgeInsetsZero);
       }];
       
       UIImage *image = [UIImage imageNamed:@"kong_positioning"];
       emptyView.imageView.image = image;
       
       emptyView.titleLabel.text = @"你还没开启定位权限哦";
       
       [emptyView.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.height.mas_equalTo(20);
           make.centerX.equalTo(emptyView);
           make.centerY.mas_equalTo(emptyView.mas_centerY);
       }];
       
       [emptyView.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.size.mas_equalTo(image.size);
           make.centerX.equalTo(emptyView);
           make.bottom.mas_equalTo(emptyView.titleLabel.mas_top).mas_offset(-4);;
       }];

       
       [emptyView.button setTitle:@"开启定位" forState:UIControlStateNormal];
       [emptyView.button mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(emptyView.titleLabel.mas_bottom).mas_offset(100);
           make.centerX.equalTo(emptyView);
           make.size.mas_equalTo(CGSizeMake(210, 50));
       }];
    
    
}

+ (void)addErrorEmptyToSuperView:(UIView *)superView clickBlock:(void(^)(void))clickBlock
{
    
    if (!superView) {
           return;
       }
      [self removeEmptyViewFromSuperView:superView];
       
       YDDVideoEmptyView *emptyView = [[YDDVideoEmptyView alloc] init];
       emptyView.tag = kVideoEmptyTag;
       emptyView.clickBlock = clickBlock;
       [superView addSubview:emptyView];
       
       [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.mas_equalTo(UIEdgeInsetsZero);
       }];
       
       UIImage *image = [UIImage imageNamed:@"kong_server"];
       emptyView.imageView.image = image;
       
       emptyView.titleLabel.text = @"内容加载失败，请刷新";
       
       [emptyView.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.height.mas_equalTo(20);
           make.centerX.equalTo(emptyView);
           make.centerY.mas_equalTo(emptyView.mas_centerY);
       }];
       
       [emptyView.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.size.mas_equalTo(image.size);
           make.centerX.equalTo(emptyView);
           make.bottom.mas_equalTo(emptyView.titleLabel.mas_top).mas_offset(-4);;
       }];

       
       [emptyView.button setTitle:@"刷新重试" forState:UIControlStateNormal];
       [emptyView.button mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(emptyView.titleLabel.mas_bottom).mas_offset(110);
           make.centerX.equalTo(emptyView);
           make.size.mas_equalTo(CGSizeMake(210, 50));
       }];
    
    
}


- (instancetype)init
{
    if (self = [super init]) {
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        [self addSubview:self.button];
    }
    return self;
}

- (void)buttonAction:(UIButton *)btn
{
    if (_clickBlock) {
        _clickBlock();
    }
}


- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFontPFMedium(14);
        _titleLabel.textColor = UIColorHexRGBA(0x888888, 0.6);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}


- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = kFontPFMedium(14);
        _subTitleLabel.textColor = UIColorHexRGBA(0x888888, 0.4);
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLabel;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button cutRadius:6];
        _button.backgroundColor = UIColorHexRGBA(0x888888, 0.1);
        [_button setTitleColor:[UIColor colorWithHexString:@"#09E1D5"] forState:UIControlStateNormal];
        _button.titleLabel.font = kFontPFMedium(15);
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}


@end
