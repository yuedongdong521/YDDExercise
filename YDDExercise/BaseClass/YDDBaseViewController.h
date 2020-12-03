//
//  YDDBaseViewController.h
//  YDDExercise
//
//  Created by ydd on 2019/7/20.
//  Copyright © 2019 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDDNavigationBarView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDDBaseViewController : UIViewController

@property (nonatomic, assign) BOOL hiddenStatuBar;

@property (nonatomic, assign) UIStatusBarStyle statuBarStyle;

@property (nonatomic, strong) YDDNavigationBarView *navBarView;

@property (nonatomic, assign) BOOL hiddenNavBarLeftBtn;

@property (nonatomic, assign) BOOL hiddenNavBarRightBtn;


- (void)leftAction;

- (void)rightAction;


@end

NS_ASSUME_NONNULL_END
