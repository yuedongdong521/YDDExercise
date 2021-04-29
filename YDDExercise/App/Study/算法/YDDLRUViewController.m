//
//  YDDLRUViewController.m
//  YDDExercise
//
//  Created by ydd on 2021/4/22.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDLRUViewController.h"

#import "YDDLRUCache.h"

@interface YDDLRUViewController ()

@end

@implementation YDDLRUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    @weakify(self);
    self.navBarView.leftBlock = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
        
    };
    
    __block NSInteger cacheId = 100;
    
    UIButton *cacheBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cacheBtn setTitle:@"存入" forState:UIControlStateNormal];
    [[cacheBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        cacheId++;
        NSNumber *num = [NSNumber numberWithInteger:cacheId];
        num.lruCacheId = [NSString stringWithFormat:@"%ld", (long)cacheId];
        [YDDLRUCache cacheObj:num];
        
        NSLog(@"存入数据 ： %@", num);
    }];
    
    [self.view addSubview:cacheBtn];
    
    [cacheBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
    
    UIButton *readBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [readBtn setTitle:@"读取" forState:UIControlStateNormal];
    [[readBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
      
        NSInteger max = cacheId - 100;
        if (max == 0) {
            return;
        }
        
        NSInteger cacheId = arc4random() % max + 100 + 1;
        
        NSNumber *num = (NSNumber *)[YDDLRUCache readCache:[NSString stringWithFormat:@"%@", @(cacheId)]];
        
        NSLog(@"读取数据 ： %@", num);
        
    }];
    
    [self.view addSubview:readBtn];
    
    [readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(200);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
    
    UIButton *debugBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [debugBtn setTitle:@"debug" forState:UIControlStateNormal];
    [[debugBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
      
        [YDDLRUCache debugNode];
        
    }];
    
    [self.view addSubview:debugBtn];
    
    [debugBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(300);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
    
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
