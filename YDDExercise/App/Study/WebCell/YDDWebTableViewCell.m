//
//  YDDWebTableViewCell.m
//  YDDExercise
//
//  Created by ydd on 2021/5/7.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDWebTableViewCell.h"
#import "YDDWebView.h"

@interface YDDWebTableViewCell ()<YDDWebViewDelegate>

@property (nonatomic, strong) YDDWebView *webView;

@property (nonatomic, strong) NSIndexPath *path;

@end

@implementation YDDWebTableViewCell

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
        
        [self.contentView addSubview:self.webView];
        
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
    }
    return self;
}

- (YDDWebView *)webView
{
    if (!_webView) {
        _webView = [[YDDWebView alloc] init];
        _webView.delegate = self;
    }
    return _webView;
}





- (void)webView:(YDDWebView *)webView didChangedHeight:(CGFloat)height
{
    if (_cellModel.height == height) {
        return;
    }
    
    _cellModel.height = height;
    if (self.didChangedHeight) {
        self.didChangedHeight(height, _path);
    }
}

- (void)setCellModel:(YDDWebCellModel *)cellModel indexPath:(NSIndexPath *)indexPath
{
    if ([_cellModel.url isEqualToString:cellModel.url]) {
        return;
    }
    _cellModel = cellModel;
    _path = indexPath;
    [self.webView startLoadWithUrl:cellModel.url];
}




@end
