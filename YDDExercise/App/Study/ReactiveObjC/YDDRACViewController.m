//
//  YDDRACViewController.m
//  YDDExercise
//
//  Created by ydd on 2021/1/7.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDRACViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "YDDInputView.h"

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

@end

@implementation YDDRACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupUI];
    
    [self testRAC_TextFiled];
    
    [self testRAC_BtnAction];
    
    [self testRAC_KVO];
    
    [self testYDDInputView];
    [self testRAC_Protocol];
    
    [self testRAC_Notify];
    
    [self testRACList];
    
    [self test_RACObser];
}

- (void)setupUI
{
    @weakify(self);
    self.navBarView.leftBlock = ^{
        @strongify(self);
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
    
}

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
    
}

- (void)respondsReq1:(id)req1 req2:(id)req2
{
    NSLog(@"req1 : %@, req2 : %@", req1, req2);
}

- (void)testRACList
{
    NSArray *arr = @[@"a", @"b", @"c", @"1", @"3", @"2"];
    
    [arr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"arr value: %@", x);
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
