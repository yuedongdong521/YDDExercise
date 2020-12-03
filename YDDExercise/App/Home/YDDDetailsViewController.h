//
//  YDDDetailsViewController.h
//  YDDExercise
//
//  Created by ydd on 2019/7/24.
//  Copyright © 2019 QH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDDTransitionViewController.h"
@class YDDHomeModel;
@class PhotoGroupItem;
NS_ASSUME_NONNULL_BEGIN

@interface YDDDetailsViewController : YDDTransitionViewController

@property (nonatomic, strong) YDDHomeModel *model;


@end

NS_ASSUME_NONNULL_END
