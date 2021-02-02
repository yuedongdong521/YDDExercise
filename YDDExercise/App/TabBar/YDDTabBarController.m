//
//  YDDTabBarController.m
//  YDDExercise
//
//  Created by ydd on 2019/7/26.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "YDDTabBarController.h"
#import "UIImage+YDDExtend.h"

#import "YDDHomeViewController.h"
#import "YDDPhotosViewController.h"
#import "YDDStudyViewController.h"
#import "YDDMineViewController.h"
#import "YDDVideoRecommendViewController.h"
#import "YDDTabBarBgView.h"

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


@interface YDDTabBarController ()<UITabBarControllerDelegate, UITabBarDelegate>

@property (nonatomic, strong) YDDTabBarBgView *tabBarBgView;

@property (nonatomic, assign) NSInteger curSeletedIndex;

@end

@implementation YDDTabBarController


- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        self.delegate = self;
        self.curSeletedIndex = -1;
        
        YDDTabBar *tabBar = [[YDDTabBar alloc] init];
        
        [tabBar.centerBtn addTarget:self action:@selector(centerAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self setValue:tabBar forKey:@"tabBar"];
        
        
        YDDVideoRecommendViewController *videoVC = [[YDDVideoRecommendViewController alloc] init];
        UIImage *videoImage = [UIImage imageNamed:@"video"];
        UIImage *videoSelectedImage = [UIImage imageNamed:@"videoSelected"];
        videoImage = [videoImage scallImageWidthScallSize:CGSizeMake(20, 20)];
        videoSelectedImage = [videoSelectedImage scallImageWidthScallSize:CGSizeMake(20, 20)];
        [self addChildVc:videoVC title:@"小视频" normalImg:videoImage selectImg:videoSelectedImage];
        
        YDDHomeViewController *homeVC = [[YDDHomeViewController alloc] init];
        
        UIImage *homeImage = [UIImage imageNamed:@"tabBarHome"];
        UIImage *homeSelectedImage = [UIImage imageNamed:@"tabBarHomeSelect"];
        homeImage = [homeImage scallImageWidthScallSize:CGSizeMake(20, 20)];
        homeSelectedImage = [homeSelectedImage scallImageWidthScallSize:CGSizeMake(20, 20)];
        
        [self addChildVc:homeVC title:@"首页" normalImg:homeImage selectImg:homeSelectedImage];
        
        YDDPhotosViewController *photosVC = [[YDDPhotosViewController alloc] init];
        UIImage *xiangceImage = [UIImage imageNamed:@"xiangce"];
        UIImage *xiangceSelectImage = [UIImage imageNamed:@"xiangceSelect"];
        xiangceImage = [xiangceImage scallImageWidthScallSize:CGSizeMake(20, 20)];
        xiangceSelectImage = [xiangceSelectImage scallImageWidthScallSize:CGSizeMake(20, 20)];

        
        [self addChildVc:photosVC title:@"相册" normalImg:xiangceImage selectImg:xiangceSelectImage];
        
        YDDStudyViewController *studyVC = [[YDDStudyViewController alloc] init];
        UIImage *studyImage = [UIImage imageNamed:@"study"];
        UIImage *studySelectImage = [UIImage imageNamed:@"studySelected"];
        studyImage = [studyImage scallImageWidthScallSize:CGSizeMake(20, 20)];
        studySelectImage = [studySelectImage scallImageWidthScallSize:CGSizeMake(20, 20)];
        
        [self addChildVc:studyVC title:@"学习" normalImg:studyImage selectImg:studySelectImage];
        
        YDDMineViewController *mineVC = [[YDDMineViewController alloc] init];
        UIImage *mineImage = [UIImage imageNamed:@"mine"];
        UIImage *mineSelectImage = [UIImage imageNamed:@"mineSelected"];
        mineImage = [mineImage scallImageWidthScallSize:CGSizeMake(20, 20)];
        mineSelectImage = [mineSelectImage scallImageWidthScallSize:CGSizeMake(20, 20)];
        
        [self addChildVc:mineVC title:@"我的" normalImg:mineImage selectImg:mineSelectImage];
        
        
        [self setViewControllers:@[videoVC, homeVC, photosVC, studyVC, mineVC]];
    
        [self clearTabbar];
        
        self.selectedIndex = 2;
        
        
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
    self.fd_prefersNavigationBarHidden = YES;
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"sub view : %@, frame : %@", NSStringFromClass(obj.class), NSStringFromCGRect(obj.frame));
    }];
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger curIndex = [self.tabBar.items indexOfObject:item];
    [self updateTabBar:curIndex];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    [self updateTabBar:selectedIndex];
    self.curSeletedIndex = selectedIndex;
}

- (void)clearTabbar
{
    UIImage *alphaImage =  [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(1, 1)];
    [self.tabBar setBackgroundImage:alphaImage];
    [self.tabBar setShadowImage:alphaImage];
    [self.tabBar setTintColor:[UIColor clearColor]];
    [self.tabBar setBarTintColor:[UIColor clearColor]];
    self.tabBar.translucent = YES;
    
    [self.tabBar insertSubview:self.tabBarBgView atIndex:0];
}

- (void)updateTabBar:(NSInteger)index
{
    if (self.curSeletedIndex == index) {
        return;
    }
    if (index == 0) {
        self.tabBarBgView.backgroundColor = [UIColor clearColor];
        self.tabBarBgView.lineView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.05];
       
    } else {
        self.tabBarBgView.backgroundColor = UIColorLightAndDark([UIColor whiteColor], UIColorHexRGBA(0x141416, 0.96));
        self.tabBarBgView.lineView.backgroundColor = UIColorLightAndDark(UIColorHexRGBA(0xf5f5f5, 1), UIColorHexRGBA(0x262629, 0.96));
    }
}


- (YDDTabBarBgView *)tabBarBgView
{
    if (!_tabBarBgView) {
        _tabBarBgView = [[YDDTabBarBgView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kTabBarHeight)];
    }
    return _tabBarBgView;
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
