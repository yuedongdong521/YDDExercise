//
//  YDDTabBarController.m
//  YDDExercise
//
//  Created by ydd on 2019/7/26.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "YDDTabBarController.h"
#import "YDDHomeViewController.h"
#import "YDDPhotosViewController.h"
#import "UIImage+YDDExtend.h"

@interface YDDTabBar : UITabBar
@property (nonatomic, strong) UIButton *centerBtn;
@end

@implementation YDDTabBar


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.centerBtn];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat itemW = screenWidth / 3.0;
    __block NSInteger index = 0;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (index == 1) {
                self.centerBtn.center = CGPointMake(screenWidth * 0.5, obj.center.y - 10);
                index++;
            }
            CGRect rect = obj.frame;
            rect.origin.x =  itemW * index;
            rect.size.width = itemW;
            obj.frame = rect;
            index++;
        }
    }];
    
    
}

- (UIButton *)centerBtn
{
    if (!_centerBtn) {
        _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _centerBtn.layer.masksToBounds = YES;
        _centerBtn.layer.cornerRadius = 32;
        _centerBtn.frame = CGRectMake(0, 0, 64, 64);
        _centerBtn.imageEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
        [_centerBtn setBackgroundImage:[UIImage imageNamed:@"0.jpg"] forState:UIControlStateNormal];
        [_centerBtn setBackgroundImage:[UIImage imageNamed:@"1.jpg"] forState:UIControlStateSelected];
        
    }
    return _centerBtn;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.isHidden) {
        if (CGRectContainsPoint(self.centerBtn.frame, point)) {
            return self.centerBtn;
        }
    }
    return [super hitTest:point withEvent:event];
}


@end


static YDDTabBarController *_tabBar;


@interface YDDTabBarController ()


@end

@implementation YDDTabBarController


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        YDDTabBar *tabBar = [[YDDTabBar alloc] init];
        
        [tabBar.centerBtn addTarget:self action:@selector(centerAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self setValue:tabBar forKey:@"tabBar"];
        YDDHomeViewController *homeVC = [[YDDHomeViewController alloc] init];
        YDDPhotosViewController *photosVC = [[YDDPhotosViewController alloc] init];
        UIImage *homeImage = [UIImage imageNamed:@"tabBarHome"];
        UIImage *homeSelectedImage = [UIImage imageNamed:@"tabBarHomeSelect"];
        homeImage = [homeImage scallImageWidthScallSize:CGSizeMake(20, 20)];
        homeSelectedImage = [homeSelectedImage scallImageWidthScallSize:CGSizeMake(20, 20)];
        
        [self addChildVc:homeVC title:@"首页" normalImg:homeImage selectImg:homeSelectedImage];
        
        UIImage *xiangceImage = [UIImage imageNamed:@"xiangce"];
        UIImage *xiangceSelectImage = [UIImage imageNamed:@"xiangceSelect"];
        xiangceImage = [xiangceImage scallImageWidthScallSize:CGSizeMake(20, 20)];
        xiangceSelectImage = [xiangceSelectImage scallImageWidthScallSize:CGSizeMake(20, 20)];

        [self addChildVc:photosVC title:@"相册" normalImg:xiangceImage selectImg:xiangceSelectImage];
        
        [self setViewControllers:@[homeVC, photosVC]];
    
        self.tabBar.translucent = NO;
        
        
    }
    return self;
}


- (void)centerAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    NSLog(@"tabBar conter clicked");
    
}



- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title normalImg:(UIImage *)normalImg selectImg:(UIImage *)selectImg
{
    childVc.tabBarItem.image =  [normalImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [selectImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.title = title;
    [childVc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateSelected];
    childVc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4);
    childVc.tabBarItem.imageInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"sub view : %@, frame : %@", NSStringFromClass(obj.class), NSStringFromCGRect(obj.frame));
    }];
}

- (void)dealloc
{
    NSLog(@"dealloc : %@", NSStringFromClass(self.class));
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
