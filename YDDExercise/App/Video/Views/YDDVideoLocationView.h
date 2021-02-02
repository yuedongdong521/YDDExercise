//
//  YDDVideoLocationView.h
//  YDDExercise
//
//  Created by ydd on 2020/6/18.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDDVideoLocationView : UIView

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *locationImage;

@property (nonatomic, strong) UILabel *locationName;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *distance;

@property (nonatomic, strong) UIImageView *goView;

@property (nonatomic, copy) void(^tapBlock)(void);


- (void)updateLocation:(NSString *)address distance:(NSString *)distance;

@end

NS_ASSUME_NONNULL_END
