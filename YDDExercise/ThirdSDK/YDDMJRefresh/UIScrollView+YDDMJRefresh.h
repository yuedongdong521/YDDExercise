//
//  UIScrollView+YDDMJRefresh.h
//  YDDExercise
//
//  Created by ydd on 2021/4/15.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (YDDMJRefresh)

@property (nonatomic, assign) BOOL hasPullRefresh;

@property (nonatomic, assign) BOOL hasLoadMore;

- (void)mj_pullRefresh:(void(^)(void))pullRefresh loadMoreRefresh:(void(^)(void))loadMore;

- (void)addHeadRefresh:(void(^)(void))pullRefresh;

- (void)addFooterRefresh:(void(^)(void))loadMore;

- (void)beginPullRefresh;

- (void)endRefreshing;

- (void)noMoreData;

@end

NS_ASSUME_NONNULL_END
