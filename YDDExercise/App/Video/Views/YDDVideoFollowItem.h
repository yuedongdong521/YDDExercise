//
//  YDDVideoFollowItem.h
//  YDDExercise
//
//  Created by ydd on 2020/6/19.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDDVideoFollowItem : UIControl

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIImageView *imageView;

- (void)updateNum:(NSInteger)num;

@end

NS_ASSUME_NONNULL_END
