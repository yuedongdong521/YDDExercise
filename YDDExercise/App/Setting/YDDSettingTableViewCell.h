//
//  YDDSettingTableViewCell.h
//  YDDExercise
//
//  Created by ydd on 2021/2/8.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDDSettingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDDSettingTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) YDDSettingModel *model;

@end


NS_ASSUME_NONNULL_END
