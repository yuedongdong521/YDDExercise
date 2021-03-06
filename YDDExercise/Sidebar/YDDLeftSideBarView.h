//
//  YDDLeftSideBarView.h
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#define kLeftSideBarWidth 200
NS_ASSUME_NONNULL_BEGIN


@interface YDDLeftSideBarView : UIView

@property (nonatomic, copy) void (^logonBlock)(void);

@property (nonatomic, strong) YDDUserBaseInfoModel *userInfo;


- (instancetype)initWithTabBarVC:(UITabBarController *)tabBarVC;

- (void)hiddenSideBar:(BOOL)hidden animation:(BOOL)animation;

@end



NS_ASSUME_NONNULL_END
