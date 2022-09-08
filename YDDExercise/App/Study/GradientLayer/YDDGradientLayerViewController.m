//
//  YDDGradientLayerViewController.m
//  YDDExercise
//
//  Created by kx_iOS on 2022/8/11.
//  Copyright © 2022 ydd. All rights reserved.
//

#import "YDDGradientLayerViewController.h"

@interface YDDGradientLayerViewController ()

@end

@implementation YDDGradientLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    weakObj(self);
    self.navBarView.leftBlock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };

    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 100, 100)];
//    contentView.backgroundColor = UIColorHexRGBA(0xFFDC98, 0.16);
    [self.view addSubview:contentView];
    
    
    
    
    contentView.layer.cornerRadius = 8;
    contentView.layer.masksToBounds = YES;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    btn.frame = CGRectMake(0, 0, 100, 100);
    
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(id)UIColorHexRGBA(0xFFE795, 1).CGColor, (id)UIColorHexRGBA(0xEDD2AC, 1).CGColor];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.locations = @[@(0), @(1)];
    gradientLayer.frame = CGRectMake(0, 0, 100, 100);
    gradientLayer.cornerRadius = 8;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 100, 100) cornerRadius:8];
    maskLayer.path = path.CGPath;
    maskLayer.lineWidth = 2;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    gradientLayer.mask = maskLayer;
    
    [contentView.layer addSublayer:gradientLayer];
    
    
    
    
}

- (void)btnAction
{
    NSLog(@"btnAction");
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
