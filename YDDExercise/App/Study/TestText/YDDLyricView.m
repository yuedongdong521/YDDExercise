//
//  YDDLyricView.m
//  YDDExercise
//
//  Created by ydd on 2021/1/22.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDLyricView.h"
#import "YDDGradientLabel.h"

@interface YDDLyricCell : UITableViewCell

@property (nonatomic, strong) YDDGradientLabel *gradientLabel;

@property (nonatomic, strong) YDDLyricModel *lyricModel;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign, readonly) CGFloat speed;

@end

@implementation YDDLyricCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.gradientLabel];
        self.gradientLabel.textColors = @[[UIColor greenColor], [UIColor greenColor], [UIColor grayColor], [UIColor grayColor]];
        self.progress = 0;
        [self.gradientLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)setLyricModel:(YDDLyricModel *)lyricModel
{
    _lyricModel = lyricModel;
    
    self.gradientLabel.text = lyricModel.lyricText;
    
    CGSize size = [self.gradientLabel textSizeWithMaxSize:CGSizeMake(self.bounds.size.width - 20, self.bounds.size.height)];
    [self.gradientLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width);
    }];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress < 0 ? 0 : progress > 1 ? 1 : progress;
    
//    if (_progress == 0) {
//        CATransaction cm
//
//
//    } else {
        
        self.gradientLabel.locations = @[@(0), @(_progress), @(_progress), @(1)];
//    }
    
}

- (CGFloat)speed
{
    if (self.lyricModel.duration > 0) {
        return 0.1 / self.lyricModel.duration;
    }
    return 0;
}

- (YDDGradientLabel *)gradientLabel
{
    if (!_gradientLabel) {
        _gradientLabel = [[YDDGradientLabel alloc] init];
    }
    return _gradientLabel;
}

@end



@interface YDDLyricView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger line;

@property (nonatomic, assign) NSInteger curRow;

@property (nonatomic, weak) YDDLyricCell *curCell;

@end

@implementation YDDLyricView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame line:(CGFloat)line
{
    self = [super initWithFrame:frame];
    if (self) {
        self.line = line;
        
        [self addSubview:self.tableView];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        [self.tableView reloadData];
        
    }
    return self;
}

- (void)start
{
    self.curRow = 0;
}

- (void)setCurRow:(NSInteger)curRow
{
    if (_curCell) {
        _curCell.progress = 0;
    }
    
    
    
    NSInteger index = curRow - self.line * 0.5;
    if (index < 0 ) {
        self.curRow = self.line * 0.5;
    } else if (index >= self.lyricList.count) {
        self.curRow = self.line * 0.5;
    } else {
        _curRow = curRow;
        
        
    }
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:_curRow inSection:0];

    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    if ([cell isKindOfClass:[YDDLyricCell class]]) {
        _curCell = (YDDLyricCell *)cell;
        [self startTimer];
    }
    
}

- (void)timerAction
{
    if (!_curCell) {
        return;
    }
    
    CGFloat curProgress = _curCell.progress;
    curProgress += _curCell.speed;
    _curCell.progress = curProgress;
    if (curProgress > 1) {
        [self stopTimer];
        self.curRow += 1;
    }
}

- (void)startTimer
{
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer fire];
}

- (void)stopTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lyricList.count + self.line;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.line > 0 ? self.tableView.frame.size.height / self.line : self.tableView.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row - self.line * 0.5;
    if (row >= 0 && row < self.lyricList.count) {
        YDDLyricCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YDDLyricCell class]) forIndexPath:indexPath];
        cell.lyricModel = self.lyricList[row];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    return cell;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor clearColor];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];

        [_tableView registerClass:[YDDLyricCell class] forCellReuseIdentifier:NSStringFromClass([YDDLyricCell class])];
        if (@available(iOS 13.0, *)) {
            _tableView.automaticallyAdjustsScrollIndicatorInsets = NO;
        } else {
            // Fallback on earlier versions
        }
        
    }
    return _tableView;
}




- (NSArray<YDDLyricModel *> *)lyricList
{
    if (!_lyricList) {
        
        NSString *str = @"风月\n\
        作词：文雅\n\
        作曲：YANG\n\
        演唱：黄龄\n\
        脱掉漂亮却磨脚的高跟鞋\n\
        锁门关灯背对喧哗的世界\n\
        素净一张脸收敛了眉眼\n\
        锦衣夜行过春天\n\
        未完成的恋情停在回车键\n\
        还挂心的人像风筝断了线\n\
        说过的再见\n\
        也就再也没有见\n\
        笑里融的甜 泪里裹的咸\n\
        不是缘就是劫\n\
        男人追新鲜 女人求安全\n\
        不过人性弱点\n\
        开始总是深深切切心心念念你情和我愿\n\
        然后总有清清浅浅挑挑拣拣你烦和我嫌\n\
        最终总会冷冷淡淡星星点点你厌和我怨\n\
        爱风月无边引人入胜的悬念\n\
        笑里融的甜 泪里裹的咸\n\
        不是缘就是劫\n\
        男人追新鲜 女人求安全\n\
        不过人性弱点\n\
        开始总是深深切切心心念念你情和我愿\n\
        然后总有清清浅浅挑挑拣拣你烦和我嫌\n\
        最终总会冷冷淡淡星星点点你厌和我怨\n\
        爱风月善变荆棘丛生的恩典\n\
        再过三五年\n\
        等事过境迁\n\
        会放下吗仍在纠结的牵连\n\
        从细枝末节\n\
        到心头余孽\n\
        摆不平的搞不定的全都交给时间\n\
        最难抵挡耳边的风眼底的月是人都难免\n\
        最难消解昨夜长风当时明月此事古难全\n\
        点了一支人去楼空缱绻事后会寂寞的烟\n\
        爱一场风月岁月里惊鸿一瞥\n\
        你就是风月也是心事的临与别";
    
        NSMutableArray *mutArr = [NSMutableArray array];
        NSArray *arr = [str componentsSeparatedByString:@"\n"];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YDDLyricModel *model = [[YDDLyricModel alloc] init];
            model.lyricText = obj;
            model.duration = arc4random() % 2 + 2;
            [mutArr addObject:model];
        }];
        _lyricList = mutArr;
     
    }
    return _lyricList;
}


@end
