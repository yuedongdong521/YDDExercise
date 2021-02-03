//
//  YDDLeftSideBarView.m
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "YDDLeftSideBarView.h"

@interface YDDLeftSideBarView ()

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idLabel;

@property (nonatomic, strong) UIView *bgView;

@end

@implementation YDDLeftSideBarView

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        
        [superView addSubview:self.bgView];
        [superView insertSubview:self atIndex:0];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, kLeftSideBarWidth, 0, 0));
        }];
        
        [self createUI];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (frame.origin.x == -kLeftSideBarWidth) {
        self.bgView.hidden = YES;
    } else if (frame.origin.x == 0) {
        self.bgView.hidden = NO;
    }
}

- (void)setUserInfo:(YDDUserBaseInfoModel *)userInfo
{
    [self.headImageView yy_setImageWithURL:[userInfo.userIcon ydd_coverUrl] placeholder:kHeadIconDefault];
    
    self.nameLabel.text = [NSString stringWithFormat:@"昵称:%@", userInfo.userName];
    self.idLabel.text = [NSString stringWithFormat:@"id:%@", @(userInfo.userId)];
}

- (void)createUI
{
    [self addSubview:self.headImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.idLabel];
    
    UIButton *quitBtn = [UIButton ydd_buttonType:UIButtonTypeCustom title:@"退出登录" backgroundColor:[UIColor redColor] target:self action:@selector(quitAction)];
    [self addSubview:quitBtn];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(100);
        make.width.height.mas_equalTo(80);
    }];
    [self.headImageView cutRadius:40 borderWidth:1 borderColor:[UIColor whiteColor]];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_left);
        make.top.mas_equalTo(self.headImageView.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.mas_right).mas_offset(-15);
    }];
    
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.mas_right).mas_offset(-15);
    }];
    
    [quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 50));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(-50 - (kSafeBottom));
    }];
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
    }
    return _headImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel ydd_labelAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:16] text:nil];
    }
    return _nameLabel;
}

- (UILabel *)idLabel
{
    if (!_idLabel) {
        _idLabel = [UILabel ydd_labelAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:16] text:nil];
    }
    return _idLabel;
}

- (void)quitAction
{
    if (_logonBlock) {
        _logonBlock();
    }
    
}

- (void)dealloc
{
    NSLog(@"dealloc : %@", NSStringFromClass(self.class));
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

