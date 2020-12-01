//
//  YDDHomeViewController.m
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "YDDHomeViewController.h"
#import "YDDHomeModel.h"
#import "YDDWaterfallFlowLayout.h"
#import "YDDHomeCollectionViewCell.h"
#import "YDDHomeHeaderView.h"
#import "YDDWebViewController.h"
#import "YDDDetailsViewController.h"

@interface YDDHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <YDDHomeModel *>* headArray;
@property (nonatomic, strong) NSMutableArray <YDDHomeModel *>* mutArray;


@end

@implementation YDDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigBar];
    [self createUI];
    
    [self readData];
   
}

- (void)readData
{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"HomeData" ofType:@"json"]];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers error:&error];
    if ([dic[@"header"] isKindOfClass:[NSArray class]]) {
        self.headArray = (NSMutableArray *)[NSMutableArray yy_modelArrayWithClass:[YDDHomeModel class] json:[dic objectForKey:@"header"]];
    }
    if ([[dic objectForKey:@"cell"] isKindOfClass:[NSArray class]]) {
        self.mutArray = (NSMutableArray *)[NSMutableArray yy_modelArrayWithClass:[YDDHomeModel class] json:[dic objectForKey:@"cell"]];
    }
    
    [self.collectionView reloadData];
}

- (void)createUI
{
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0));
    }];
   
}

#pragma make - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mutArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    YDDHomeHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(YDDHomeHeaderView.class) forIndexPath:indexPath];
    header.headArr = self.headArray;
    weakObj(self);
    header.selectedBlock = ^(YDDHomeModel * _Nonnull model) {
        strongObj(self, weakself);
        YDDWebViewController *webVC = [[YDDWebViewController alloc] init];
        webVC.urlStr = model.linkUrl;
        [strongself.navigationController pushViewController:webVC animated:YES];
    };
    return header;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YDDHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(YDDHomeCollectionViewCell.class) forIndexPath:indexPath];
    cell.model = self.mutArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YDDDetailsViewController *vc = [[YDDDetailsViewController alloc] init];
    vc.model = self.mutArray[indexPath.item];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - YDDWaterfallFlowLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(YDDWaterfallFlowLayout*)collectionViewLayout heightForWidth:(CGFloat)width indexPath:(NSIndexPath*)indexPath
{
    YDDHomeModel *model = self.mutArray[indexPath.item];
    if (width > 0) {
      return  model.width / width * model.height + kLabelHeight;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(YDDWaterfallFlowLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    return 200;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(YDDWaterfallFlowLayout *)collectionViewLayout columnCountForSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(YDDWaterfallFlowLayout*)collectionViewLayout rowMarginForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(YDDWaterfallFlowLayout*)collectionViewLayout columnMarginForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(YDDWaterfallFlowLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(YDDWaterfallFlowLayout *)collectionViewLayout insetForHeaderInSection:(NSInteger)section
{
     return UIEdgeInsetsMake(0, 10, 10, 10);
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        YDDWaterfallFlowLayout *flowLayout = [[YDDWaterfallFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[YDDHomeCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(YDDHomeCollectionViewCell.class)];
        [_collectionView registerClass:[YDDHomeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YDDHomeHeaderView.class)];
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }
    return _collectionView;
}



- (void)setNavigBar
{
    self.navBarView.title = @"首页";
    [self.navBarView.leftBtn setImage:[UIImage imageNamed:@"zhankaicebianlan"] forState:UIControlStateNormal];
    [self.navBarView.leftBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    weakObj(self);
    self.navBarView.leftBlock = ^{
        strongObj(self, weakself);
        [strongself leftAction];
    };
}

- (void)leftAction
{

    [kAppManager showOrHideLeftSideBar];
}

- (NSMutableArray<YDDHomeModel *> *)mutArray
{
    if (!_mutArray) {
        _mutArray = [NSMutableArray array];
    }
    return _mutArray;
}

- (void)dealloc
{
    NSLog(@"dealloc : %@", NSStringFromClass(self.class));
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
