//
//  YDDVideoPullRefreshView.h
//  YDDExercise
//
//  Created by ydd on 2020/6/20.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    KXPullRefreshStatue_none = 0,
    KXPullRefreshStatue_began,
    KXPullRefreshStatue_refreshing,
    KXPullRefreshStatue_end
} KXPullRefreshStatue;


@interface YDDVideoPullRefreshView : UIView

@property (nonatomic, assign) KXPullRefreshStatue statue;

@property (nonatomic, assign) CGFloat roat;

@property (nonatomic, copy) void(^beganRefresh)(void);

- (void)updatePullOffsetY:(CGFloat)offsetY isBegan:(BOOL)isBegan isRefresh:(BOOL)isRefresh;

@end

NS_ASSUME_NONNULL_END
