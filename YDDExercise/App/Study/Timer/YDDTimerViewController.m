//
//  YDDTimerViewController.m
//  YDDExercise
//
//  Created by ydd on 2021/3/17.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDTimerViewController.h"
#import "YDDProxy.h"
#import "YDDProxyObj.h"


/**
 1.NSTimer 造成循环应用的原因： NSTimer被NSRunLoop持有，NSTimer内部持有Target，而NSTimer又是Target的属性，Target和NSTimer相互持有造成循环应用，所有在释放时需要手动置为nil，但是Timer又被NSRunLoop持有，单独将Target的属性Timer置为nil还不能释放Timer，必须要先调用invalidate断开NSRunLoop对NSTimer的持有.
 优化：通过NSProxy协议的runtime消息转发方法让timer与target之间弱应用，这样释放只需要调用invalidate断开runloop对timer的持有即可释放。
 
 2.NSTimer在子线程中使用：
 NSTimer的定时任务实际上是由RunLoop来管理的，runloop定时触发timer方法，在子线程中runloop默认是不启动，所有在子线程中NSTimer任务默认是无效的，必须调用currentRunLoop方法子线程中才会有runloop，并且调用[[NSRunLoop currentRunLoop] run]才能启动Timer的定时任务。
 */

@interface YDDTimerViewController ()
{
    CFRunLoopRef _curRunLoop;
}


@property (nonatomic, strong) NSTimer *proxyTimer;
@property (nonatomic, strong) NSTimer *objTimer;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) NSTimer *threadTimer;

@end

@implementation YDDTimerViewController




- (void)dealloc
{
    NSLog(@"YDDTimerViewController dealloc");
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self destory];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    @weakify(self);
    self.navBarView.leftBlock = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    NSArray *arr = @[@"TimerProxy", @"TimerProxyObj", @"DispatchLink", @"子线程", @"perfrom"];
    NSMutableArray *mutArr = [NSMutableArray array];
    for (NSInteger i = 0; i < arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor greenColor]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [mutArr addObject:btn];
    }
    
    [mutArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:80 leadSpacing:100 tailSpacing:100];
    [mutArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
}

- (void)btnAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 100:
            [self startProxytimer];
            break;
        case 101:
            [self startObjTimer];
            break;
        case 102:
            [self startDisplayLink];
            break;
        case 103:
            [self startThreadTimer];
            break;
        case 104:
            [self performAcation];
            break;
            
        default:
            break;
    }
}

- (void)proxyTimerAction
{
    static NSInteger count = 0;
    UIButton *btn = (UIButton *)[self.view viewWithTag:100];
    if ([btn isKindOfClass:[UIButton class]]) {
        [btn setTitle:[NSString stringWithFormat:@"TimerProxy(%ld)", (long)count] forState:UIControlStateNormal];
    
    }
    count++;
    if (count > 60) {
        count = 0;
    }
}

- (void)objTimerAction
{
    static NSInteger count = 0;
    UIButton *btn = (UIButton *)[self.view viewWithTag:101];
    if ([btn isKindOfClass:[UIButton class]]) {
        [btn setTitle:[NSString stringWithFormat:@"TimerProxyObj(%ld)", (long)count] forState:UIControlStateNormal];
    
    }
    count++;
    if (count > 60) {
        count = 0;
    }
}

- (void)displayLinkAction
{
    static NSInteger count = 0;
    UIButton *btn = (UIButton *)[self.view viewWithTag:102];
    if ([btn isKindOfClass:[UIButton class]]) {
        [btn setTitle:[NSString stringWithFormat:@"DispatchLink(%ld)", (long)count] forState:UIControlStateNormal];
    
    }
    count++;
    if (count > 60) {
        count = 0;
    }
}

- (void)startThreadTimer
{
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadTimerAction) object:nil];
    thread.name = @"Thread Timer";
    thread.qualityOfService = NSQualityOfServiceDefault;
    [thread start];
}

- (void)threadTimerAction
{
//    [self.timerCondition lock];
    NSLog(@"cur thread : %@", [NSThread currentThread]);
    if (_threadTimer) {
        [_threadTimer invalidate];
        _threadTimer = nil;
        if (_curRunLoop) {
            CFRunLoopStop(_curRunLoop);
            _curRunLoop = nil;
        }
        
    } else {
        _threadTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:[YDDProxy ydd_proxyWithTarget:self] selector:@selector(threadTimerMethod) userInfo:nil repeats:YES];
        NSLog(@"threadTimerAction add befer");
        /// 启动runloop后，timer不加入runloop也可以启动
//        [[NSRunLoop currentRunLoop] addTimer:_threadTimer forMode:NSRunLoopCommonModes];
        _curRunLoop = CFRunLoopGetCurrent();
        NSLog(@"threadTimerAction run befer");
        /**
         启动runloop：
         1： run； 不建议使用，使用run启动runloop后无法调用CFRunLoopStop()停止runloop，导致线程无法停止。
         2：- (void)runUntilDate:(NSDate *)limitDate; 默认模式为defaultmodel， 可以设置runloop运行超时时间，超过时间自动停止。
         3：- (BOOL)runMode:(NSRunLoopMode)mode beforeDate:(NSDate *)limitDate， 可以设置模式和超时时间，推荐使用。
         [NSDate distantFuture] 获得一个未来永远达不到的时间期限。
         [NSDate distantPast] 获得一个过去永远达不到的时间期限。
         4：runloop调用run之后，后面的代码不会执行，只有调用 CFRunLoopStop()方法才会执行后面的代码。
         */
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        
       
        NSLog(@"threadTimerAction run after");
        NSLog(@"runLoop 停止运行");
       
    
        
        
    }
}

- (void)threadTimerMethod
{
    static NSInteger count = 0;
//    UIButton *btn = (UIButton *)[self.view viewWithTag:103];
//    if ([btn isKindOfClass:[UIButton class]]) {
//        [btn setTitle:[NSString stringWithFormat:@"子线程(%ld)", (long)count] forState:UIControlStateNormal];
//    }
    count++;
//    if (count > 60) {
//        count = 0;
//    }

    NSLog(@"threadTimerMethod count : %ld, thread : %@", (long)count, [NSThread currentThread]);
}

- (void)startProxytimer
{
    if (_proxyTimer) {
        [_proxyTimer invalidate];
        _proxyTimer = nil;
    } else {
        _proxyTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:[YDDProxy ydd_proxyWithTarget:self] selector:@selector(proxyTimerAction) userInfo:nil repeats:YES];
        [_proxyTimer fire];
    }
}

- (void)startObjTimer
{
    if (_objTimer) {
        [_objTimer invalidate];
        _objTimer = nil;
    } else {
        _objTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:[YDDProxyObj ydd_proxyWithTarget:self] selector:@selector(objTimerAction) userInfo:nil repeats:YES];
        [_objTimer fire];
    }
}

- (void)startDisplayLink
{
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    } else {
        _displayLink = [CADisplayLink displayLinkWithTarget:[YDDProxy ydd_proxyWithTarget:self] selector:@selector(displayLinkAction)];
        _displayLink.frameInterval = 60;
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

/**
 - (void)performSelector:(SEL)aSelector withObject:(nullable id)anArgument afterDelay:(NSTimeInterval)delay;
 perform延时方法内部是一个NSTimer，在子线程中Runloop默认不启动，所以timer无效，perform延时也就无效。由于无法获取其内部NStimer所以无法主动将其内部timer加入到runloop中，所以子线程中无法使用此方法，可以通过nstimer /dispatch实现延时操作
 
 */
- (void)performAcation
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        [self performSelector:@selector(performDealyAction) withObject:nil afterDelay:2];
        
    });
}



- (void)performDealyAction
{
    NSLog(@"performDealyAction : 延时任务");
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)destory
{
    if (_proxyTimer) {
        [_proxyTimer invalidate];
    }
    if (_objTimer) {
        [_objTimer invalidate];
    }
    if (_displayLink) {
        [_displayLink invalidate];
    }
    if (_threadTimer) {
        [_threadTimer invalidate];
        if (_curRunLoop) {
            CFRunLoopStop(_curRunLoop);
            _curRunLoop = nil;
        }
    }
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
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
