//
//  YDDUserInfoViewModel.h
//  YDDExercise
//
//  Created by ydd on 2021/2/24.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDDUserInfoModel.h"

typedef enum : NSUInteger {
    YDDRefreshStatue_refresh = 1 << 0,
    YDDRefreshStatue_loadMore = 1 << 1,
    YDDRefreshStatue_noMore = 1 << 2,
} YDDRefreshStatue;


NS_ASSUME_NONNULL_BEGIN

@interface YDDUserInfoViewModel : NSObject

@property (nonatomic, strong) NSMutableArray<YDDUserInfoModel*>* dataArray;

/// 刷新指令
@property (nonatomic, strong) RACCommand *refreshCommand;
/// 加载更多指令
@property (nonatomic, strong) RACCommand *loadMoreCommand;

@property (nonatomic, strong) RACSubject *refreshDataSubject;


@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACSubject *didClickedSubject;


@end

NS_ASSUME_NONNULL_END
