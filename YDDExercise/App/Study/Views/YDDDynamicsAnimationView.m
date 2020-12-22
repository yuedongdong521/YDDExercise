//
//  YDDDynamicsAnimationView.m
//  YDDExercise
//
//  Created by ydd on 2020/12/3.
//  Copyright © 2020 ydd. All rights reserved.
//

#import "YDDDynamicsAnimationView.h"

@interface YDDDYnamicsItemView : UIView<UIDynamicItem>



@end

@implementation YDDDYnamicsItemView



@end

@interface YDDDynamicsAnimationView ()<UIDynamicAnimatorDelegate>

@property (nonatomic, strong) YDDDYnamicsItemView *animationView;
/// 持有力学动画
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;

@end

@implementation YDDDynamicsAnimationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"自由落体", @"吸附引力", @"抛体运动", @"单摆运动"]];
        [segment addTarget:self action:@selector(segAction:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:segment];
        [segment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(40);
        }];
        
        [self addSubview:self.animationView];
        [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(60);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
    }
    return self;
}

- (void)segAction:(UISegmentedControl *)seg
{
    [self.dynamicAnimator removeAllBehaviors];
    NSLog(@"--- %s, index: %ld", __func__, (long)seg.selectedSegmentIndex);
    switch (seg.selectedSegmentIndex) {
        case 0:
            [self startGravityAnimation];
            break;
        case 1:
            [self startSnapAnimation];
            break;
        case 2:
            [self startPushAnimation];
            break;
        case 3:
            [self startAttachmentAnimation];
            break;
        default:
            break;
    }
}

- (void)startGravityAnimation
{
    UIGravityBehavior *gravityBehavior = [self createGravityBehaviorWithItems:@[self.animationView]];
    
    UICollisionBehavior *collision = [self createCollisionBehaviorWithItems:@[self.animationView]];
    
    [self.dynamicAnimator addBehavior:collision];
    
    /// 开始动画
    [self.dynamicAnimator addBehavior:gravityBehavior];
}

- (void)startSnapAnimation
{
    CGPoint p = CGPointZero;
    if (![self viewWithTag:1001]) {
        UIView *snapPoint = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - 50, kNavBarHeight + 20, 30, 30)];
        snapPoint.backgroundColor = [UIColor blackColor];
        snapPoint.layer.cornerRadius = 15;
        snapPoint.layer.masksToBounds = YES;
        snapPoint.tag = 1001;
        [self addSubview:snapPoint];
        p = snapPoint.center;
    } else {
        p = [self viewWithTag:1001].center;
    }
    
    UIGravityBehavior *gravityBehavior = [self createGravityBehaviorWithItems:@[self.animationView]];
    
    UISnapBehavior *snapBehavior = [self createSnapBehaviorWithItem:self.animationView point:p];
    
    
    UICollisionBehavior *collision = [self createCollisionBehaviorWithItems:@[self.animationView]];
    
    
    /// 开始动画
    [self.dynamicAnimator addBehavior:gravityBehavior];
    [self.dynamicAnimator addBehavior:collision];
    
    weakObj(self);
    collision.action = ^{
        [weakself gavityAction];
    };
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.dynamicAnimator addBehavior:snapBehavior];
    });
}

/// 抛体运动
- (void)startPushAnimation
{
    
    UIPushBehavior *push = [self createPushBehaviorWithItems:@[self.animationView]];
    
    UIGravityBehavior *gravityBehavior = [self createGravityBehaviorWithItems:@[self.animationView]];
    
    
    UICollisionBehavior *collision = [self createCollisionBehaviorWithItems:@[self.animationView]];
    
    [self.dynamicAnimator addBehavior:push];
    
    [self.dynamicAnimator addBehavior:collision];
    
    /// 开始动画
    [self.dynamicAnimator addBehavior:gravityBehavior];
}

- (void)startAttachmentAnimation
{
    [self.animationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.top.mas_equalTo(60);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CGPoint p = CGPointZero;
    if (![self viewWithTag:1002]) {
        UIView *snapPoint = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth - 20) * 0.5, (ScreenWidth - 20) * 0.5, 20, 20)];
        snapPoint.backgroundColor = [UIColor blackColor];
        snapPoint.layer.cornerRadius = 10;
        snapPoint.layer.masksToBounds = YES;
        snapPoint.tag = 1002;
        [self addSubview:snapPoint];
        p = snapPoint.center;
    } else {
        p = [self viewWithTag:1001].center;
    }
    
    
    UIGravityBehavior *gravityBehavior = [self createGravityBehaviorWithItems:@[self.animationView]];
    
    UICollisionBehavior *collision = [self createCollisionBehaviorWithItems:@[self.animationView]];
    
    UIAttachmentBehavior *att = [self createAttachmentWithItem:self.animationView point:p];
    
    [self.dynamicAnimator addBehavior:att];
    
    [self.dynamicAnimator addBehavior:collision];
    
    /// 开始动画
    [self.dynamicAnimator addBehavior:gravityBehavior];
}


- (void)gavityAction
{
    return;
    NSLog(@"重力 action time: %f, running: %d, %@", self.dynamicAnimator.elapsedTime, self.dynamicAnimator.running, NSStringFromCGRect(self.animationView.frame));
}

/// 添加重力
- (UIGravityBehavior *)createGravityBehaviorWithItems:(NSArray<id<UIDynamicItem>> *)items
{
    /// 初始化力学动画行为， 例：给items添加重力
    UIGravityBehavior *behavior = [[UIGravityBehavior alloc] initWithItems:items];
    
    weakObj(self);
    behavior.action = ^{
        [weakself gavityAction];
    };
    
    /// 设置重力矢量方向， 默认y轴方向
    behavior.gravityDirection = CGVectorMake(0, 1);
    
    /// 设置重力大小
//    behavior.magnitude = 10;
    /// 设置重力方向
//    behavior.angle = M_PI_2 ;
    
    /// 重力矢量方向与magnitude、angle效果等同
    
    return behavior;
}

/// 添加吸附
- (UISnapBehavior *)createSnapBehaviorWithItem:(id<UIDynamicItem>)item point:(CGPoint)point
{
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:item snapToPoint:point];
    snap.damping = 10;//阻尼系数
    return snap;
}

/// 设置碰撞边界
- (UICollisionBehavior *)createCollisionBehaviorWithItems:(NSArray<id<UIDynamicItem>> *)items
{
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:items];
    // 边界刚体碰撞
    collision.translatesReferenceBoundsIntoBoundary = YES;
    collision.collisionMode = UICollisionBehaviorModeBoundaries;
    
    return collision;
}

/// 添加作用力
- (UIPushBehavior *)createPushBehaviorWithItems:(NSArray<id<UIDynamicItem>> *)items
{
    UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:items
                                                            mode:UIPushBehaviorModeInstantaneous];
    //    UIPushBehaviorModeContinuous 持续作用力
    //    UIPushBehaviorModeInstantaneous 瞬间作用力
    push.active = YES;
    push.pushDirection = CGVectorMake(0.3, 0);
    
    return push;
}

/// 添加活动铰支点
- (UIAttachmentBehavior *)createAttachmentWithItem:(id<UIDynamicItem>)item point:(CGPoint)point
{
    UIAttachmentBehavior *att = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:point];
    /// 临界点阻尼
    att.damping = 0;
    /// 频率
    att.frequency = 100;
    att.frictionTorque = 0.1;
    
    return att;
}

- (UIDynamicAnimator *)dynamicAnimator
{
    if (!_dynamicAnimator) {
        /// 初始化动画持有者， 例：在self 画布中做力学动画
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
        _dynamicAnimator.delegate = self;
    }
    return _dynamicAnimator;
}


#pragma mark - UIDynamicAnimatorDelegate
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    /// 动画完成
    NSLog(@"--- %s ", __func__);
}


- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator
{
    NSLog(@"--- %s ", __func__);
}


- (YDDDYnamicsItemView *)animationView
{
    if (!_animationView) {
        _animationView = [[YDDDYnamicsItemView alloc] init];
        _animationView.backgroundColor = [UIColor cyanColor];
    }
    return _animationView;
}


@end
