//
//  UIScrollView+YDDMJRefresh.m
//  YDDExercise
//
//  Created by ydd on 2021/4/15.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "UIScrollView+YDDMJRefresh.h"
#import "YDDMJGifFooter.h"
#import "YDDMJGifHeader.h"
#import <objc/runtime.h>


static const void *kHasPullRefresh = &kHasPullRefresh;

static const void *kHasLoadMore = &kHasLoadMore;

@implementation UITableView (YDDMJRefresh)

- (void)mj_pullRefresh:(void(^)(void))pullRefresh loadMoreRefresh:(void(^)(void))loadMore
{
    [self addHeadRefresh:pullRefresh];
    [self addFooterRefresh:loadMore];
}

- (void)addHeadRefresh:(void(^)(void))pullRefresh
{
    if (!pullRefresh) {
        return;
    }

    YDDMJGifHeader *header = [YDDMJGifHeader headerWithRefreshingBlock: pullRefresh];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.mj_header = header;
    
    self.hasPullRefresh = YES;
}


- (void)addFooterRefresh:(void(^)(void))loadMore
{
    if (!loadMore) {
        return;
    }
    
    YDDMJGifFooter *footer = [YDDMJGifFooter footerWithRefreshingBlock:loadMore];
    
    // 当上拉刷新控件出现50%时（出现一半），就会自动刷新。这个值默认是1.0（也就是上拉刷新100%出现时，才会自动刷新）
    footer.triggerAutomaticallyRefreshPercent = 0.8;
    UIFont *footerLabelFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    footer.stateLabel.font = footerLabelFont;
    footer.stateLabel.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:0.3];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已加载全部" forState:MJRefreshStateNoMoreData];
    //footer.stateLabel.hidden = YES;
    
    footer.refreshingTitleHidden = YES;
    footer.hidden = YES;
    self.mj_footer = footer;
    

    self.hasLoadMore = NO;
}

- (void)setHasPullRefresh:(BOOL)hasPullRefresh
{
    objc_setAssociatedObject(self, kHasPullRefresh, @(hasPullRefresh), OBJC_ASSOCIATION_ASSIGN);
    self.mj_header.hidden = !hasPullRefresh;
}

- (BOOL)hasPullRefresh
{
    id hasPull = objc_getAssociatedObject(self, kHasPullRefresh);
    if (hasPull) {
        return [hasPull boolValue];
    }
    return NO;
}

- (void)setHasLoadMore:(BOOL)hasLoadMore
{
    objc_setAssociatedObject(self, kHasLoadMore, @(hasLoadMore), OBJC_ASSOCIATION_ASSIGN);
    self.mj_footer.hidden = !hasLoadMore;
    [self.mj_footer resetNoMoreData];
}

- (BOOL)hasLoadMore
{
    id hasLoad = objc_getAssociatedObject(self, kHasLoadMore);
    if (hasLoad) {
        return [hasLoad boolValue];
    }
    return NO;
}


- (void)beginPullRefresh
{
    [self.mj_header beginRefreshing];
}

- (void)endRefreshing
{
    if (self.mj_header.state == MJRefreshStateRefreshing) {
        [self.mj_header endRefreshing];
    }
    if (self.mj_footer.state == MJRefreshStateRefreshing) {
        [self.mj_footer endRefreshing];
    }
}

- (void)noMoreData
{
    [self.mj_footer endRefreshingWithNoMoreData];
}

@end
