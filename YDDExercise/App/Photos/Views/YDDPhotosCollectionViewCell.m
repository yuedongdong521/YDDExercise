//
//  YDDPhotosCollectionViewCell.m
//  YDDExercise
//
//  Created by ydd on 2019/7/17.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "YDDPhotosCollectionViewCell.h"
#import "YDDPhotoModel.h"


@interface YDDPhotosCollectionViewCell ()

@end

@implementation YDDPhotosCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)setModel:(YDDPhotoModel *)model
{
    if (![_model.imageURL.absoluteString isEqualToString:model.imageURL.absoluteString]) {
        _model = model;
        [_imageView yy_setImageWithURL:model.imageURL placeholder:[UIImage imageNamed:@"defaultIcon"]];
    }
}


@end
