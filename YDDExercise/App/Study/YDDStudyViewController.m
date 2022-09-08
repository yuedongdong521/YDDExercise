//
//  YDDStudyViewController.m
//  YDDExercise
//
//  Created by ydd on 2020/12/2.
//  Copyright © 2020 ydd. All rights reserved.
//

#import "YDDStudyViewController.h"
#import <malloc/malloc.h>

typedef struct {
    double a;
    bool b;
    int c;
} Objc1;


typedef struct {
    bool b;
    double a;
    int c;
} Objc2;


@interface Class1 : NSObject

@property (nonatomic, assign) double a;

@property (nonatomic, assign) BOOL b;

@property (nonatomic, assign) int c;

@end

@implementation Class1



@end

@interface Class2 : NSObject

@property (nonatomic, assign) BOOL b;
@property (nonatomic, assign) double a;

@property (nonatomic, assign) int c;

@end

@implementation Class2



@end





@interface YDDStudyViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray <NSString *>* dataArray;

@property (nonatomic, copy) void(^studyBlock)(BOOL a);


@end

@implementation YDDStudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarView.title = @"学习";
    
    Objc2 obj2 = {1, YES, 1};
    Objc1 obj1 = {YES, 1, 1};
    
    Class1 *test1 = [[Class1 alloc] init];
    
    Class2 *test2 = [[Class2 alloc] init];
    
    //    test1.a = 1.0;
    
    
    NSLog(@" test1 malloc_size: %lu sizeof : %lu", malloc_size((__bridge const void *)(test1)), sizeof(test1));
    
    NSLog(@" test2 malloc_size: %lu sizeof : %lu", malloc_size((__bridge const void *)(test2)), sizeof(test2));
    
    NSLog(@"objc1 分配 ： %lu", malloc_size(&obj1));
    
    NSLog(@"objc2 分配 ： %lu", malloc_size(&obj2));
    
    NSLog(@" object1 : %lu", sizeof(obj1));
    
    NSLog(@" object2 : %lu", sizeof(obj2));
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavBarHeight, 0, kTabBarHeight, 0));
    }];
    

     self.studyBlock = [self testBlock];
    _studyBlock(NO);
}

- (void(^)(BOOL))testBlock
{
    NSString *text = @"11111";
    void(^block)(BOOL) = ^(BOOL a){
        NSLog(@"testBlock block : %d, %@", a, text);
    };
    
    block(YES);
    
    return block;
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
    Class TargetClass = NSClassFromString(self.dataArray[indexPath.row]);
    if (!TargetClass) {
        return;
    }
    
    UIViewController *obj = [[TargetClass alloc] init];
    if (![obj isKindOfClass:[UIViewController class]]) {
        return;
    }
    [self.navigationController pushViewController:obj animated:YES];
    
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
        _dataArray = @[@"YDDAnimationViewController", @"YDDRACViewController", @"YDDTextureViewController", @"YDDGradientColorTextViewController", @"YDDMenueObjVC", @"YDDOffScreenRenderViewController", @"YDDUserListViewController", @"YDDSwiftViewController", @"YDDRunLoopUserViewController", @"YDDTimerViewController", @"YDDLookViewController", @"YDDGradientLayerViewController", @"YDDScrollViewController"];
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
