//
//  YDDLeftSideBarView.h
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "YDDBaseViewController.h"

#define kLeftSideBarWidth 200
NS_ASSUME_NONNULL_BEGIN

@interface YDDLeftSideBarView : UIView

@property (nonatomic, copy) void (^logonBlock)(void);

@property (nonatomic, strong) YDDUserBaseInfoModel *userInfo;


@end

NS_ASSUME_NONNULL_END
