//
//  YDDUserInfoCell.h
//  YDDExercise
//
//  Created by ydd on 2021/2/24.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDDUserInfoModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface YDDUserInfoCell : UITableViewCell

@property (nonatomic, strong) YDDUserInfoModel *infoModel;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
