//
//  YDDAnimationViewController.m
//  YDDExercise
//
//  Created by ydd on 2020/12/3.
//  Copyright © 2020 ydd. All rights reserved.
//

#import "YDDAnimationViewController.h"
#import "YDDAnimationContentViewController.h"
#import "YDDExercise-Swift.h"

@interface YDDAnimationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray <NSString *>* dataArray;

@end

@implementation YDDAnimationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarView.title = @"iOS动画";
    weakObj(self);
    self.navBarView.leftBlock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavBarHeight, 0, kTabBarHeight, 0));
    }];
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = kFontPFMedium(14);
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item < 2) {
        YDDAnimationContentViewController *obj = [[YDDAnimationContentViewController alloc] initWithType:indexPath.row];
        obj.navBarView.title = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:obj animated:YES];
        return;
    }
    
    if (indexPath.item == 2) {
        YDDCollectionStyleVC *vc = [[YDDCollectionStyleVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}



- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor grayColor];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.sectionFooterHeight = 0.001;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        
    }
    return _tableView;
}

- (NSArray<NSString *> *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@"力学动画", @"坐标系", @"cellStyle"];
    }
    return _dataArray;
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
