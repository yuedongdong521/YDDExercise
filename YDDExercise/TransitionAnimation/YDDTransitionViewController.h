//
//  YDDTransitionViewController.h
//  YDDExercise
//
//  Created by ydd on 2019/7/24.
//  Copyright © 2019 QH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDDBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface YDDTransitionViewController : YDDBaseViewController


@property (nonatomic, assign) BOOL activePop;

@property (nonatomic, assign) BOOL activePush;

- (UIView *)transitionAnmateView;

/// 添加滑动pop手势
- (void)addPopInteractiveTransition;

@end

NS_ASSUME_NONNULL_END
