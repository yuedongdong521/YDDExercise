//
//  YDDWebTableViewCell.h
//  YDDExercise
//
//  Created by ydd on 2021/5/7.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDDWebCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDDWebTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^didChangedHeight)(CGFloat height, NSIndexPath *path);

@property (nonatomic, strong) YDDWebCellModel *cellModel;

- (void)setCellModel:(YDDWebCellModel *)cellModel indexPath:(NSIndexPath *)indexPath;



@end

NS_ASSUME_NONNULL_END
