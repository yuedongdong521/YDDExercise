//
//  YDDVideoGuideView.h
//  YDDExercise
//
//  Created by ydd on 2020/6/23.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    KXVideoGuideType_pan = 0, // 滑动
    KXVideoGuideType_tap,
} KXVideoGuideType;

@interface YDDVideoGuideView : UIView

@property (nonatomic, copy) void(^scrollOffsetY)(CGFloat offsetY, BOOL isEnd, BOOL changed);

+ (void)showVideoTapGuideView;

+ (void)showVideoPanGuideViewCompleted:(void(^)(CGFloat offsetY, BOOL isEnd, BOOL changed))completed;

- (instancetype)initWithType:(KXVideoGuideType)guideType dismissBlock:(void(^)(void))dismissBlock;


@end

NS_ASSUME_NONNULL_END
