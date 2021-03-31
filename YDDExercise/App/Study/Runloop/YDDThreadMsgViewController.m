//
//  YDDThreadMsgViewController.m
//  YDDExercise
//
//  Created by ydd on 2021/3/26.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDThreadMsgViewController.h"

#define kMsgId1 101

#define kMsgId2 102



@interface YDDPortModel : NSObject

@property (nonatomic, strong) NSString *str;

@end

@implementation YDDPortModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end

@interface YDDWorkClass : NSObject<NSPortDelegate>
{

    CFRunLoopRef _threadRunLoop;
}

@property (nonatomic, strong) NSPort *remotePort;

@property (nonatomic, strong) NSPort *myPort;

@property (nonatomic, strong) NSLock *workLock;

@property (nonatomic, strong) NSMutableArray *workMsgArray;

@property (nonatomic, strong) NSThread *runThread;


- (void)sendPortMessage;

@end

static YDDWorkClass *_workClass;

@implementation YDDWorkClass


+ (instancetype)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _workClass = [[YDDWorkClass alloc] init];
    });
    return _workClass;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _workMsgArray = [NSMutableArray array];
        _workLock = [[NSLock alloc] init];
        
    }
    return self;
}

/// 在目标线程中调用
- (void)configThreadPortDelegate:(id<NSMachPortDelegate>)delegate
{
    if (!_remotePort) {
        _remotePort = [NSMachPort port];
       
    }
    [_remotePort setDelegate:delegate];
    [[NSRunLoop currentRunLoop] addPort:_remotePort forMode:NSDefaultRunLoopMode];
    
    if (!_runThread) {
        _runThread = [[NSThread alloc] initWithTarget:self selector:@selector(launchThread) object:nil];
        
        [_runThread start];
    }
}

- (void)launchThread
{
    @autoreleasepool {
        
        
        [[NSThread currentThread] setName:@"MyWorkerClass"];
        
        NSLog(@"launchThreadWithPort thread is %@.", [NSThread currentThread]);
        
        self.myPort = [NSPort port];
        [self.myPort setDelegate:self];
        
        _threadRunLoop = CFRunLoopGetCurrent();
        
        [[NSRunLoop currentRunLoop] addPort:self.myPort forMode:NSDefaultRunLoopMode];
        
        [self sendPortMessage];
        
        [[NSRunLoop currentRunLoop] run];
        NSLog(@" work runloop 退出");
    }
}


- (void)sendPortMessage
{
    NSString *str = @"123";
   
    YDDPortModel *portModel = [[YDDPortModel alloc] init];
    portModel.str = @"ydd";
    
    NSData *portData = [portModel yy_modelToJSONData];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:@[[str dataUsingEncoding:NSUTF8StringEncoding], portData]];
    
    static int msgId = 100;
   
    
    [_workLock lock];
    msgId++;
    [self.workMsgArray addObject:@(msgId)];
    [_workLock unlock];
    
    BOOL suc = [_remotePort sendBeforeDate:[NSDate date] msgid:kMsgId1 components:array from:_myPort reserved:0];
    
    NSLog(@"子线程向主线程发送消息 suc ： %@", @(suc));
}

- (void)handlePortMessage:(NSPortMessage *)message
{
    NSLog(@"接受到父类的消息。。。%@。", message);
}


- (void)dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}


@end


@interface YDDThreadMsgViewController ()<NSMachPortDelegate>

@property (nonatomic, strong) NSThread *thread;




@end

@implementation YDDThreadMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  
    @weakify(self);
    self.navBarView.leftBlock = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(20);
        make.width.height.mas_equalTo(60);
    }];
    
    int x = 1;
    x += 1 * 2;
    NSLog(@"x = %d", x);
    [[YDDWorkClass share] configThreadPortDelegate:self];

    
    
}

- (void)sendBtnAction
{
    
    
    /// waitUntilDone 是否等待线程执行完毕，由于_thread是常驻线程，所以不会执行完毕，yes会让程序卡在这
    [[YDDWorkClass share] performSelector:@selector(sendPortMessage) onThread:[YDDWorkClass share].runThread withObject:nil waitUntilDone:NO];
   
}


- (void)handleMachMessage:(void *)msg
{
    
    [[YDDWorkClass share].workLock lock];
    
    if ([YDDWorkClass share].workMsgArray.count > 0) {
        NSInteger msgId = [[[YDDWorkClass share].workMsgArray firstObject] integerValue];
        
        [[YDDWorkClass share].workMsgArray removeFirstObject];
        NSLog(@"接受到子线程传递的消息 msgId : %ld", (long)msgId);
    }
    [[YDDWorkClass share].workLock unlock];
   
}

- (void)handlePortMessage:(NSMessagePort *)message
{
//    NSLog(@" curThread : %@ ", [NSThread currentThread]);
    NSLog(@"接受到子线程传递的消息。%@", message);
    
    NSUInteger msgId = [[message valueForKeyPath:@"msgid"] integerValue];
    NSMachPort *localPort = [message valueForKeyPath:@"localPort"];
    NSMachPort *remotePort = [message valueForKeyPath:@"remotePort"];
    NSMutableArray *componts = [message valueForKey:@"components"];
    for (NSData *data in componts) {
        NSLog(@"data is %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }
    
    if (msgId == kMsgId1) {
        YDDPortModel *portModel = [[YDDPortModel alloc] init];
        portModel.str = @"亮亮";
        NSData *portData = [portModel yy_modelToJSONData];
        
        NSData *data = [@"456" dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *array = [NSMutableArray arrayWithArray:@[data, portData]];
        [remotePort sendBeforeDate:[NSDate date] msgid:kMsgId2 components:array from:localPort reserved:0];
    }
}


- (void)dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
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
