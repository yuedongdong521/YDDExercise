//
//  YDDNavigationBarView.h
//  YDDExercise
//
//  Created by ydd on 2019/7/20.
//  Copyright © 2019 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDDNavigationBarView : UIView

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) void (^leftBlock)(void);

@property (nonatomic, copy) void (^rightBlock)(void);

@end

NS_ASSUME_NONNULL_END
