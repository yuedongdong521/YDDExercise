//
//  YDDUserListView.m
//  YDDExercise
//
//  Created by ydd on 2021/2/24.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDUserListView.h"
#import "YDDUserInfoCell.h"
#import "UIScrollView+YDDMJRefresh.h"

@interface YDDUserListView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) YDDUserInfoViewModel *viewModel;


@property (nonatomic, strong) UITableView *tableView;

@end


@implementation YDDUserListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithModel:(YDDUserInfoViewModel *)model
{
    self = [super init];
    if (self) {
        _viewModel = model;
        [self bindingModel];
        [self setupView];
    }
    return self;
}

- (void)updateConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [super updateConstraints];
}


#pragma mark --private
- (void)bindingModel
{
    /// 开始请求数据， RACCommand 通过execute方法执行订阅，
    [self.viewModel.refreshCommand execute:nil];
    
    @weakify(self);
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        YDDRefreshStatue statue = [x integerValue];
        
        if (statue & YDDRefreshStatue_refresh) {
            [self.tableView endRefreshing];
            [self.tableView reloadData];
        }
        
        if (statue & YDDRefreshStatue_loadMore) {
            [self.tableView endRefreshing];
        }
        
        if (statue & YDDRefreshStatue_noMore) {
            [self.tableView noMoreData];
            
        } else {
            self.tableView.hasLoadMore = YES;
        }
    
    }];
    
    [self.viewModel.loadMoreSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x isKindOfClass:[NSArray class]]) {
            NSArray *paths = (NSArray *)x;
            if (paths.count > 0) {
                [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
            }
        }
    }];
}

- (void)setupView
{
    [self addSubview:self.tableView];
    
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[YDDUserInfoCell class] forCellReuseIdentifier:@"cell"];
        
        @weakify(self);
        
        [_tableView mj_pullRefresh:^{
            @strongify(self);
            [self.viewModel.refreshCommand execute:nil];
        } loadMoreRefresh:^{
            @strongify(self);
            [self.viewModel.loadMoreCommand execute:nil];
        }];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [YDDUserInfoCell cellHeight];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YDDUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.infoModel = self.viewModel.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewModel.didClickedSubject sendNext:@(indexPath.row)];
}


@end
