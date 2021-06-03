//
//  YDDRACViewController.m
//  YDDExercise
//
//  Created by ydd on 2021/1/7.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDRACViewController.h"

#import "YDDInputView.h"
#import <RACReturnSignal.h>
#import "YDDRequestTool.h"

@interface TestView : UIView

@end

@implementation TestView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"testView tap");
}

@end

@interface YDDRACViewController ()<YDDInputViewDelegate>

@property (nonatomic, strong) UIButton *commiteBtn;

@property (nonatomic, strong) UITextField *inputView;
@property (nonatomic, strong) UITextField *passwordView;

@property (nonatomic, strong) YDDInputView *yddInputView;

@property (nonatomic, strong) TestView *testView;
/// 持有订阅者
@property (nonatomic, strong) RACSubject *racSubject;
///
@property (nonatomic, strong) RACSubject *testRACDisposableSub;

@property (nonatomic, strong) RACDisposable *racTimeDisposable;

@property (nonatomic, strong) RACCommand *rac_command;

@property (nonatomic, strong) YDDRequestTool *request ;

@end

@implementation YDDRACViewController

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    YDDRACViewController *vc = [super allocWithZone:zone];
    @weakify(vc);
    [[vc rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(vc);
        [vc addSubView];
    }];
    
    return vc;
}

- (void)addSubView
{
    NSLog(@"加载视图");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupUI];
    
    [self userRACSignal];
    
    [self testRACDisposable];
    
    [self testRACSubject];
    /// 先发信号后订阅
    [self test_RACReplaySubject];
    ///
    [self testRACTimer];
    /// 信号连接
    [self test_RACMulticastConnection];
    /// 先发信号后订阅
    [self testRACCommand];
    /// 多重订阅
    [self testSwitchToLatest];
    /// 信号绑定
    [self testRACSignalBind];
    /// 映射
    [self testRACFlattenMap];
    /// 过滤
    [self testRACFilterAndIgnore];
    
    [self testRAC_TextFiled];
    
    [self testRAC_BtnAction];
    
    [self testRAC_KVO];
    
    [self testYDDInputView];
    [self testRAC_Protocol];
    
    [self testRAC_Notify];
    
    [self testRACList];
    
    [self test_RACObser];
    
    [self test_RACCommandRequest];
    
}

- (void)setupUI
{
    @weakify(self);
    self.navBarView.leftBlock = ^{
        @strongify(self);
        [self.racTimeDisposable dispose];
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.passwordView];
    [self.view addSubview:self.commiteBtn];
    
    [self.view addSubview:self.testView];
    
    
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBarHeight + 60);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
    }];
    
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inputView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
    }];
    
    [self.commiteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordView.mas_bottom).mas_offset(20);
        make.left.right.height.equalTo(self.inputView);
    }];
    
    [self.testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.commiteBtn.mas_bottom).mas_offset(20);
        make.width.height.mas_equalTo(30);
        make.left.mas_equalTo(20);
    }];
    self.testView.layer.masksToBounds = YES;
    self.testView.layer.cornerRadius = 15;
    
    UIButton *requestBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [requestBtn setTitle:@"request" forState:UIControlStateNormal];
    [self.view addSubview:requestBtn];
    
   
    [[requestBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self testRAC_Request];
    }];
    
    [requestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.testView);
        make.left.mas_equalTo(self.testView.mas_right).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    
    UIButton *bufferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bufferBtn setTitle:@"间隔点击" forState:UIControlStateNormal];
    [bufferBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:bufferBtn];
    /// 1秒只响应一次
    [[[bufferBtn rac_signalForControlEvents:UIControlEventTouchUpInside] bufferWithTime:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"111111111111111");
    }];
    [bufferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.testView);
        make.left.mas_equalTo(requestBtn.mas_right).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    [self rac_commandTest];
    
    
}

#pragma mark - 信号类 RACSignal
- (void)userRACSignal
{
    /// RACSignal 信号类，使用方法：1:创建信号， 2:订阅信号，3:发送信号，本身具备发送信号能力
    NSLog(@"RACSignal 1.创建信号类RACSignal");
    @weakify(self);
    RACSignal *racSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        NSLog(@"RACSignal 3.添加订阅时block被执行，持有订阅");
        self.racSubject = subscriber;
        return nil;
    }];
    
    NSLog(@"RACSignal 2.信号类RACSignal添加订阅");
    [racSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACSignal 订阅信号被执行 %@", x);
    }];
    
    [racSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACSignal 订阅2信号被执行 %@", x);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"RACSignal 4.发送信号");
        [self.racSubject sendNext:@"😊"];
    });
    /**
     RACSignal 不能重复添加订阅，后添加的订阅会覆盖之前添加的订阅。否则需要自己管理订阅者持有者数组
     */
}

#pragma mark -- 取消订阅监听类 RACDisposable
- (void)testRACDisposable
{
    NSLog(@"RACDisposable 1.创建信号类RACSignal");
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        NSLog(@"RACDisposable 3.添加订阅时block被执行, 持有订阅者, 返回RACDisposable");
        self.testRACDisposableSub = subscriber;
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"RACDisposable 信号订阅释放");
        }];
        
    }];
    NSLog(@"RACDisposable 2.信号类RACSignal添加订阅");
    RACDisposable *racDisposable = [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACDisposable 订阅信号被执行 %@", x);
    }];
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"RACDisposable 发送信号");
        [self.testRACDisposableSub sendNext:@""];
        
        NSLog(@"RACDisposable : 取消订阅，取消后发送信号无效 ");
        [racDisposable dispose];
        
        [self.testRACDisposableSub sendNext:@"已取消订阅"];
        
        [signal subscribeNext:^(id  _Nullable x) {
            NSLog(@"RACDisposable ：重新添加订阅被执行");
        }];
        
        [self.testRACDisposableSub sendNext:@"重新发送信号"];
        
    });
    /**
     理解：
        1. 创建信号时保存一个返回值为RACDisposable、参数为订阅者RACSubscriber 的 block ；
        2. 在添加订阅的时候调用保存的Block，将订阅者RACSubscriber通过block传递给信号对象，
          同时返回RACDisposable对象，通过RACDisposable对象控制订阅者的生命周期，如果通过dispose方法取消订阅，则无法再向本次订阅者发送信号。如果订阅者RACSubscriber没有被持有，则发送信号后立即释放。
     */
}


- (void)testRACSubject
{
    /// 1.创建信号
    RACSubject *racSubject = [RACSubject subject];
    /// 2.订阅信号
    RACDisposable *disposabel1 = [racSubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACSubject : 订阅1被执行 %@", x);
    }];
    
    [racSubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACSubject : 订阅2被执行 %@", x);
    }];
    
    /// 3. 发送信号
    [racSubject sendNext:@"🤦‍♂️"];
    
    [disposabel1 dispose];
    
    [racSubject sendNext:@"😁"];
    
    /**
     RACSubject支持添加多个订阅，内部维护了一个订阅者列表，必须先订阅后发送信号
     */
}

- (void)test_RACReplaySubject
{
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    /// 发送信号时发现没订阅，将数据保存在数组
    [replaySubject sendNext:@"先发送后订阅"];
    /// 添加订阅时如果信号数组有值则发送信号，发送成功后从信号数组删除发送内容
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACReplaySubject : 订阅被执行 - %@", x);
    }];
    
    [replaySubject sendNext:@"订阅后发信号"];
}


- (void)testRACTimer
{
    UIButton *timerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [timerBtn setTitle:@"定时器" forState:UIControlStateNormal];
    [self.view addSubview:timerBtn];
    
    [timerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.top.mas_equalTo(self.testView.mas_bottom).mas_offset(20);
    }];
    
    static int time = 0;
    @weakify(self);
    [[timerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        UIButton *btn = (UIButton *)x;
    
        self.racTimeDisposable = [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
            time++;
            [btn setTitle:[NSString stringWithFormat:@"倒计时:%d", time] forState:UIControlStateNormal];
            if (time >= 20) {
                [self.racTimeDisposable dispose];
                time = 0;
                [btn setTitle:[NSString stringWithFormat:@"定时器"] forState:UIControlStateNormal];
            }
        }];
        
    }];
    /// 封装了gcd timer
}

- (void)test_RACMulticastConnection
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"RACMulticastConnection ： 发送信号");
        
        [subscriber sendNext:@"🍌"];
        
        return nil;
    }];
    
    /// 连接类
    RACMulticastConnection *connection = [signal publish];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACMulticastConnection : 订阅 1 %@", x);
    }];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACMulticastConnection : 订阅 2 %@", x);
    }];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACMulticastConnection : 订阅 3 %@", x);
    }];
    /// 开始连接
    [connection connect];
    
    /**
     RACMulticastConnection 信号连接类可以使信号在订阅时不立即调用创建信号的block，当调用connect方法时再调用block，且添加多个订阅只会调用一次创建信号block，将冷信号转化成热信号。
     
     冷信号：RACDynamicSignal
           只能主动订阅才会收到信号，每次订阅的时候会发送信号，订阅和发送信号是一对一的关系，
            
     热信号：RACSubject
           本身实现RACSubscriber协议，可以自己发送信号，订阅和发送信号是一对多的关系，可以多次订阅
     
     */
}

- (void)testRACCommand
{
    __block RACSubject *subscriber1 = nil;
    
//    NSLog(@"RACCommand 创建command");
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
       
        NSLog(@"RACCommand : init block %@", input);
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSLog(@"RACCommand : create signal block");
            
           
            
            [subscriber sendNext:[NSString stringWithFormat:@" : input  %@", input]];
            
            return nil;
        }];
        
    }];
//    NSLog(@"RACCommand executionSignals 订阅信号");
    [command.executionSignals subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACCommand executionSignals 接受信号 ： %@", x);
        
//        subscriber1 = x;
//
//        NSLog(@"RACCommand executionSignals 订阅信号");
//        [x subscribeNext:^(id  _Nullable x) {
//            NSLog(@"RACCommand executionSignals 订阅者 接受信号 ： %@", x);
//        }];
        
    }];
    
//    NSLog(@"RACCommand 发送信号");
    
    RACSignal *signal = [command execute:@"🍑"];
//    NSLog(@"RACCommand 订阅信号");
    
   
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACCommand 接受信号 ： %@", x);
    }];
    
   
    
    
    /// 错误示范
//    [command.executionSignals subscribeNext:^(id  _Nullable x) {
//        NSLog(@"RACCommand executionSignals 在execute后订阅");
//        [x subscribeNext:^(id  _Nullable x) {
//            NSLog(@"RACCommand executionSignals 在execute后订阅 %@", x);
//        }];
//    }];
    
    
    /**
     execute: 方法会调用 RACCommand初始化时创建的signalBlock,
           通过signalBlock返回RACSignal信号对象，使用RACMulticastConnection 链接信号对象，实现先发信号后订阅的功能。
            如果使用 executionSignals订阅，必需先订阅后使用execute：发信号。
     */
}

- (void)testSwitchToLatest
{
    RACSubject *subject1 = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];
    
    [subject1 subscribeNext:^(id  _Nullable x) {
        NSLog(@"SwitchToLatest subject1 ： 收到信号 %@", x);
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"SwitchToLatest subject2 ： 收到信号 %@", x);
        }];
    }];
    
    [subject1.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"SwitchToLatest switchToLatest ： 收到信号 %@", x);
    }];
    
    [subject1 sendNext:subject2];
    
    
    RACSubject *subject3 = [RACSubject subject];
    
    [subject1 sendNext:subject3];
    
    
    [subject3 sendNext:@"🍉"];
    [subject2 sendNext:@"🍊"];
    /// switchToLatest表示最新的订阅者，使用execute: 发送信号指挥收到最新的订阅信号，例如： log始终输出🍉
    
    /// 使用switchToLatest优化RACCommand
    
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
       
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:input];
            /// 结束本次发送，调用后 executing 订阅才会执行结束
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"SwitchToLatest command： 接收到信号 %@", x);
    }];
    /// skip：可以忽略信号结束， 1表示忽略第一次接受，否则在初始化时就会收到一条执行结束信号
    [[command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            NSLog(@"SwitchToLatest command 正在执行");
        } else {
            NSLog(@"SwitchToLatest command 执行结束");
        }
    }];
    NSLog(@"SwitchToLatest command 发送信号");
    [command execute:@"🐟"];

    /**
     与skip类似测控制方法还有：
     filter过滤某些
     ignore 忽略某些值
     startWith 从哪里开始
     skip 跳过（忽略）次数
     take取几次值 正序
     takeLast取几次值 倒序
     */
}

#pragma mark RAC bind 信号绑定
- (void)testRACSignalBind
{
    RACSubject *subject = [RACSubject subject];
    
    RACSignal *singal = [subject bind:^RACSignalBindBlock _Nonnull {
        return ^RACSignal *(id value, BOOL *stop) {
            
            return [RACReturnSignal return:value];
        };
    }];
    
    [singal subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACSignalBind : %@", x);
    }];
    
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACSignalBind 111 : %@", x);
    }];
    
    [subject sendNext:@"信号绑定"];
}

- (void)testRACFlattenMap
{
    RACSubject *mapSubject = [RACSubject subject];
    [[mapSubject map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"map 初始化block ： %@", value];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"RAC FlattenMap : %@", x);
    }];
    [mapSubject sendNext:@"🤮"];
    
    RACSubject *subject = [RACSubject subject];
    RACSignal *signal = [subject flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        NSString *str = [NSString stringWithFormat:@"初始化block : %@", value];
        return [RACReturnSignal return:str];
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"RAC FlattenMap : %@", x);
    }];
    [subject sendNext:@"😄"];
    
    /// flattenMap block返回值是一个RACSignal， 所有flattenMap更适合处理多重订阅，即发送的信号为一个信号对象，类似switchToLatest
    
    RACSubject *subject1 = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];
    
    [[subject1 flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return value;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"RAC FlattenMap 映射信号对象: %@", x);
    }];
    
    [subject1 sendNext:subject2];
    [subject2 sendNext:@"☺️"];
    
}

- (void)testRACFilterAndIgnore
{
    NSMutableArray *mutArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 10; i++) {
        [mutArray addObject:@(i)];
    }
    
    /// filter
    RACSubject *filterSubject = [RACSubject subject];
    [[filterSubject filter:^BOOL(id  _Nullable value) {
        /// 过滤小于等于无的数据
        return [value integerValue] > 5;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACFilterAndIgnore  filter : value %@", x);
    }] ;
    
    [mutArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [filterSubject sendNext:obj];
    }];
    
    /// Ignore
    /// 忽略 1信号
    RACSubject *ignoreSubject = [RACSubject subject];
    [[ignoreSubject ignore:@(1)] subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACFilterAndIgnore Ignore : value %@", x);
    }];
    [mutArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [ignoreSubject sendNext:obj];
    }];
    
    RACSubject *ignoreValuesSubject = [RACSubject subject];
    /// 忽略所有信号
    [[ignoreValuesSubject ignoreValues] subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACFilterAndIgnore ignoreValues : value %@", x);
    }];
    
    [mutArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [ignoreValuesSubject sendNext:obj];
    }];
    /// 降序排序
    [mutArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 integerValue] < [obj2 integerValue];
    }];
    
    RACSubject *takeSubject = [RACSubject subject];
    /// take：只响应前几个信号，这里只响应前两个信号
    [[takeSubject take:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACFilterAndIgnore take : value %@", x);
    }];
    [mutArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [takeSubject sendNext:obj];
    }];
    
    /// takeLast 只响应后几个信号， 这里只响应后面两个信号，
    RACSubject *takeLastSubject = [RACSubject subject];
    [[takeLastSubject takeLast:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACFilterAndIgnore takeLast : value %@", x);
    }];
    [mutArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [takeLastSubject sendNext:obj];
    }];
    /// 使用takeLast必须最后执行sendCompleted发送完成，要不然takeLast始终处在等待状态，不会执行订阅
    [takeLastSubject sendCompleted];
    
    ///  takeUntil 收到标记的信号被执行后终止订阅，这里当 untilSubject订阅接收到信号后，takeUntilSubject终止订阅，不会再接受信号
    RACSubject *takeUntilSubject = [RACSubject subject];
    RACSubject *untilSubject = [RACSubject subject];
    [[takeUntilSubject takeUntil:untilSubject] subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACFilterAndIgnore takeUntil : value %@", x);
    }];
    [untilSubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACFilterAndIgnore takeUntil : 收到标记信号 %@", x);
    }];
    
    [mutArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [takeUntilSubject sendNext:obj];
        if ([obj integerValue] == 5) {
            [untilSubject sendNext:obj];
        }
    }];
    
    RACSubject *diffSubject = [RACSubject subject];
    /// distinctUntilChanged 过滤相同的信号, 包括字符串，数组，字典，但是不能过滤model，表情也不行
    [[diffSubject distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACFilterAndIgnore distinctUntilChanged : 收到标记信号 %@", x);
    }];
    [diffSubject sendNext:@"Q"];
    [diffSubject sendNext:@"Q"];
    
    NSArray *arr = @[@(1), @(2)];
    NSArray *arr1 = @[@(1), @(2)];
    
    [diffSubject sendNext:arr];
    [diffSubject sendNext:arr1];
    
    NSDictionary *dic = @{@"name" : @"RAC"};
    NSDictionary *dic1 = @{@"name" : @"RAC"};
    
    [diffSubject sendNext:dic];
    [diffSubject sendNext:dic1];
    
    [diffSubject sendNext:@"😄"];
    [diffSubject sendNext:@"😄"];
    
    
}


#pragma mark rac监听textFiled
- (void)testRAC_TextFiled
{
    @weakify(self);
    [[self.inputView.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        @strongify(self);
        BOOL responds = value.length > 3;
        self.commiteBtn.enabled = responds;
        return responds;
    }]
     subscribeNext:^(id  _Nullable x) {
        NSLog(@"inputView : %@", x);
    }];
}
/// 代替button点击事件
- (void)testRAC_BtnAction
{
    RACSignal *commiteSignal = [self.commiteBtn rac_signalForControlEvents:UIControlEventTouchUpInside];
    @weakify(self);
    [commiteSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSLog(@"commiteBtn : %@", x);
        self.inputView.text = @"*";
    }];
}

- (void)testRAC_KVO
{
    /// kvo监听inputView的text属性 （textField的text值在初始化、输入完成、直接赋值时才会发生改变）
    @weakify(self);
    [RACObserve(self.inputView, text) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.inputView.isFirstResponder) {
            [self.inputView resignFirstResponder];
        }
    }];
}


- (void)testYDDInputView
{
    self.yddInputView = [[YDDInputView alloc] initWithHeight:50];
    
    self.yddInputView.layer.borderColor = [UIColor grayColor].CGColor;
    self.yddInputView.layer.borderWidth = 1;
    [self.view addSubview:self.yddInputView];
    [self.yddInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-100);
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(50);
        make.height.equalTo(@(50));
    }];
    
    self.yddInputView.maxLine = 5;
    self.yddInputView.maxNum = 100;
    self.yddInputView.edgeInset = UIEdgeInsetsMake(12, 0, 12, 0);
    self.yddInputView.placeholderLabel.text = @"请输入内容";
    self.yddInputView.delegate = self;
    
    [self.yddInputView updateLayout];
}

- (void)updateInputViewHeight:(CGFloat)height
{
    [self.yddInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-100);
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(height);
    }];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}
/// 代替代理，直接监听TestView点击事件，参数在allObjects里面
- (void)testRAC_Protocol
{
    [[self.testView rac_signalForSelector:@selector(tapAction:)] subscribeNext:^(RACTuple * _Nullable x) {
    
        [[x allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"pram : %@", obj);
        }];
        
        NSLog(@"testRAC_Protocol");
    }];
}
/// 代替通知
- (void)testRAC_Notify
{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"notify info: %@", x.userInfo);
    }];
}


- (void)testRAC_Request
{
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(2);
            [subscriber sendNext:@"请求1"];
        });
        
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(1);
            [subscriber sendNext:@"请求2"];
        });
        return nil;
    }];
    
    [self rac_liftSelector:@selector(respondsReq1:req2:) withSignalsFromArray:@[request1, request2]];
    /// rac_liftSelector功能类似gcd group， 所有任务执行完成后在执行selector方法，注意selector方法参数和signal任务数匹配
    
}

- (void)respondsReq1:(id)req1 req2:(id)req2
{
    NSLog(@"req1 : %@, req2 : %@", req1, req2);
}

- (void)testRACList
{
    NSArray *arr = @[@"a", @"b", @"c", @"1", @"3", @"2"];
    
    /// RAC遍历数组拆分写法
    RACSequence *seq = arr.rac_sequence;
    RACSignal *signal = seq.signal;
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACSequence 拆分遍历 arr value : %@", x);
    }];
    
    /// RAC遍历数组链式写法
    [arr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACSequence 链式遍历 arr value : %@", x);
    }];
    
    NSDictionary *dic = @{@"name" : @"ReactiveObjC", @"class" : @"RACSequence"};
    [dic.rac_sequence.signal subscribeNext:^(RACTwoTuple *  _Nullable x) {
        NSLog(@"RACSequence dic : %@, %@", x.first, x.second);
    }];
    
    ///  使用map 遍历数组
    RACSignal *signale = [arr.rac_sequence.signal map:^id _Nullable(NSString *  _Nullable value) {
        return [value isEqualToString:@"a"] ? @"a" : @"b";
    }];
    
    [signale subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACSequence map : %@", x);
        
    
    }];
    
    
    
    
}
/// 通过监听内容改变按钮状态
- (void)test_RACObser
{
    @weakify(self);
    RAC(self.commiteBtn, enabled) = [RACSignal combineLatest:@[self.inputView.rac_textSignal, self.passwordView.rac_textSignal] reduce:^id _Nonnull{
        @strongify(self);
        return @(self.inputView.text.length > 0 && self.passwordView.text.length > 0);
    }];
}

- (UITextField *)inputView
{
    if (!_inputView) {
        _inputView = [[UITextField alloc] init];
        _inputView.keyboardType = UIKeyboardTypeDefault;
        _inputView.placeholder = @"请输入内容";
        _inputView.textColor = [UIColor blackColor];
        _inputView.backgroundColor = [UIColor whiteColor];
    }
    return _inputView;
}

- (UITextField *)passwordView
{
    if (!_passwordView) {
        _passwordView = [[UITextField alloc] init];
        _passwordView.keyboardType = UIKeyboardTypeDefault;
        _passwordView.secureTextEntry = YES;
        _passwordView.placeholder = @"请输入密码";
        _passwordView.textColor = [UIColor blackColor];
        _passwordView.backgroundColor = [UIColor whiteColor];
    }
    return _passwordView;
}

- (UIButton *)commiteBtn
{
    if (!_commiteBtn) {
        _commiteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _commiteBtn.backgroundColor = [UIColor blueColor];
        [_commiteBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_commiteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commiteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    }
    return _commiteBtn;
}

- (TestView *)testView
{
    if (!_testView) {
        _testView = [[TestView alloc] initWithFrame:CGRectZero];
        _testView.backgroundColor = [UIColor redColor];
    }
    return _testView;
}

- (RACCommand *)rac_command
{
    if (!_rac_command) {
        _rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [NSThread sleepForTimeInterval:0.5];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [subscriber sendNext:input];
//                        [subscriber sendCompleted];
                        [subscriber sendError:[[NSError alloc] initWithDomain:@"sendError" code:1 userInfo:nil]];
                    });
                });
                
                return [RACDisposable disposableWithBlock:^{
                    NSLog(@"rac_command disposable");
                }];
            }] ;
        }];
    }
    return _rac_command;
}

- (void)rac_commandTest
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"RACCommand" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-300);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    @weakify(self);
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.rac_command execute:@(10)];
    }];
    
    
    [[self.rac_command.executionSignals flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return value;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"rac_command executionSignals : %@", x);
    }];
    
//    [self.rac_command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
//        NSLog(@"rac_command executionSignals : %@", x);
//
//    }];
    
    [self.rac_command.executing subscribeNext:^(NSNumber * _Nullable x) {
        NSLog(@"rac_command executing : %@", x);
    }];
    
    [self.rac_command.errors subscribeNext:^(NSError * _Nullable x) {
        NSLog(@"rac_command errors : %@", x);
    }];
    
    [self.rac_command.enabled subscribeNext:^(NSNumber * _Nullable x) {
        NSLog(@"rac_command enabled : %@", x);
    }];
    
}

- (void)test_RACCommandRequest
{
    YDDRequestTool *request = [[YDDRequestTool alloc] init];
    request.requestUrl = @"http://baidu.com";
    request.success = ^(id  _Nonnull data) {
        NSLog(@"request data : %@", data);
    };
    request.failuer = ^(NSError * _Nonnull error) {
        NSLog(@"request errpr : %@", error);
    };
    [request start];
    self.request = request;
    
    
}


- (void)dealloc
{
    
    NSLog(@"YDDRACViewController dealloc");
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
