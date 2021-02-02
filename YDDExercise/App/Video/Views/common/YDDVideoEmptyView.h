//
//  YDDVideoEmptyView.h
//  YDDExercise
//
//  Created by ydd on 2020/6/23.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDDVideoEmptyView : UIView

+ (void)removeEmptyViewFromSuperView:(UIView *)superView;

+ (void)addEmptyViewToSuperView:(UIView *)superView clickBlock:(void(^)(void))clickBlock;

+ (void)addNetworkEmptyViewToSuperView:(UIView *)superView;

+ (void)addNetworkEmptyViewToSuperView:(UIView *)superView clickBlock:(void(^)(void))clickBlock;

+ (void)addLocationEmptyToSuperView:(UIView *)superView clickBlock:(void(^)(void))clickBlock;

+ (void)addErrorEmptyToSuperView:(UIView *)superView clickBlock:(void(^)(void))clickBlock;


@end

NS_ASSUME_NONNULL_END
