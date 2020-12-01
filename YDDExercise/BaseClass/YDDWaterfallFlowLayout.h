//
//  YDDWaterfallFlowLayout.h
//  Yddworkspace
//
//  Created by ydd on 2019/6/27.
//  Copyright © 2019 QH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YDDWaterfallFlowLayout;
@protocol YDDWaterfallFlowLayoutDelegate <NSObject>

@required
/**
 *根据宽度计算返回的高度
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(YDDWaterfallFlowLayout*)collectionViewLayout heightForWidth:(CGFloat)width indexPath:(NSIndexPath*)indexPath;

@optional
/**
 *返回头部高度
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(YDDWaterfallFlowLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section;
/**
 *返回尾部高度
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(YDDWaterfallFlowLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section;
/**
 *返回列数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(YDDWaterfallFlowLayout *)collectionViewLayout columnCountForSection:(NSInteger)section;
/**
 *返回每行之间的间隙
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(YDDWaterfallFlowLayout*)collectionViewLayout rowMarginForSectionAtIndex:(NSInteger)section;
/**
 *返回每列之间的间隙
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(YDDWaterfallFlowLayout*)collectionViewLayout columnMarginForSectionAtIndex:(NSInteger)section;
/**
 *返回每个区的UIEdgeInsets偏移量
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(YDDWaterfallFlowLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

/**
 *返回每个区Header的UIEdgeInsets偏移量
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(YDDWaterfallFlowLayout *)collectionViewLayout insetForHeaderInSection:(NSInteger)section;

/**
 *返回每个区Footer的UIEdgeInsets偏移量
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(YDDWaterfallFlowLayout *)collectionViewLayout insetForFooterInSection:(NSInteger)section;

@end


@interface YDDWaterfallFlowLayout : UICollectionViewLayout

///行间距
@property (nonatomic, assign) CGFloat rowMargin;
///列间距
@property (nonatomic, assign) CGFloat columnMargin;
///最大列数
@property (nonatomic, assign) CGFloat columnCount;
///头部高度
@property (nonatomic, assign) CGFloat headerHeight;
///尾部高度
@property (nonatomic, assign) CGFloat footerHeight;
///区间距
@property (nonatomic, assign) UIEdgeInsets sectionInset;
///头间距
@property (nonatomic, assign) UIEdgeInsets headerInset;
///尾间距
@property (nonatomic, assign) UIEdgeInsets footerInset;

@end

NS_ASSUME_NONNULL_END
