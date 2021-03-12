//
//  YDDRunLoopUserViewController.m
//  YDDExercise
//
//  Created by ydd on 2021/3/9.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDRunLoopUserViewController.h"

const NSInteger TaskMax = 10;

@interface YDDRunLoopUserViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *tasks;



@end

void callBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    //C语言与OC的交换用到桥接 __bridge
    //处理控制器加载图片的事情
    YDDRunLoopUserViewController *vc = (__bridge YDDRunLoopUserViewController*)info;
    if (vc.tasks.count == 0) {
        return;
    }
    void(^task)(void) = vc.tasks.firstObject;
    task();
    [vc.tasks removeObject:task];
}

/**
 /// RunLoop源码
 void CFRunLoopRun(void) {
     int32_t result;
     do {
         result = CFRunLoopRunSpecific(CFRunLoopGetCurrent(), kCFRunLoopDefaultMode, 1.0e10, false);
     } while (kCFRunLoopRunStopped != result && kCFRunLoopRunFinished != result);
 }
 
 /// RunLoop 循环监听事件， 其实RunLoop表示一直在运行着的循环或者从上面的定义源码中可以看出就是一个do..while..循环。当启动一个iOS APP时主线程启动与其对应的RunLoop也已经开启。如果不杀掉APP则APP一直运行，就是因为RunLoop循环一直为开启状态保证主线程不会被摧毁。这也是RunLoop的作用之一保证线程不退出。RunLoop在循环过程中监听事件，当前线程有任务时，唤醒当当线程去执行任务，任务执行完成以后，使当前线程进入休眠状态。当然这里的休眠不同于我们自己写的死循环(while(1);)，它在休眠时几乎不会占用系统资源，当然这是由操作系统内核去负责实现的。
 UIApplicationMain()函数方法会默认为主线程设置一个NSRunLoop对象，这个循环会随时监听屏幕上由用户触摸所带来的底层消息并将其传递给主线程去
 处理，当点击一个button事件的传递从图上的调用栈可以看出。（监听的范围还包含时钟/网络）RunLoop循环与While循环的区别在于，RunLoop会在没有事件发生时进入休眠状态从而不占用CPU消耗，有事件发生才会去找对应的 Handler 处理事件，而While则会一直占用。在 Cocoa 程序的线程中都可以通过代码NSRunLoop *runloop = [NSRunLoop currentRunLoop]；来获取到当前线程的Runloop对象。
 RunLoop和线程是相辅相成的，一个Runloop对应着一条唯一的线程，可以这样说RunLoop是为了线程而生，没有线程，它也没有存在的必要。RunLoop是线程的基础架构部分， Cocoa 和 CoreFundation 都提供了RunLoop对象方便配置和管理线程的 RunLoop。每个线程，包括程序的主线程（ main thread ）都有与之相对应的 RunLoop对象。上图从 input source 和 timer source 接受事件，然后在线程中处理事件都是由RunLoop推动完成。

 注意：开一个子线程创建runloop,不是通过alloc init方法创建，而是直接通过调用currentRunLoop方法来创建，它本身是一个懒加载的。在子线程中，如果不主动获取Runloop的话，那么子线程内部是不会创建Runloop的。
 
 RunLoop 的模式有五种。图上列出了其中两种分别是 NSDefaultRunLoopMode(默认模式) 和 UITRackingRunLoopMode（UI模式） 、NSRunLoopCommonModes（占位模式）。其实占位模式不是一个真正的模式，它相当于上面两种模式之和。苹果公开提供的 Mode 有两个NSDefaultRunLoopMode（kCFRunLoopDefaultMode） NSRunLoopCommonModes（kCFRunLoopCommonModes）。
 
 NSDefaultRunLoopMode  (kCFRunLoopDefaultMode) : 默认模式，通常主线程是在这个模式下运行。
 UITRackingRunLoopMode ：界面UI跟踪模式，用于scrollview追踪触摸滑动，保证界面滑动时不收其他模式影响。
 NSRunLoopCommonModes（kCFRunLoopCommonModes）：占位模式，是组合模式，相当于向_commonModes注册了NSDefaultRunLoopMode和
                                                UITRackingRunLoopMode两种模式。
 NSConnectionReplayModel: cocoa用这种模式结合NSConnection对象检测回应，我们很少使用
 NSModalPanelRunLoopMode: cocoa用此模式来标识用于模态面板的事件
 NSEventTrackingRunLoopModel: cocoa用此模式在鼠标拖动Loop和其他用户界面跟踪loop期间限制传入事件
 */



@implementation YDDRunLoopUserViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    @weakify(self);
    self.navBarView.leftBlock = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
    
   
    
    [self addRunLoopObserver];
    
    [self addRunloopObser];
    self.tasks = [NSMutableArray array];
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0));
    }];
    
}

- (void)addRunLoopObserver
{
    //获取当前的RunLoop
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    //上下文 （此处为C语言 对OC的操作需要上下文）将(__bridge void *)self 传入到Callback
    CFRunLoopObserverContext context = {0, (__bridge void*)self, &CFRetain, &CFRelease};
    //创建观察者 监听BeforeWaiting 监听到就调用回调callBack
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0,  &callBack, &context);
    //添加观察者到当前runloop kCFRunLoopDefaultMode可以改为kCFRunLoopCommonModes
    CFRunLoopAddObserver(runLoop, observer, kCFRunLoopDefaultMode);
    //C语言中 有create就需要release
    CFRelease(observer);
}

/// runloop监听
- (void)addRunloopObser
{
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        CFRunLoopMode model = CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"kCFRunLoopEntry 进入loop model ：%@", model);
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"kCFRunLoopBeforeTimers  model ：%@", model);
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"kCFRunLoopBeforeSources  model ：%@", model);
                break;

            case kCFRunLoopBeforeWaiting:
                NSLog(@"kCFRunLoopBeforeWaiting  model ：%@", model);
                break;

            case kCFRunLoopAfterWaiting:
                NSLog(@"kCFRunLoopAfterWaiting  model ：%@", model);

                break;
                
            case kCFRunLoopExit:
                NSLog(@"kCFRunLoopExit  model ：%@", model);
                break;
            case kCFRunLoopAllActivities:
                NSLog(@"kCFRunLoopAllActivities  model ：%@", model);
                break;
            default:
                break;
        }
        CFRelease(model);
        
    });
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
}




- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        if (@available(iOS 13.0, *)) {
            _tableView.automaticallyAdjustsScrollIndicatorInsets = NO;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30000;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenWidth / 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSLog(@"---run---%@",[NSRunLoop currentRunLoop].currentMode);
    // 以下两个循环的UI操作在必须放在主线程，但是弊端就是太多图片的处理会阻塞tableview的滑动流畅性
    
    for (int i = 0; i < 2; i++) {
        UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:i];
        if ([imageView isKindOfClass:[UIImageView class]]) {
            imageView.image = nil;
            [imageView removeFromSuperview];
        }
    }
    
    CGFloat size = (ScreenWidth - 10 * 3) / 2;
    for (int i = 0; i < 2; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [cell.contentView addSubview:imageView];
        imageView.clipsToBounds = YES;
        imageView.frame = CGRectMake(10 + (size + 10) * i, 5, size, size);
        
        //阻塞原因：kCFRunLoopDefaultMode时候 多张图片一起加载（耗时）loop不结束无法BeforeWaiting(即将进入休眠) 切换至UITrackingRunLoopMode来处理等候的UI刷新事件造成阻塞
        //解决办法：每次RunLoop循环只加载一张图片 这样loop就会很快进入到BeforeWaiting处理后面的UI刷新（UITrackingRunLoopMode 优先处理）或者没有UI刷新事件继续处理下一张图片
        
        void(^task)(void) = ^{
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BigImage" ofType:@"jpg"]];
            imageView.image = image;
        };
        [self.tasks addObject:task];
        if (self.tasks.count > TaskMax) {
            [self.tasks removeFirstObject];
        }
        
    
    }
    
    return cell;
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
