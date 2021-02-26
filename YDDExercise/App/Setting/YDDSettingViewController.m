//
//  YDDSettingViewController.m
//  YDDExercise
//
//  Created by ydd on 2021/2/3.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDSettingViewController.h"
#import "YDDSettingTableViewCell.h"
#import <KTVHTTPCache/KTVHTTPCache.h>


@interface YDDSettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <YDDSettingModel *>*array;

@end

@implementation YDDSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarView.title = @"设置";
    @weakify(self);
    self.navBarView.leftBlock = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0));
    }];
    
    [self.tableView reloadData];
    
}


- (NSMutableArray<YDDSettingModel *> *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
        YDDSettingModel *model = [[YDDSettingModel alloc] init];
        model.title = @"清理缓存";
        
        NSInteger size = [YDDFileManager ydd_readDireSize:@"KTVHTTPCache"];
        
        model.content = [NSString stringWithFormat:@"%.2fM", size / 1024.0 / 1024.0];
        [_array addObject:model];
    }
    return _array;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YDDSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.array[indexPath.item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YDDSettingModel *model = self.array[indexPath.item];
    if ([model.title isEqualToString:@"清理缓存"]) {
        [KTVHTTPCache cacheDeleteAllCaches];
        _array = nil;
        [self.tableView reloadData];
    }
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[YDDSettingTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
