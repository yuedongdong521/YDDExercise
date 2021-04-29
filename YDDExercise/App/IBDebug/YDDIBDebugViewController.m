//
//  YDDIBDebugViewController.m
//  YDDExercise
//
//  Created by ydd on 2021/4/19.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDIBDebugViewController.h"

@interface YDDIBDebugViewController ()

@end

IB_DESIGNABLE
@implementation YDDIBDebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navBarView.leftBlock = ^{
        
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
