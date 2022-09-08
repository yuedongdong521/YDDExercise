//
//  YDDScrollViewController.m
//  YDDExercise
//
//  Created by kx_iOS on 2022/8/17.
//  Copyright © 2022 ydd. All rights reserved.
//

#import "YDDScrollViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface YDDScrollViewController ()

@property (nonatomic, strong) UIScrollView *baseScrollView;

@property (nonatomic, strong) UIScrollView *subScrollView;

@property (nonatomic, strong) UILabel *testView;

@end

@implementation YDDScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.view addSubview:self.baseScrollView];
    
    CGFloat w = 200;
    CGFloat h = 300;
    
    self.baseScrollView.frame = CGRectMake(20, 80, 250, h);
    
    [self.baseScrollView addSubview:self.subScrollView];
    self.subScrollView.frame = CGRectMake(0, 0, w, h);
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(w, 0, w, h)];
    baseView.backgroundColor = [UIColor redColor];
    [self.baseScrollView addSubview:baseView];
    
    NSArray <UIColor *>* colors = @[[UIColor cyanColor], [UIColor yellowColor]];
    
    for (NSInteger i = 0; i < 2; i++) {
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(i * w, 0, w, h)];
        subView.backgroundColor = colors[i];
        [self.subScrollView addSubview:subView];
    }
    
    self.baseScrollView.contentSize = CGSizeMake(w * 2, h);
    self.subScrollView.contentSize = CGSizeMake(w * 2, h);
    
    
    UILabel *tranView = [[UILabel alloc] initWithFrame:CGRectMake(20, 400, 100, 150)];
    tranView.backgroundColor = [UIColor redColor];
    tranView.textAlignment = NSTextAlignmentCenter;
    tranView.text = @"原图";
    [self.view addSubview:tranView];
    
    self.testView = [[UILabel alloc] initWithFrame:CGRectMake(130, 400, 100, 150)];
    self.testView.backgroundColor = [UIColor cyanColor];
    self.testView.text = @"测试";
    [self.view addSubview:_testView];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 550, 200, 50)];
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    NSMutableSet <NSNumber *>*set = [NSMutableSet set];
    NSNumber *a = @(1);
    NSNumber *b = @(1);
    NSLog(@"ap = %p, bp = %p", &a, &b);
    [set addObject:a];
    
    if (a == b) {
        NSLog(@"a == b");
    }
    if (![set containsObject:b]) {
        [set addObject:b];
    }
    
    NSLog(@" set : %@", set);
    
    [set addObject:b];
    NSLog(@" set : %@", set);
    
    self.testView.frame = CGRectMake(0, 0, 0, -1);
    self.testView.center = CGPointMake(2, 2);

}

- (void)sliderAction:(UISlider *)slider
{
    CATransform3D trans = CATransform3DTranslate(CATransform3DIdentity, 10, 10, slider.value * 100);
        
    self.testView.layer.transform = trans;
    
    if (@available(iOS 13.0, *)) {
        self.testView.transform3D = trans;
    } else {
        // Fallback on earlier versions
    }
}


- (UIScrollView *)baseScrollView
{
    if (!_baseScrollView) {
        _baseScrollView = [[UIScrollView alloc] init];
//        _baseScrollView.pagingEnabled = YES;
//        _baseScrollView.bounces = NO;
        _baseScrollView.backgroundColor = [UIColor greenColor];
        
    }
    return _baseScrollView;
}

- (UIScrollView *)subScrollView
{
    if (!_subScrollView) {
        _subScrollView = [[UIScrollView alloc] init];
        _subScrollView.pagingEnabled = YES;
        _subScrollView.bounces = NO;
        _subScrollView.backgroundColor = [UIColor grayColor];
    }
    return _subScrollView;
}



@end
