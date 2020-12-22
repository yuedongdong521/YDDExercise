//
//  YDDAnimationContentViewController.m
//  YDDExercise
//
//  Created by ydd on 2020/12/3.
//  Copyright © 2020 ydd. All rights reserved.
//

#import "YDDAnimationContentViewController.h"
#import "YDDDynamicsAnimationView.h"

#import "YDDCoordinateSystemView.h"

@interface YDDAnimationContentViewController ()

@property (nonatomic, assign) AnimationType type;

@end

@implementation YDDAnimationContentViewController

- (instancetype)initWithType:(AnimationType)type
{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    weakObj(self);
    self.navBarView.leftBlock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    
    switch (_type) {
        case AnimationType_Dynamics:
            [self addDynamicsAnimation];
            break;
        case AnimationType_System:
            [self addCoordinateSystemAnimation];
            break;
            
        default:
            break;
    }
    
}

- (void)addDynamicsAnimation
{
    YDDDynamicsAnimationView *view = [[YDDDynamicsAnimationView alloc]init];
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0));
    }];
}

- (void)addCoordinateSystemAnimation
{
    YDDCoordinateSystemView *view = [[YDDCoordinateSystemView alloc] initWithArrowSize:3];
    [self.view addSubview:view];
    
    CGFloat size = ScreenWidth - 40;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.mas_equalTo(size);
    }];
    
    [view updateXAxisValues:@[@(9), @(10), @(11), @(12), @(13)] yAxisValues:@[@(35000000), @(40000000), @(45000000), @(50000000), @(55000000)]];
    
    [view updateContentValues:@[@(37692726), @(44090812), @(46611220), @(50023884)]];
    
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
