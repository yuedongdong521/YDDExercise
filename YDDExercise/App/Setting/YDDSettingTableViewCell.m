//
//  YDDSettingTableViewCell.m
//  YDDExercise
//
//  Created by ydd on 2021/2/8.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDSettingTableViewCell.h"

@implementation YDDSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.contentLabel];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(15);
        }];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(self.label.mas_right).mas_offset(5);
        }];
        
    }
    return self;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = kFontPFMedium(16);
        _label.textColor = UIColorHexRGBA(0x333333, 1);
        _label.textAlignment = NSTextAlignmentLeft;
    }
    return _label;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = kFontPF(16);
        _contentLabel.textColor = UIColorHexRGBA(0x333333, 0.8);
        _contentLabel.textAlignment = NSTextAlignmentRight;
    }
    return _contentLabel;
}

- (void)setModel:(YDDSettingModel *)model
{
    _model = model;
    self.label.text = model.title;
    self.contentLabel.text = model.content;
}

@end
