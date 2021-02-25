//
//  YDDUserInfoCell.m
//  YDDExercise
//
//  Created by ydd on 2021/2/24.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDUserInfoCell.h"
#import "UIView+YDDCorner.h"

@interface YDDUserInfoCell ()

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *signLabel;

@end


@implementation YDDUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight
{
    return 60;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.signLabel];
        
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
            make.height.mas_equalTo(self.headImageView.mas_width);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView.mas_right);
            make.top.mas_equalTo(self.headImageView.mas_top);
            make.bottom.mas_equalTo(self.headImageView.mas_centerY);
            make.right.mas_equalTo(-15);
        }];
        
        [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom);
            make.bottom.mas_equalTo(self.headImageView.mas_bottom);
        }];
        
        [self.headImageView ydd_cutCorners:YDDCornerStyle_all radius:5 color:[UIColor whiteColor]];
        
    }
    return self;
}

- (void)setInfoModel:(YDDUserInfoModel *)infoModel
{
    _infoModel = infoModel;
    [self.headImageView yy_setImageWithURL:[NSURL URLWithString:_infoModel.icon] placeholder:[UIImage imageNamed:@"defaultIcon"]];
    self.nameLabel.text = _infoModel.name;
    self.signLabel.text = _infoModel.sign;
}


- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headImageView;
}


- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kFontPF(16);
        _nameLabel.textColor = UIColorHexRGBA(0x333333, 1);
    }
    return _nameLabel;
}

- (UILabel *)signLabel
{
    if (!_signLabel) {
        _signLabel = [[UILabel alloc] init];
        _signLabel.font = kFontPF(14);
        _signLabel.textColor = UIColorHexRGBA(0x333333, 0.8);
    }
    return _signLabel;
}

@end
