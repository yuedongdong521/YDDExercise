//
//  YDDHomeHeaderView.h
//  YDDExercise
//
//  Created by ydd on 2019/7/23.
//  Copyright © 2019 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YDDHomeModel;
NS_ASSUME_NONNULL_BEGIN

@interface YDDHomeHeaderView : UICollectionReusableView


@property (nonatomic, strong) NSArray <YDDHomeModel*>* headArr;

@property (nonatomic, copy) void(^selectedBlock)(YDDHomeModel *model);

@end

NS_ASSUME_NONNULL_END
