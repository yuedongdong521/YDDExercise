//
//  YDDMenueObjVC.m
//  YDDExercise
//
//  Created by ydd on 2021/1/28.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDMenueObjVC.h"
#import "YDDExercise-Swift.h"

@implementation YDDMenueObjVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    YDDMenueViewController *vc = [[YDDMenueViewController alloc] init];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

@end
