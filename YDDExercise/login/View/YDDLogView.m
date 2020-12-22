//
//  YDDLogView.m
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "YDDLogView.h"
#import "YDDUserBaseInfoModel.h"
#import "YDDAddImageTools.h"

#define kHeadSize 80

#define kTextFieldH 50

@interface YDDLogView ()<UITextFieldDelegate>

@property (nonatomic, assign) LogViewType viewType;

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UIImage *uploadImage;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *userIdTextField;

@property (nonatomic, strong) UITextField *passwordTextField;

@property (nonatomic, strong) UIButton *logBtn;


@end

@implementation YDDLogView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithViewType:(LogViewType)type
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _viewType = type;
        [self cretateHead];
        [self addTextField];
        [self addLogButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

- (void)keyboardWillShowNotification:(NSNotification *)notify
{
    CGRect rect = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [self updateBtnKeyboardFrame:rect duration:duration];
}

- (void)keyboardWillHideNotification:(NSNotification *)notify
{
    CGRect rect = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [self updateBtnKeyboardFrame:rect duration:duration];

}

- (void)updateBtnKeyboardFrame:(CGRect)keyboardFrame duration:(CGFloat)duration
{
    CGFloat keyboardY = keyboardFrame.origin.y;
    CGRect logBtnFrame = [self convertRect:self.logBtn.frame toView:[UIApplication sharedApplication].delegate.window];
    
    CGFloat maxY = CGRectGetMaxY(logBtnFrame);
    
    if (keyboardY < ScreenHeight) {
        if (maxY <= keyboardY) {
            return;
        }
        CGFloat offsetY = maxY - keyboardY;
        
        if (duration > 0) {
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -offsetY);
            } completion:^(BOOL finished) {
                if (!finished) {
                    self.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -offsetY);
                }
            }];
        } else {
            self.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -offsetY);
        }
    } else {
        
        if (self.frame.origin.y == 0) {
            return;
        }
        
        if (duration > 0) {
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if (!finished) {
                    self.transform = CGAffineTransformIdentity;
                }
            }];
        } else {
            self.transform = CGAffineTransformIdentity;
        }
    }
}


- (void)setInfoModel:(YDDUserBaseInfoModel *)infoModel
{
    _infoModel = infoModel;
    if (_viewType == LogViewType_Logon) {
        return;
    }
    NSData *data = [NSData dataWithContentsOfFile:infoModel.userIcon];
    UIImage *image = [UIImage imageWithContentsOfFile:infoModel.userIcon];
    [_headImage yy_setImageWithURL:[_infoModel.userIcon ydd_coverUrl] placeholder:kHeadIconDefault];
    _nameLabel.text = infoModel.userName;
    _userIdTextField.text = [NSString stringWithFormat:@"%ld", (long)infoModel.userId];
    
}


- (void)tapHeadImage
{
    weakObj(self);
    [YDDAddImageTools addImagePickerWithTargetViewController:[self superViewController] completeHandle:^(UIImage * _Nonnull image) {
        strongObj(self, weakself);
        strongself.uploadImage = image;
        strongself.headImage.image = image;
    }];
}

- (void)logBtnAction
{
    [self endEditing:YES];
    if (![self checkLogBtnState]) {
        return;
    }
    
    YDDUserBaseInfoModel *userInfo = [[YDDUserBaseInfoModel alloc] init];
    if (_viewType != LogViewType_Login) {
        userInfo.userIcon = _infoModel.userIcon;
        userInfo.userName = _nameTextField.text;
        if (_uploadImage) {
            NSData *data = UIImagePNGRepresentation(_uploadImage);
            userInfo.userIcon = [NSString getPathForDocumentWithDirName:@"headIcon" fileName:nil];
            [data writeToFile:userInfo.userIcon atomically:YES];
        }
    }
    userInfo.userId = [_userIdTextField.text integerValue];
    userInfo.password = _passwordTextField.text;
    
    if (self.loginBlock) {
        self.loginBlock(userInfo);
    }
}

- (void)registerBtnAction
{
    [self endEditing:YES];
    if (self.logonBlock) {
        self.logonBlock();
    }
}

- (BOOL)checkLogBtnState
{
    if (_viewType == LogViewType_Logon) {
        if (_nameTextField.text.length == 0) {
            [self hud_showTips:@"昵称不能为空"];
            return NO;
        }
        
    }
    if (_userIdTextField.text.length == 0) {
        [self hud_showTips:@"请输入手机号"];
        return NO;
    }
    if (_passwordTextField.text.length == 0) {
        [self hud_showTips:@"请输入密码"];
        return NO;
    }
   
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _nameTextField) {
        [_nameTextField resignFirstResponder];
        [_userIdTextField becomeFirstResponder];
    } else if (textField == _userIdTextField) {
        [_userIdTextField resignFirstResponder];
        [_passwordTextField becomeFirstResponder];
    } else if (textField == _passwordTextField) {
        
    }
    return YES;
}

- (void)cretateHead
{
    [self addSubview:self.headImage];
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kHeadSize);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(100);
    }];
    
    [self.headImage cutRadius:kHeadSize * 0.5];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImage.mas_bottom);
        make.height.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    if (_viewType == LogViewType_Logon) {
        UIButton *headBtn = [UIButton ydd_buttonType:UIButtonTypeCustom target:self action:@selector(tapHeadImage)];
        [self addSubview:headBtn];
        [headBtn sendSubviewToBack:self.headImage];
        [headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.mas_equalTo(100);
            make.width.mas_equalTo(kHeadSize);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        self.nameLabel.text = @"点击编辑头像";
    }
}

- (void)addTextField
{
    [self addSubview:self.userIdTextField];
    [self addSubview:self.passwordTextField];
    if (_viewType == LogViewType_Logon) {
        [self addSubview:self.nameTextField];
        [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImage.mas_bottom).mas_offset(80);
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(kTextFieldH);
            
        }];
        [self.userIdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameTextField.mas_bottom).mas_offset(10);
            make.left.right.height.mas_equalTo(self.nameTextField);
        }];
    } else {
        [self.userIdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImage.mas_bottom).mas_offset(80);
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(kTextFieldH);
        }];
    }
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userIdTextField.mas_bottom).mas_offset(10);
        make.left.right.height.mas_equalTo(self.userIdTextField);
    }];

}

- (void)addLogButton
{
    [self addSubview:self.logBtn];
    [self.logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).mas_offset(30);
        make.left.right.height.mas_equalTo(self.passwordTextField);
    }];
    
    NSString *logTitle = @"";
    if (_viewType == LogViewType_Login) {
        logTitle = @"登录";
        
        UIButton *registerBtn = [UIButton ydd_buttonType:UIButtonTypeSystem target:self action:@selector(registerBtnAction)];
        [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        
        [self addSubview:registerBtn];
        [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.logBtn.mas_bottom).mas_offset(5);
            make.right.mas_equalTo(self.logBtn);
            make.size.mas_equalTo(CGSizeMake(40, 30));
        }];
        
    } else {
        logTitle = @"注册";
    }
    
    [self.logBtn setTitle:logTitle forState:UIControlStateNormal];
    
}

- (UIImageView *)headImage
{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] initWithImage:kHeadIconDefault];
        _headImage.contentMode = UIViewContentModeScaleAspectFill;
        _headImage.clipsToBounds = YES;
        _headImage.userInteractionEnabled = YES;
    }
    return _headImage;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel ydd_labelAlignment:NSTextAlignmentCenter fontSize:14 text:@""];
    }
    return _nameLabel;
}

- (UITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.placeholder = @"请输入昵称";
        _nameTextField.returnKeyType = UIReturnKeyGo;
        _nameTextField.font = [UIFont systemFontOfSize:14];
        _nameTextField.delegate = self;
        
        [self addLineToView:_nameTextField];
    }
    return _nameTextField;
}

- (UITextField *)userIdTextField
{
    if (!_userIdTextField) {
        _userIdTextField = [[UITextField alloc] init];
        _userIdTextField.placeholder = @"请输入手机号";
        _userIdTextField.keyboardType = UIKeyboardTypeNumberPad;
        _userIdTextField.returnKeyType = UIReturnKeyGo;
        _userIdTextField.font = [UIFont systemFontOfSize:14];
        _userIdTextField.delegate = self;
        
        [self addLineToView:_userIdTextField];
    }
    return _userIdTextField;
}

- (UITextField *)passwordTextField
{
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.returnKeyType = UIReturnKeyGo;
        _passwordTextField.font = [UIFont systemFontOfSize:14];
        _passwordTextField.delegate = self;
        
        [self addSubview:_passwordTextField];
        [self addLineToView:_passwordTextField];
    }
    return _passwordTextField;
}

- (void)addLineToView:(UIView *)view
{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorHexRGBA(0x666666, 1);
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (UIButton *)logBtn
{
    if (!_logBtn) {
        _logBtn = [UIButton ydd_buttonType:UIButtonTypeSystem target:self action:@selector(logBtnAction)];
        [_logBtn cutRadius:10];
        [_logBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_logBtn setBackgroundImage:[UIImage yy_imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
        
    }
    return _logBtn;
}

@end
