//
//  YDDSettingViewController.m
//  YDDExercise
//
//  Created by ydd on 2021/2/3.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDSettingViewController.h"

@interface YDDSettingViewController ()

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
