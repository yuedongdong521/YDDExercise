//
//  YDDHomeHeaderView.m
//  YDDExercise
//
//  Created by ydd on 2019/7/23.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "YDDHomeHeaderView.h"
#import "SDCycleScrollView.h"
#import "YDDHomeModel.h"

@interface YDDHomeHeaderView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *scrollView;

@end

@implementation YDDHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (SDCycleScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:kImagePlaceholder];
        _scrollView.showPageControl = YES;
    }
    return _scrollView;
}

- (void)setHeadArr:(NSArray<YDDHomeModel *> *)headArr
{
    _headArr = headArr;
    NSMutableArray *array = [NSMutableArray array];
    [headArr enumerateObjectsUsingBlock:^(YDDHomeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj.iconUrl];
    }];
    
    self.scrollView.imageURLStringsGroup = array;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (_selectedBlock) {
        if (index < self.headArr.count) {
            _selectedBlock(self.headArr[index]);
        }
    }
}



@end
