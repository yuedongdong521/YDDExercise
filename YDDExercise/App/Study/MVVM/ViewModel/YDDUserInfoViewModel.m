//
//  YDDUserInfoViewModel.m
//  YDDExercise
//
//  Created by ydd on 2021/2/24.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDUserInfoViewModel.h"

@implementation YDDUserInfoViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configBinding];
    }
    return self;
}

- (void)configBinding
{
    @weakify(self);
    [self.refreshCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        if ([x isKindOfClass:[NSArray class]]) {
            self.dataArray = [NSMutableArray arrayWithArray:(NSArray *)x];
        }
        
        [self.refreshEndSubject sendNext:@(YDDRefreshStatue_refresh)];
    }];
    
    [[[self.refreshCommand.executing skip:1] take:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            NSLog(@"正在加载");
        }
    }];
    
    
    [self.loadMoreCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x isKindOfClass:[NSArray class]]) {
            [self.dataArray addObjectsFromArray:(NSArray *)x];
        }
        
        [self.refreshEndSubject sendNext:@(YDDRefreshStatue_loadMore)];
    }];
    
    
    
}

- (RACSubject *)didClickedSubject
{
    if (!_didClickedSubject) {
        _didClickedSubject = [RACSubject subject];
    }
    return _didClickedSubject;
}

- (RACSubject *)refreshDataSubject
{
    if (!_refreshDataSubject) {
        _refreshDataSubject = [RACSubject subject];
    }
    return _refreshDataSubject;
}

- (RACSubject *)refreshEndSubject
{
    if (!_refreshEndSubject) {
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
}

- (RACCommand *)refreshCommand
{
    if (!_refreshCommand) {
        @weakify(self);
        _refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [subscriber sendNext:[YDDUserInfoViewModel createInfoWithNum:10]];
                    [subscriber sendCompleted];
                });
                
                return nil;
            }];
        }];
    }
    return _refreshCommand;
}

- (RACCommand *)loadMoreCommand
{
    if (!_loadMoreCommand) {
        @weakify(self);
        _loadMoreCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [subscriber sendNext:[YDDUserInfoViewModel createInfoWithNum:10]];
                    [subscriber sendCompleted];
                });
                
                return nil;
            }];
        }];
    }
    return _loadMoreCommand;
}


+ (NSArray<YDDUserInfoModel *>*)createInfoWithNum:(NSInteger)num
{
    NSMutableArray <YDDUserInfoModel*>*mutArr = [NSMutableArray array];
    for (NSInteger i = 0; i < num; i++) {
        YDDUserInfoModel *model = [[YDDUserInfoModel alloc] init];
        model.icon = @"http://pic1.win4000.com/pic/b/e9/b6c3874c76_200_200.jpg";
        model.name = @"魔幻骑士";
        model.sign = @"夜未眠，寒月翩翩";
        [mutArr addObject:model];
    }
    return [mutArr copy];
}




@end
