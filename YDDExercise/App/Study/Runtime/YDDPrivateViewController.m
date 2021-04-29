//
//  YDDPrivateViewController.m
//  YDDExercise
//
//  Created by ydd on 2021/4/13.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDPrivateViewController.h"
#import "YDDPrivateObject.h"
#import <objc/runtime.h>

@interface YDDPrivateViewController ()

@property (nonatomic, strong) YDDPrivateObject *privateObj;

@end

@implementation YDDPrivateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    @weakify(self);
    self.navBarView.leftBlock = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [self testPrivate];
    
    [self.privateObj addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
}

- (void)removeObserver
{
    [self.privateObj removeObserver:self forKeyPath:@"name"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"name"]) {
        NSLog(@"kvo监听回调 ： %@", change[NSKeyValueChangeNewKey]);
    }
}


- (void)testPrivate
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:[self.privateObj readName] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(privateAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20));
        make.top.equalTo(@(100));
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
}

- (YDDPrivateObject *)privateObj
{
    if (!_privateObj) {
        _privateObj = [[YDDPrivateObject alloc] init];
    }
    return _privateObj;
}

/// 使用runtime修改属性的值，其setter方法不会调用，kvo也监听不到
- (void)privateAction:(UIButton *)btn
{
    static int count = 0;
    
    if (count == 0) {
        [self.privateObj changeName:@"外部调用方法修改"];
    } else if (count == 1) {
        [self.privateObj setValue:@"KVC修改" forKey:@"name"];
    } else if (count == 2) {
        /// 使用_name修改name，是直接修改成员变量name，属性name的set方法不会调用，kvo也不会调用
        [self.privateObj setValue:@"kvc修改，k 带_ " forKey:@"_name"];
    } else if (count == 3) {
        unsigned int count;
        Ivar *varList = class_copyIvarList([self.privateObj class], &count);
        for (int i = 0; i < count; i++) {
            Ivar p = varList[i];
            const char *p_char = ivar_getName(p);
            NSString *name = [NSString stringWithUTF8String:p_char];
            if ([name isEqualToString:@"_name"]) {
                object_setIvar(self.privateObj, p, @"runtime修改");
            }
//
//            if (strcmp(p_char, "name")) {
//                object_setIvar(self.privateObj, p, @"runtime修改");
//            }
        }
        free(varList);
    }
    
    [btn setTitle:[self.privateObj readName] forState:UIControlStateNormal];
    count++;
    if (count > 3) {
        count = 0;
    }
    
    
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
