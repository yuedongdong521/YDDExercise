//
//  YDDVideoAnchorCollectionView.h
//  YDDExercise
//
//  Created by ydd on 2020/6/19.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YDDVideoAnchorCell.h"
#import "YDDAnchorModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YDDVideoAnchorCollectionView : UIView

@property (nonatomic, strong) NSArray <YDDAnchorModel*>*attentionList;

@property (nonatomic, copy) void(^didselected)(YDDAnchorModel* model);

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
