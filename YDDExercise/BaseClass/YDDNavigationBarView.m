//
//  YDDNavigationBarView.m
//  YDDExercise
//
//  Created by ydd on 2019/7/20.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "YDDNavigationBarView.h"

@interface YDDNavigationBarView ()



@end

@implementation YDDNavigationBarView

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
        [self commonInit];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self addSubview:self.titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(50);
            make.right.mas_equalTo(-50);
            make.height.mas_equalTo(44);
        }];
    }
    return self;
}

- (void)commonInit
{
    self.backgroundColor = [UIColor whiteColor];
}


- (void)setTitle:(NSString *)title
{
    if (title.length > 0) {
        self.titleLabel.text = title;
       
    }
}

- (void)setLeftBlock:(void (^)(void))leftBlock
{
    if (leftBlock) {
        [self leftBtn];
        _leftBlock = leftBlock;
    }
}

- (void)setRightBlock:(void (^)(void))rightBlock
{
    if (rightBlock) {
        [self rightBtn];
        _rightBlock = rightBlock;
    }
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel ydd_labelAlignment:NSTextAlignmentCenter fontSize:16 text:nil];
        
    }
    return _titleLabel;
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [UIButton ydd_buttonType:UIButtonTypeCustom image:[UIImage imageNamed:@"nav_back"] target:self action:@selector(leftAction:)];
        [self addSubview:_leftBtn];
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0);
            make.width.height.mas_equalTo(44);
        }];
        
    }
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton ydd_buttonType:UIButtonTypeCustom target:self action:@selector(rightAction:)];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
            make.width.height.mas_equalTo(44);
        }];
    }
    return _rightBtn;
}

- (void)leftAction:(UIButton *)btn
{
    if (_leftBlock) {
        _leftBlock();
    }
}

- (void)rightAction:(UIButton *)btn
{
    if (_rightBlock) {
        _rightBlock();
    }
}

@end
