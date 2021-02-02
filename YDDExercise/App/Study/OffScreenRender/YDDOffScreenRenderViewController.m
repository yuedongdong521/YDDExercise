//
//  YDDOffScreenRenderViewController.m
//  YDDExercise
//
//  Created by ydd on 2021/1/29.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDOffScreenRenderViewController.h"

#import "UIView+YDDCorner.h"

@interface YDDOffScreenRenderCell : UITableViewCell


@property (nonatomic, strong) NSArray <UIImageView*>* array;

@end

@implementation YDDOffScreenRenderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSMutableArray <UIView *>*arr = [NSMutableArray array];
        for (NSInteger i = 0; i < 6; i++) {
            UIImageView *testView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"defaultIcon"]];
            testView.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:testView];
            
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.text = [NSString stringWithFormat:@"%ld", (long)i];
            [testView addSubview:textLabel];
            [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsZero);
            }];
            [testView cutRadius:30];
//            [testView cutCorners:YDDCornerStyle_all radius:30 color:[UIColor whiteColor]];
            [arr addObject:testView];
        }
        self.array = [arr copy];
        
        [self.array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:15 tailSpacing:15];
        [self.array mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(arr.firstObject.mas_width);
        }];
    }
    return self;
}

- (void)update
{
    [self.array enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.image = [UIImage imageNamed:@"defaultIcon"];
    }];
    
}


@end


@interface YDDOffScreenRenderViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YDDOffScreenRenderViewController

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
        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0));
    }];
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[YDDOffScreenRenderCell class] forCellReuseIdentifier:NSStringFromClass([YDDOffScreenRenderCell class])];
        
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YDDOffScreenRenderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YDDOffScreenRenderCell class])];
    [cell update];
    return cell;
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
