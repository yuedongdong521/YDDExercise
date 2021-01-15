//
//  YDDInputView.m
//  YDDExercise
//
//  Created by ydd on 2021/1/7.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDInputView.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "NSString+YDDExtend.h"


@interface YDDInputView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) CGFloat originHeight;

@end

@implementation YDDInputView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithHeight:(CGFloat)height
{
    self = [super init];
    if (self) {
        
        _edgeInset = UIEdgeInsetsMake(12, 0, 12, 0);
        _originHeight = height;
        [self setupUI];
        
        [self addRAC];
    }
    return self;
}

- (void)updateLayout
{
    CGFloat lineH = ceilf(self.textView.font.lineHeight);
    
    CGFloat edge = (self.originHeight - lineH) * 0.5;
    
    self.edgeInset = UIEdgeInsetsMake(edge, 0, edge, 0);
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.edgeInset);
    }];
    
}

- (void)addRAC
{
        
    @weakify(self);
    [[self.textView.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        @strongify(self);
        
        BOOL result = YES;
        if ([self.delegate respondsToSelector:@selector(filterText:)]) {
            result = [self.delegate filterText:value];
        }
        
        if (!result) {
            return result;
        }
        
        if (value.length == 0) {
            self.placeholderLabel.hidden = NO;
        } else {
            self.placeholderLabel.hidden = YES;
        }
    
        if (value.length > self.maxNum) {
            self.numLabel.textColor = [UIColor redColor];
        } else {
            self.numLabel.textColor = [UIColor grayColor];
        }
        [self updateHeightWithText:value];
        return YES;
    }] subscribeNext:^(NSString * _Nullable x) {
            
    }];
}

- (void)updateHeightWithText:(NSString *)text
{
    CGFloat curTextH = self.frame.size.height;
    CGFloat w = self.textView.frame.size.width;
    CGFloat textH = 0;
    if (text.length > 0) {
        
        CGFloat maxH = self.maxLine * self.textView.font.lineHeight;
        CGSize size = [text ydd_textSize:CGSizeMake(w - 5, maxH) font:self.textView.font];
        textH = ceilf(size.height) + self.edgeInset.top + self.edgeInset.bottom;
        textH = textH < self.originHeight ? self.originHeight : textH;
    } else {
        textH = self.originHeight;
    }
    
    if (curTextH == textH) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(updateInputViewHeight:)]) {
        [self.delegate updateInputViewHeight:textH];
        
//        CGRect rect = CGRectMake(0, self.textView.contentSize.height - textH, w, textH);
//        [self.textView scrollRectToVisible:rect animated:NO];
//        [self.textView setContentOffset:CGPointMake(0, self.textView.contentSize.height - textH)];
 
        
        NSLog(@"offset : %@, contentSize: %@", NSStringFromCGPoint(self.textView.contentOffset), NSStringFromCGSize(self.textView.contentSize));
        return;
    }
}

- (void)setupUI
{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.placeholderLabel];
    
    [self.contentView addSubview:self.textView];
    
    [self addSubview:self.numLabel];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.edgeInset);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_bottom);
        make.right.bottom.mas_equalTo(0);
    }];
}


- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = kFontPFMedium(14);
        _textView.contentInset = UIEdgeInsetsZero;
        _textView.textContainerInset = UIEdgeInsetsZero;
        _textView.bounces = NO;
    }
    return _textView;
}

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.font = kFontPF(14);
    }
    return _placeholderLabel;
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = kFontPF(12);
        _numLabel.textAlignment = NSTextAlignmentRight;
    }
    return _numLabel;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        
    }
    return _contentView;
}


@end
