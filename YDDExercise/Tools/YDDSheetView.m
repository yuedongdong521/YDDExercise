//
//  YDDSheetView.m
//  YDD
//
//  Created by ydd on 2021/5/18.
//  Copyright © 2021 ibobei. All rights reserved.
//

#import "YDDSheetView.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

@implementation YDDSheetModel



@end

@interface YDDSheetItemView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, copy) void(^didClicked)(YDDSheetModel *model);

@end

@implementation YDDSheetItemView

- (instancetype)initWithModel:(YDDSheetModel *)model
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        self.titleLabel.text = model.title;
        self.titleLabel.font = model.font;
        self.titleLabel.textColor = model.color;
        
        if (model.icon) {
        
            [self addSubview:self.iconView];
            UIImage *image = [UIImage imageNamed:model.icon];
            self.iconView.image = image;
            
            [self.titleLabel sizeToFit];
            
            CGFloat titleW = self.titleLabel.frame.size.width;
            CGFloat iconLeft = (ScreenWidth - image.size.width - titleW - 8) * 0.5;
           
            [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.titleLabel);
                make.size.mas_equalTo(image.size);
                make.left.mas_equalTo(iconLeft);
            }];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.height.mas_equalTo(model.height);
                make.left.mas_equalTo(self.iconView.mas_right).mas_offset(6);
                make.width.mas_equalTo(titleW + 4);
            }];
            
            
        } else {
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(0);
                make.height.mas_equalTo(model.height);
            }];
        }
        
        if (model.hasLine) {
            [self addSubview:self.lineView];
            [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(-15);
                make.height.mas_equalTo(1);
            }];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        @weakify(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            @strongify(self);
            if (self.didClicked) {
                self.didClicked(model);
            }
        }];
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorHexRGBA(0x888888, 0.1);
    }
    return _lineView;
}

@end

@interface YDDSheetView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation YDDSheetView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (YDDSheetView *)showWithItems:(NSArray<YDDSheetModel*>*)items selected:(void(^)(YDDSheetModel *model))selected
{
    YDDSheetView *sheetView = [[YDDSheetView alloc] initWithItems:items selected:selected];
    sheetView.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:sheetView];
    [sheetView show];
    return sheetView;
}

- (instancetype)initWithItems:(NSArray<YDDSheetModel*>*)items selected:(void(^)(YDDSheetModel*))selected
{
    self = [super init];
    if (self) {
        [self addSubview:self.bgView];
        
        [self addSubview:self.contentView];
        
        __block CGFloat y = 0;
        [items enumerateObjectsUsingBlock:^(YDDSheetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YDDSheetItemView *itemView = [[YDDSheetItemView alloc] initWithModel:obj];
            [self.contentView addSubview:itemView];
            @weakify(self);
            itemView.didClicked = ^(YDDSheetModel *model) {
                @strongify(self);
                [self dismiss];
                if (selected) {
                    selected(model);
                }
            };
            
            if (y > 0 && obj.isFooter) {
                y += 8;
            }
            CGFloat height = obj.isFooter || idx == items.count - 1 ? kSafeBottom + obj.height : obj.height;
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(y);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(height);
            }];
            y += height;
            
        }];
        
        self.bgView.frame = [UIScreen mainScreen].bounds;
        self.contentView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, y);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self.bgView addGestureRecognizer:tap];
        @weakify(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            @strongify(self);
            [self dismiss];
        }];
        
    }
    return self;
}

- (void)show
{
    CGRect frame = self.contentView.frame;
    frame.origin.y = ScreenHeight - frame.size.height;
    self.bgView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 1;
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        if (!finished) {
            self.bgView.alpha = 1;
            self.contentView.frame = frame;
        }
    }];
}

- (void)dismiss
{
    CGRect frame = CGRectMake(0, ScreenHeight, ScreenWidth, self.contentView.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 0;
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        if (!finished) {
            self.bgView.alpha = 0;
            self.contentView.frame = frame;
        }
        if ([self superview]) {
            [self removeFromSuperview];
        }
    }];
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    }
    return _bgView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    }
    return _contentView;
}


@end
