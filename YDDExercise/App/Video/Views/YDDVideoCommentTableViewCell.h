//
//  YDDVideoCommentTableViewCell.h
//  YDDExercise
//
//  Created by ydd on 2020/6/22.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDDVideoCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDDVideoCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) YDDVideoCommentModel *commentModel;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void(^likeBlock)(YDDVideoCommentModel *commentModel, void(^completed)(YDDVideoCommentModel *commentModel, BOOL success));

@property (nonatomic, copy) void(^userBlock)(YDDVideoCommentModel *commentModel);

@property (nonatomic, copy) void(^longBlock)(YDDVideoCommentModel *commentModel, NSIndexPath *indexPath);

@property (nonatomic, copy) void(^contentBlock)(YDDVideoCommentModel *commentModel, NSIndexPath *indexPath);

+ (CGFloat)cellHeight;

+ (CGFloat)contentMaxWidth;

- (void)updateCommentModel:(YDDVideoCommentModel *)commentModel indexPath:(NSIndexPath *)indexPath isAuthor:(BOOL)isAuthor;

@end

@interface KXVideoCommentFirstCell : YDDVideoCommentTableViewCell

@end

NS_ASSUME_NONNULL_END
