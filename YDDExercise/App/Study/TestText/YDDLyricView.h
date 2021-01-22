//
//  YDDLyricView.h
//  YDDExercise
//
//  Created by ydd on 2021/1/22.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDDLyricModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YDDLyricView : UIView

@property (nonatomic, copy) NSArray <YDDLyricModel *>*lyricList;


- (instancetype)initWithFrame:(CGRect)frame line:(CGFloat)line;

- (void)start;


@end

NS_ASSUME_NONNULL_END
