//
//  YDDSwiftViewController.m
//  YDDExercise
//
//  Created by ydd on 2021/3/2.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDSwiftViewController.h"
#import "YDDExercise-Swift.h"


@interface YDDSwiftViewController ()



@end

@implementation YDDSwiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    YDDStudySwiftVC *vc = [[YDDStudySwiftVC alloc] init];

    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    vc.view.frame = self.view.bounds;
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
