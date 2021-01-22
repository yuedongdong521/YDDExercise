//
//  YDDTabNodeViewController.m
//  YDDExercise
//
//  Created by ydd on 2021/1/20.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDTabNodeViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>


@interface YDDMsgCellView : UITableViewCell

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIView *bgView;

@end

@implementation YDDMsgCellView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bgView = [[UIView alloc] init];
        [self.contentView addSubview:bgView];
        bgView.backgroundColor = [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:0.5];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 8;
        
        _bgView = bgView;
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.numberOfLines = 0;
    }
    return _label;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bgView.frame = CGRectInset(self.bounds, 5, 5);
    
    self.label.frame = CGRectInset(self.bounds, 10, 10);
}

@end


@interface YDDMsgCellNode : ASCellNode

@property (strong, nonatomic) ASButtonNode *textNode;

@end

@implementation YDDMsgCellNode

- (instancetype)initWithMsg:(NSDictionary *)msg
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        _textNode = [[ASButtonNode alloc] init];
        NSString* nickname = @"";
        NSString* text = @"";
        if ([msg[@"type"] isEqual: @"TEXT"]) {
            nickname = [NSString stringWithFormat:@"[%@]：", msg[@"nickname"]];
            text = msg[@"text"];
        } else {
            nickname = @"其他人";
            text = @"其他消息";
        }
        NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:@""];
        
        NSAttributedString* nameString = [[NSAttributedString alloc] initWithString:nickname attributes:@{
            NSFontAttributeName : [UIFont systemFontOfSize:14.0],
            NSForegroundColorAttributeName: UIColorHexRGBA(0xFF9900, 1)
        }];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5.0;
        NSAttributedString* textString = [[NSAttributedString alloc] initWithString: text attributes:@{
            NSFontAttributeName : [UIFont systemFontOfSize:14.0],
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSParagraphStyleAttributeName: paragraphStyle
        }];
        [string appendAttributedString:nameString];
        [string appendAttributedString:textString];
        _textNode.titleNode.attributedText = string;
        _textNode.titleNode.maximumNumberOfLines = 3;
        
        UIImage *image = [UIImage as_resizableRoundedImageWithCornerRadius:8 cornerColor:[UIColor clearColor] fillColor:[UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:0.5] traitCollection:ASPrimitiveTraitCollectionMakeDefault()];
        _textNode.backgroundImageNode.image = image;
        
        [self addSubnode:_textNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    [_textNode.titleNode setTextContainerInset:UIEdgeInsetsMake(9, 14.5, 9, 8.5)];
    ASAbsoluteLayoutSpec *absoluteSpec = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:@[_textNode]];
    // ASAbsoluteLayoutSpec's .sizing property recreates the behavior of ASDK Layout API 1.0's "ASStaticLayoutSpec"
    absoluteSpec.sizing = ASAbsoluteLayoutSpecSizingSizeToFit;
    
    return [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 10)
            child:absoluteSpec];
}


@end

@interface YDDTabNodeViewController ()<ASTableDelegate, ASTableDataSource, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ASTableNode *tableNode;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isNode;

@end

@implementation YDDTabNodeViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    @weakify(self);
    self.navBarView.leftBlock = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubnode:self.tableNode];
    
    self.tableNode.frame = CGRectMake(0, ScreenHeight - 300, 200, 200);
    
    
    // 填充测试数据
    [self.dataArr addObjectsFromArray:@[
                @{@"type": @"TEXT", @"text": @"你好", @"nickname": @"yemeishu"},
                @{@"type": @"TEXT", @"text": @"你好，这个主播不错哦~", @"nickname": @"yemeishu"},
                @{@"type": @"TEXT", @"text": @"现在直播还可以带货了", @"nickname": @"yemeishu"},
                @{@"type": @"TEXT", @"text": @"你好", @"nickname": @"yemeishu"},
                @{@"type": @"TEXT", @"text": @"你好，这个主播不错哦~", @"nickname": @"yemeishu"},
                @{@"type": @"TEXT", @"text": @"现在直播还可以带货了", @"nickname": @"yemeishu"},
                @{@"type": @"TEXT", @"text": @"你好", @"nickname": @"yemeishu"},
                @{@"type": @"TEXT", @"text": @"你好，这个主播不错哦~", @"nickname": @"yemeishu"},
                @{@"type": @"TEXT", @"text": @"现在直播还可以带货了", @"nickname": @"yemeishu"}
        ]];

    [self reloadAnimation:NO];
    
    ASButtonNode *button = [[ASButtonNode alloc] init];
    [self.view addSubnode:button];
    [button addTarget:self action:@selector(tapAction) forControlEvents:ASControlNodeEventTouchUpInside];
    [button setTitle:@"Node发送" withFont:kFontPF(16) withColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(ScreenWidth - 100, 100, 80, 50);
    
    
    [self.view addSubview:self.tableView];
    
    [self.tableView reloadData];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"sys发送" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(20, 100, 80, 50);
    
    
}

- (void)timerAction
{

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"TEXT" forKey:@"type"];
    [dic setValue:@"摘心008" forKey:@"nickname"];
    static NSArray *arr = nil;
    if (!arr) {
        arr = @[@"天下风云出我辈", @"一入江湖岁月催", @"黄图霸业谈笑中", @"不如人生一场醉"];
    }
    
    [dic setValue:arr[arc4random() % 4] forKey:@"text"];
    
    if (self.dataArr.count > 200) {
        [self.dataArr removeObjectsInRange:NSMakeRange(0, 100)];
    }
    [self.dataArr addObject:dic];
    
    [self reloadAnimation:YES];
    
}

- (void)startTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer fire];
}

- (void)tapAction
{
    self.isNode = YES;
    [self startTimer];
}

- (void)btnAction
{
    self.isNode = NO;
    [self startTimer];
}

- (void)reloadAnimation:(BOOL)animation
{
    if (self.isNode) {
        [self.tableNode reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.dataArr.count > 0) {
                
                [self.tableNode scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animation];
            }
        });
        
    } else {
        [self.tableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.dataArr.count > 0) {
                
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animation];
            }
        });
    }
    
    
}

- (ASTableNode *)tableNode
{
    if (!_tableNode) {
        _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
        _tableNode.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableNode.backgroundColor = [UIColor clearColor];
        _tableNode.view.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableNode.delegate = self;
        _tableNode.dataSource = self;
        _tableNode.view.allowsSelection = NO;
        _tableNode.backgroundColor = [UIColor redColor];
        _tableNode.contentInset = UIEdgeInsetsZero;
    }
    return _tableNode;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataArr[indexPath.row];
    return ^{
        YDDMsgCellNode *node = [[YDDMsgCellNode alloc] initWithMsg:dic];
        node.neverShowPlaceholders = YES;
        return node;
    };
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}


- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 510, 200, 200) style:UITableViewStylePlain];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.backgroundColor = [UIColor redColor];
        
        [_tableView registerClass:[YDDMsgCellView class] forCellReuseIdentifier:@"cellView"];
    }
    return _tableView;
}


- (NSAttributedString *)creatAttWithDic:(NSDictionary *)dic
{
    NSMutableAttributedString *mut = [[NSMutableAttributedString alloc] init];
    NSAttributedString *name = [[NSAttributedString alloc] initWithString:dic[@"nickname"] attributes:@{NSForegroundColorAttributeName : [UIColor yellowColor], NSFontAttributeName : kFontPF(16)}];
    [mut appendAttributedString:name];
    
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:dic[@"text"] attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : kFontPF(16)}];
    [mut appendAttributedString:text];
    
    return mut;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YDDMsgCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"cellView" forIndexPath:indexPath];
    
    NSDictionary *dic = self.dataArr[indexPath.row];
    
    cell.label.attributedText = [self creatAttWithDic:dic];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataArr[indexPath.row];
    
    NSAttributedString *att = [self creatAttWithDic:dic];
    
    CGFloat height = [att boundingRectWithSize:CGSizeMake(180, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
    
    return height + 22;
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
