//
//  YDDUserListView.h
//  YDDExercise
//
//  Created by ydd on 2021/2/24.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDDUserInfoViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YDDUserListView : UIView

- (instancetype)initWithModel:(YDDUserInfoViewModel *)model;

@end

NS_ASSUME_NONNULL_END
