//
//  YDDPasswordView.m
//  YDDExercise
//
//  Created by ydd on 2021/1/7.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDPasswordView.h"
#import "UILabel+YDDExtend.h"

@interface YDDPasswordItem : UIView

@property (nonatomic, strong) UILabel *passwordLabel;

@property (nonatomic, strong) UIView *hidView;

@property (nonatomic, strong) NSString *value;

@end

@implementation YDDPasswordItem


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self addSubview:self.passwordLabel];
        [self addSubview:self.hidView];
        [self.passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        self.passwordLabel.hidden = YES;
        
        [self.hidView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(7);
            make.center.equalTo(self);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = UIColorHexRGBA(0x888888, 0.6);
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        self.value = @"";
    }
    return self;
}

- (UILabel *)passwordLabel
{
    if (!_passwordLabel) {
        _passwordLabel = [UILabel ydd_labelAlignment:NSTextAlignmentCenter font:kFontPFMedium(14) textColor:UIColorHexRGBA(0x313131, 1)];
        
    }
    return _passwordLabel;
}

- (UIView *)hidView
{
    if (!_hidView) {
        _hidView = [[UIView alloc] init];
        _hidView.backgroundColor = UIColorHexRGBA(0x313131, 1);
        _hidView.layer.cornerRadius = 3.5;
        _hidView.layer.masksToBounds = YES;
    }
    return _hidView;
}

- (void)setValue:(NSString *)value
{
    _value = value;
    
    if (value.length > 0) {
        _passwordLabel.text = value;
        _hidView.hidden = NO;
    } else {
        _passwordLabel.text = @"";
        _hidView.hidden = YES;
    }
}

@end


@interface YDDPasswordView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) NSMutableArray <YDDPasswordItem *>*itmes;

@end


@implementation YDDPasswordView


- (void)viewDidAppear
{
    if (![self.textField isFirstResponder]) {
        [self.textField becomeFirstResponder];
    }
    
}

- (instancetype)initWithLenght:(NSInteger)lenght
{
    self = [super init];
    if (self) {
        [self addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        for (NSInteger i = 0; i < lenght; i++) {
            YDDPasswordItem *item = [[YDDPasswordItem alloc] init];
            [self.textField addSubview:item];
            [self.itmes addObject:item];
        }
        
        [self.itmes mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:20 leadSpacing:0 tailSpacing:0];
        [self.itmes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
        
    }
    return self;
}

- (NSString *)password
{
    return self.textField.text;
}

- (void)clearPassword
{
    self.textField.text = @"";
    for (YDDPasswordItem *item in self.itmes) {
        item.value = @"";
    }
    if (self.passwordChanged) {
        self.passwordChanged(@"");
    }
}

- (CGSize)viewSize
{
    return CGSizeMake(20 * self.itmes.count + (self.itmes.count - 1) * 12, 30);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger curIndex = textField.text.length;
    if (string.length == 0) {
        curIndex--;
    }
    
    if (curIndex < 0) {
        return YES;
    }
    
    if (curIndex < self.itmes.count) {
        self.itmes[curIndex].value = string;
        
        if (self.passwordChanged) {
            NSString *password = textField.text;
            if (string.length == 0) {
                if (password.length > 1) {
                   password = [password substringToIndex:password.length - 1];
                } else {
                    password = @"";
                }
            } else {
                password = [password stringByAppendingString:string];
            }
            self.passwordChanged(password);
        }
        
        return YES;
    }
    if (curIndex == self.itmes.count) {
        if (string.length == 0) {
            self.itmes.lastObject.value = string;
            return YES;
        }
    }
    return NO;
}


- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.textColor = [UIColor clearColor];
        _textField.tintColor = [UIColor clearColor];
        _textField.keyboardType = UIKeyboardTypePhonePad;
    }
    return _textField;
}

- (NSMutableArray<YDDPasswordItem *> *)itmes
{
    if (!_itmes) {
        _itmes = [NSMutableArray array];
    }
    return _itmes;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = CGRectInset(self.bounds, -10, -10);
    if (CGRectContainsPoint(rect, point)) {
        return self.textField;
    }
    return [super hitTest:point withEvent:event];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
