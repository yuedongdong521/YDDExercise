//
//  YDDPhotoPreCollectionViewCell.h
//  YDDExercise
//
//  Created by ydd on 2019/7/17.
//  Copyright © 2019 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YDDPhotoModel;
NS_ASSUME_NONNULL_BEGIN

@interface YDDPhotoPreCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) YDDPhotoModel *model;

@end

NS_ASSUME_NONNULL_END
