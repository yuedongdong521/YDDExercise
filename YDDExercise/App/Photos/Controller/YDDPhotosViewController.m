//
//  YDDPhotosViewController.m
//  YDDExercise
//
//  Created by ydd on 2019/7/17.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "YDDPhotosViewController.h"
#import "YDDWaterfallFlowLayout.h"
#import "YDDPhotosCollectionViewCell.h"
#import "YDDAddImageTools.h"
#import "YDDPhotoModel.h"
#import "YDDPhotoGroupView.h"

@interface YDDPhotosViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, YDDWaterfallFlowLayoutDelegate, YDDPhotoGroupViewDelegate>

@property (nonatomic, strong) NSMutableArray <YDDPhotoModel *>*photosArr;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) YDDPhotoModel *addModel;

@end

@implementation YDDPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBarView.title = @"相册";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavBarHeight, 0, kTabBarHeight, 0));
    }];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        YDDWaterfallFlowLayout *flowLayout = [[YDDWaterfallFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[YDDPhotosCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(YDDPhotosCollectionViewCell.class)];
        
    }
    return _collectionView;
}

- (YDDPhotoModel *)addModel
{
    if (!_addModel) {
        _addModel = [[YDDPhotoModel alloc] init];
        [_addModel setupImage:[UIImage imageNamed:@"addphotos"]];
    }
    return _addModel;
}

- (NSMutableArray<YDDPhotoModel *> *)photosArr
{
    if (!_photosArr) {
        _photosArr = [NSMutableArray array];
    }
    return _photosArr;
}

#pragma mark - UICollectionViewDelegate -

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(YDDWaterfallFlowLayout*)collectionViewLayout heightForWidth:(CGFloat)width indexPath:(NSIndexPath*)indexPath
{
    return width;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(YDDWaterfallFlowLayout *)collectionViewLayout columnCountForSection:(NSInteger)section;
{
    return 4;
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
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photosArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YDDPhotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(YDDPhotosCollectionViewCell.class) forIndexPath:indexPath];
    
    if (self.photosArr.count > indexPath.item) {
        cell.model = self.photosArr[indexPath.item];
    } else {
        cell.model = self.addModel;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.photosArr.count > indexPath.item) {
        NSMutableArray *mutArr = [NSMutableArray array];
        [self.photosArr enumerateObjectsUsingBlock:^(YDDPhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PhotoGroupItem *item = [[PhotoGroupItem alloc] init];
            item.largeImageURL = obj.imageURL;
            item.index = idx;
            [mutArr addObject:item];
        }];
        YDDPhotoGroupView *view = [[YDDPhotoGroupView alloc] initWithGroupItems: mutArr];
        view.delegate = self;
        [view hiddenPageControl:YES];
        [view presentFromCurItem:indexPath.item toContainer:[UIApplication sharedApplication].keyWindow animated:YES ompletion:^{
            
        }];
    } else {
        weakObj(self);
        [YDDAddImageTools addImagePickerWithTargetViewController:self completeHandle:^(UIImage * _Nonnull image) {
            strongObj(self, weakself);
            [strongself addImage:image];
        }];
    }
    
}

- (void)addImage:(UIImage *)image
{
    YDDPhotoModel *model = [[YDDPhotoModel alloc] init];
    [model setupImage:image];
    [self.photosArr addObject:model];
    [self.collectionView reloadData];
}

- (UIView *)getCurrentThumbViewWithPage:(NSInteger)page
{
    return [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0]];
}

- (UIView *)YDDPhotoGroupView:(YDDPhotoGroupView *)YDDPhotoGroupView getThumbViewWithPage:(NSInteger)page
{
    return [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0]];
}

- (UIImage *)YDDPhotoGroupView:(YDDPhotoGroupView *)YDDPhotoGroupView getImageWithPage:(NSInteger)page
{
    YDDPhotosCollectionViewCell *cell = (YDDPhotosCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0]];
    return cell.imageView.image;
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
