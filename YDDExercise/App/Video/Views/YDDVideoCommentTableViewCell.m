//
//  YDDVideoCommentTableViewCell.m
//  YDDExercise
//
//  Created by ydd on 2020/6/22.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoCommentTableViewCell.h"


@interface YDDVideoCommentTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIButton *supportBtn;

@property (nonatomic, strong) UILabel *supportNumLabel;

@property (nonatomic, strong) UILabel *authorLabel;




@end

@implementation YDDVideoCommentTableViewCell

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
    return 12 * 2 + 20 + 2;
}

+ (CGFloat)contentMaxWidth
{
    return ScreenWidth - 16 - 40 - 8 - 10 - 30 - 10;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self contentView];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.headImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.authorLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.supportBtn];
        [self addSubview:self.supportNumLabel];
        
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(13);
            make.left.mas_equalTo(16);
            make.width.height.mas_equalTo(40);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImageView.mas_top).mas_offset(-1);
            make.left.equalTo(self.headImageView.mas_right).mas_offset(8);
            make.height.mas_equalTo(20);
        }];
        
        [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
            make.left.mas_equalTo(self.nameLabel.mas_right).mas_offset(4);
            make.size.mas_equalTo(CGSizeMake(22, 12));
        }];
        
        [self.supportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImageView.mas_top).mas_offset(-4);
            make.right.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(30, 24));
        }];
        
        [self.supportNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(17);
            make.centerX.mas_equalTo(self.supportBtn.mas_centerX);
            make.top.mas_equalTo(self.supportBtn.mas_bottom);
        }];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).mas_offset(2);
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.mas_equalTo(self.supportBtn.mas_left).mas_offset(-10);
            make.bottom.mas_equalTo(-12);
        }];
        
        UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserAction:)];
        [self.headImageView addGestureRecognizer:headTap];
        
        UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserAction:)];
        [self.nameLabel addGestureRecognizer:nameTap];
        
    
        UITapGestureRecognizer *contentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTapAction:)];
        [self.contentLabel addGestureRecognizer:contentTap];
        
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lognGesAction:)];
        longGes.minimumPressDuration = 0.3;
        [self addGestureRecognizer:longGes];
        
        [longGes requireGestureRecognizerToFail:headTap];
        [longGes requireGestureRecognizerToFail:nameTap];
        [longGes requireGestureRecognizerToFail:contentTap];
    }
    return self;
}

- (void)updateCommentModel:(YDDVideoCommentModel *)commentModel indexPath:(NSIndexPath *)indexPath isAuthor:(BOOL)isAuthor
{
    _commentModel = commentModel;
    _indexPath = indexPath;
    self.nameLabel.text = _commentModel.nickName;
    self.authorLabel.hidden = !isAuthor;
    self.contentLabel.attributedText = commentModel.contentAtt;
    [self.headImageView yy_setImageWithURL:[NSURL URLWithString:commentModel.avatarUrl] placeholder:[UIImage imageNamed:@"headIcon"]];
    
    self.supportNumLabel.text = [NSString stringWithFormat:@"%ld", (long)commentModel.likeTotal];
    [self updateLikeStatue];
}

- (void)updateLikeStatue
{
    if (self.commentModel.dirty) {
        [self.supportBtn setImage:[UIImage imageNamed:@"homepage_comment_like_p"] forState:UIControlStateNormal];
        self.supportNumLabel.textColor = UIColorHexRGBA(0xFF3E8B, 0.8);
    } else {
        [self.supportBtn setImage:[UIImage imageNamed:@"homepage_comment_like"] forState:UIControlStateNormal];
        self.supportNumLabel.textColor = UIColorLightAndDark(UIColorHexRGBA(0x888888, 0.6), UIColorHexRGBA(0x888888, 0.8));
    }
}

- (void)supportBtnAction:(UIButton *)btn
{
    btn.enabled = NO;
    if (_likeBlock) {
        @weakify(self);
        self.commentModel.dirty = !self.commentModel.dirty;
        [self updateLikeTotal];
        [self updateLikeStatue];
        _likeBlock(self.commentModel, ^(YDDVideoCommentModel *model, BOOL success){
            @strongify(self);
            if (!success) {
                self.commentModel.dirty = !self.commentModel.dirty;
                [self updateLikeTotal];
                [self updateLikeStatue];
            }
            btn.enabled = YES;
        });
    }
    
    
}

- (void)updateLikeTotal
{
    if (self.commentModel.dirty) {
        self.commentModel.likeTotal++;
    } else {
        self.commentModel.likeTotal--;
    }
    
    if (self.commentModel.likeTotal < 0) {
        self.commentModel.likeTotal = 0;
    }
    self.supportNumLabel.text = [NSString stringWithFormat:@"%ld", (long)self.commentModel.likeTotal];
}

- (void)lognGesAction:(UILongPressGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateBegan) {
        if (self.longBlock) {
            self.longBlock(self.commentModel, self.indexPath);
        }
    }
}

- (void)contentTapAction:(UITapGestureRecognizer *)tap
{
    if (self.contentBlock) {
        self.contentBlock(self.commentModel, self.indexPath);
    }
}

- (void)tapUserAction:(UITapGestureRecognizer *)tap
{
    if (self.userBlock) {
        self.userBlock(self.commentModel);
    }
}


- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
        [_headImageView cutRadius:20];
        _headImageView.userInteractionEnabled = YES;
    }
    return _headImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kFontPFMedium(14);
        _nameLabel.textColor = UIColorHexRGBA(0x888888, 1);
        _nameLabel.userInteractionEnabled = YES;
    }
    return _nameLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = kFontPFMedium(14);
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.numberOfLines = 0;
        _contentLabel.userInteractionEnabled = YES;
    }
    return _contentLabel;
}

- (UIButton *)supportBtn
{
    if (!_supportBtn) {
        _supportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_supportBtn setImage:[UIImage imageNamed:@"homepage_like_btn"] forState:UIControlStateNormal];
        [_supportBtn setImageEdgeInsets:UIEdgeInsetsMake(4, 6, 4, 6)];
        [_supportBtn addTarget:self action:@selector(supportBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _supportBtn;
}

- (UILabel *)supportNumLabel
{
    if (!_supportNumLabel) {
        
        _supportNumLabel = [[UILabel alloc] init];
        _supportNumLabel.font = kFontPF(12);
        _supportNumLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
        _supportNumLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _supportNumLabel;
}

- (UILabel *)authorLabel
{
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = kFontPFMedium(8);
        _authorLabel.textColor = UIColorHexRGBA(0x12100F, 1);
        _authorLabel.textAlignment = NSTextAlignmentCenter;
        
        [_authorLabel cutRadius:1];
        _authorLabel.backgroundColor = UIColorHexRGBA(0xFFDE60, 1);
        _authorLabel.text = @"作者";
    }
    return _authorLabel;
}

@end




@implementation KXVideoCommentFirstCell

+ (CGFloat)cellHeight
{
    return 12 + 5 + 20 + 2;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.headImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
        }];
    }
    return self;
}

@end
