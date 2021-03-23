//
//  YDDLookViewController.m
//  YDDExercise
//
//  Created by ydd on 2021/3/22.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDLookViewController.h"

@interface YDDLookViewController ()

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, strong) NSLock *lock;

@property (nonatomic, strong) NSCondition *condition;

@property (nonatomic, strong) NSConditionLock *conditionLock;

@property (nonatomic, strong) NSMutableArray <NSNumber *>*conditionArray;
@property (nonatomic, assign) NSInteger conditionIndex;

@property (nonatomic, strong) NSRecursiveLock *recursiveLock;


@end

@implementation YDDLookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    @weakify(self);
    self.navBarView.leftBlock = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
    
  
    _array = [NSMutableArray array];
    
    _lock = [[NSLock alloc] init];
    _condition = [[NSCondition alloc] init];
    
    _conditionLock = [[NSConditionLock alloc] initWithCondition:123];
    _conditionArray = [NSMutableArray array];
    
    NSArray *arr = @[@"@synchronized 同步锁（递归锁）", @"NSLock", @"NSCondition", @"NSConditionLock", @"NSRecursiveLock"];
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
            [self threadSelector:@selector(synchronThread)];
            break;
        case 101:
            [self threadSelector:@selector(lockThread)];
            break;
        case 102:
            [self threadSelector:@selector(conditionThread)];
//            [self conditionThread];
            
            break;
        case 103:
//            [self threadSelector:@selector(conditionLockThread)];
            [self conditionLockTest];
            break;
        case 104:
            
            [self recursiveTask];
            break;
        default:
            break;
    }
}

- (void)threadSelector:(SEL)selector
{
 
    [self.array removeAllObjects];
    NSInteger count = 0;
    
    while (count < 10) {
        count++;
        [NSThread detachNewThreadSelector:selector toTarget:self withObject:nil];
    }
    sleep(5);
    NSLog(@"synchornized array : %@", self.array);
    
}
/**
 @synchronized 同步锁，属于递归锁，相当于 NSRecursiveLock, 多次添加不会造成线程死锁,但是效率比较低
 */
- (void)synchronThread
{
    int time = arc4random() % 2;
    sleep(time);
    NSLog(@"枷锁前 synchron");
    @synchronized (self) {
        _num += 1;
        [self.array addObject:@(self.num)];
        
        NSLog(@"枷锁中 synchron");
    }
    NSLog(@"枷锁后 synchron");
}



/**
  NSLock 互斥锁， 反复添加会导致崩溃（平凡点击会崩溃）
 */
- (void)lockThread
{
    int time = arc4random() % 2;
    sleep(time);
    //    NSLog(@"枷锁前 synchron");
    [_lock lock];
    
    _num += 1;
    [self.array addObject:@(self.num)];
    //    NSLog(@"枷锁中 synchron");
    //
    [_lock unlock];
    //    NSLog(@"枷锁后 synchron");
}

/**
     类似信号量，
 [self.condition wait] 让当前线程进入等待状态
 [self.condition signal] 发送信号让等待线程开始运行
 waitUntilDate 设置等待时间片长度
 */
- (void)conditionThread
{
    int time = arc4random() % 2;
    sleep(time);
    
    /// 让当前线程进入等待状态，如果在指定的时间内没有调用signal方法，则自动停止等待
//    [_condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:time]];
    _num += 1;
   
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.condition lock];
        
        while (!(self.array.count > 0)) {
            NSLog(@"condition wait");
            [self.condition wait];
        }
        
        NSLog(@"condition remove ");
        [self.array removeObjectAtIndex:0];
        
        [self.condition unlock];
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self.condition lock];
        
        [self.array addObject:@(self.num)];
        NSLog(@"condition add");
        [self.condition signal];
        
        [self.condition unlock];
    });
    
    
}

/**
 NSConditionLock : 条件锁
 只有当加锁解锁传入的参数一致是才会生效
 */
- (void)conditionLockThread
{
    int time = arc4random() % 2;
    [NSThread sleepForTimeInterval:time];
    //    NSLog(@"枷锁前 synchron");
    [_conditionLock lockWhenCondition:123];
    
    _num += 1;
    [self.array addObject:@(self.num)];
    //    NSLog(@"枷锁中 synchron");
    //
    [_conditionLock unlockWithCondition:123];
    //    NSLog(@"枷锁后 synchron");
}


- (void)conditionLockTest
{
    [self.conditionArray removeAllObjects];
    self.conditionIndex = 0;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        NSLog(@"condition任务开始 ： 0");
        [self conditionLockThreadTask:0 callBack:^(NSInteger index) {
            NSLog(@"condition任务完成返回 ： %ld", (long)index);
        }];
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"condition任务开始 ： 1");
        [self conditionLockThreadTask:1 callBack:^(NSInteger index) {
            NSLog(@"condition任务完成返回 ： %ld", (long)index);
        }];
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"condition任务开始 ： 2");
        [self conditionLockThreadTask:2 callBack:^(NSInteger index) {
            NSLog(@"condition任务完成返回 ： %ld", (long)index);
        }];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"任务开始顺序 ： %@", self.conditionArray);
        /// 解锁第一个任务
        [self.conditionLock unlockWithCondition:[self.conditionArray[0] integerValue]];
    });
    
}

/// 通过添加条件锁控制任务回调顺序,加锁后代码进入等待状态，等到同样条件解锁后开始执行
- (void)conditionLockThreadTask:(NSInteger)condition callBack:(void(^)(NSInteger index))callBack
{
    [_lock lock];
    /// 按照任务顺序保存条件
    [self.conditionArray addObject:@(condition)];
    [_lock unlock];
    
    int time = arc4random() % 2;
    [NSThread sleepForTimeInterval:time];
    
    NSLog(@"condition任务完成 ： %ld", (long)condition);
    
    [_conditionLock lockWhenCondition:condition];
    
    if (callBack) {
        callBack(condition);
    }
    self.conditionIndex++;
    NSLog(@"conditionIndex : %ld", (long)self.conditionIndex);
    if (self.conditionIndex < self.conditionArray.count) {
        /// 按照加锁条件顺序解锁
        [_conditionLock unlockWithCondition:[self.conditionArray[self.conditionIndex] integerValue]];
    }
}
/**
 NSRecursiveLock 允许在同一线程中多次调用加锁，不会造成死锁, 递归锁会跟踪它被lock的次数。每次成功的lock都必须平衡调用unlock操作。只有所有达到这种平衡，锁最后才能被释放，以供其它线程使用。
 多用于循环和递归调用中添加线程锁。 在下面的递归调用中如果使用NSLock会导致死锁
 */
- (void)recursiveTask
{
    
    NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        static void(^recursiveBlock)(NSInteger count);
        
        recursiveBlock = ^(NSInteger count) {
            [lock lock];
            NSLog(@"recursive count : %ld", (long)count);
            unsigned int time = arc4random() % 2 + 1;
            sleep(time);
            if (count > 0) {
                recursiveBlock(count - 1);
            }
            [lock unlock];
        };
        
        recursiveBlock(10);
    });
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
