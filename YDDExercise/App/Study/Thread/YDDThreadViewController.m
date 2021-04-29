//
//  YDDThreadViewController.m
//  YDDExercise
//
//  Created by ydd on 2021/4/14.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDThreadViewController.h"

@interface YDDThreadViewController ()

@end

@implementation YDDThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    @weakify(self);
    self.navBarView.leftBlock = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };

    [self gcdSerialQueue];
    
    [self gcdConcurrentQueue];
}

- (void)gcdSerialQueue
{
    dispatch_queue_t queue = dispatch_queue_create("test_serial_queue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"serial queue : 0");
    dispatch_async(queue, ^{
        NSLog(@"serial queue : 1");
        [NSThread sleepForTimeInterval:1];
        NSLog(@"serial queue : 2");
    });
    NSLog(@"serial queue : 3");
    dispatch_async(queue, ^{
        NSLog(@"serial queue : 4");
    });
    NSLog(@"serial queue : 5");
    dispatch_sync(queue, ^{
        NSLog(@"serial queue : 6");
    });
    
    NSLog(@"serial queue : 7");
    
    /// gcd队列遵循先进先出的原则，串行队列，先加入的执行，后加入的后执行，
    /// 异步队列不需要等待队列任务完成后执行后续代码，同步队列需要等待队列任务完成之后才能执行后续代码。
    /// 串行队列按照加入顺序执行任务，同步并不会比异步先执行
    
}

- (void)gcdConcurrentQueue
{
    dispatch_queue_t queue = dispatch_queue_create("test_concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"concurrent queue : 0");
    dispatch_async(queue, ^{
        NSLog(@"concurrent queue : 1");
        [NSThread sleepForTimeInterval:1];
        NSLog(@"concurrent queue : 2");
    });
    
    NSLog(@"concurrent queue : 3");
    
    for (int i = 0; i < 3; i++) {
        dispatch_async(queue, ^{
            NSLog(@"concurrent queue for : %d", i + 3);
        });
    }

    NSLog(@"concurrent queue : 5");
    dispatch_sync(queue, ^{
        NSLog(@"concurrent queue : 6");
    });
    
    
    NSLog(@"concurrent queue : 7");
    
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
