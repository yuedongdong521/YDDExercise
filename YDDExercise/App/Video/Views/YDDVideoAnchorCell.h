//
//  YDDVideoAnchorCell.h
//  YDDExercise
//
//  Created by ydd on 2020/6/19.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YDDAnchorModel.h"

#define KXVideoAnchorHeight 85

NS_ASSUME_NONNULL_BEGIN

@interface YDDVideoAnchorCell : UICollectionViewCell

@property (nonatomic, strong) UIView *headBord;
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIImageView *headImage;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIView *animationView;

@property (nonatomic, strong) YDDAnchorModel *liveRoomModel;


- (void)updateModel:(YDDAnchorModel *)liveRoomModel;


- (void)startAnimation;

- (void)removeAnimation;


@end

NS_ASSUME_NONNULL_END
