//
//  YDDVideoCommentViewController.h
//  YDDExercise
//
//  Created by ydd on 2020/6/22.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDDVideoShowModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YDDVideoCommentViewController : UIViewController

@property (nonatomic, strong) YDDVideoShowModel *videoModel;

@property (nonatomic, copy) void(^attentionCallBack)(NSInteger userId, BOOL isAttention);

@property (nonatomic, copy) void(^changePlayerStatue)(BOOL isPause);

+ (YDDVideoCommentViewController *)presnetWithVideoModel:(YDDVideoShowModel *)videoModel
                                                 superVC:(nullable UIViewController *)superVC
                                    callBackCommentTotal:(nonnull void (^)(NSInteger total))callBackCommentTotal;



@end


NS_ASSUME_NONNULL_END
