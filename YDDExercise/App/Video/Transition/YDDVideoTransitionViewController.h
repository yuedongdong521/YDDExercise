//
//  YDDVideoTransitionViewController.h
//  YDDExercise
//
//  Created by ydd on 2020/6/23.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDDBaseViewController.h"

@interface YDDVideoTransitionViewController : YDDBaseViewController

@property (nonatomic, assign) BOOL hiddenPopAnimation;
@property (nonatomic, assign) BOOL hiddenPushAnimation;

- (UIView *)transitionAnmateView;

@end
