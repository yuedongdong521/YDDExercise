//
//  YDDHomeCollectionViewCell.h
//  YDDExercise
//
//  Created by ydd on 2019/7/23.
//  Copyright © 2019 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YDDHomeModel;
NS_ASSUME_NONNULL_BEGIN

#define kLabelHeight 20

@interface YDDHomeCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) YDDHomeModel *model;

@end

NS_ASSUME_NONNULL_END
