//
//  YDDWebCellViewController.m
//  YDDExercise
//
//  Created by ydd on 2021/5/7.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDWebCellViewController.h"
#import "YDDWebCellModel.h"
#import "YDDWebTableViewCell.h"

@interface YDDWebCellViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <YDDWebCellModel *>*array;


@end

@implementation YDDWebCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    @weakify(self);
    self.navBarView.leftBlock = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.navBarView.mas_bottom);
    }];
    
    [self.tableView reloadData];
    
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        

        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        
        if (@available(iOS 13.0, *)) {
            _tableView.automaticallyAdjustsScrollIndicatorInsets = NO;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        [_tableView registerClass:[YDDWebTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.array[indexPath.row].height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YDDWebTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    @weakify(self);
    cell.didChangedHeight = ^(CGFloat height, NSIndexPath *path) {
        @strongify(self);
        [self.tableView reloadRowAtIndexPath:path withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    cell.backgroundColor = [UIColor greenColor];
    [cell setCellModel:self.array[indexPath.row] indexPath:indexPath];
    
    return cell;
}


- (NSMutableArray<YDDWebCellModel *> *)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < 10; i++) {
            YDDWebCellModel *model = [[YDDWebCellModel alloc] init];
            model.height = 44;
            model.url = @"https://dev.17kuxiu.com/uc/m/share/share.html";
            //@"http://www.nipic.com/show/12363554.html";
            [_array addObject:model];
        }
        
    }
    return _array;
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
