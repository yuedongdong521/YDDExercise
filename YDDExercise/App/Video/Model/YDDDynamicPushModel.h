//
//  YDDDynamicPushModel.h
//  YDDExercise
//
//  Created by ydd on 2020/7/3.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDDDynamicPushModel : NSObject
/// 头像
@property(nonatomic, strong) NSString *avatarUrl;
/// 评论id
@property(nonatomic, strong) NSString *commentId;
/// 发布时间
@property(nonatomic, assign) NSInteger createTime;
/// 发布动态类型: TXT-纯文本, IMAGE-纯图片, VIDEO-纯视屏, TXT_IMAGE-文本 + 图片, TXT_VIDEO-文本 + 视屏
@property(nonatomic, strong) NSString *feedTypeEnum;
/// 如果是图片，取第一张；如果是视频，取视频的封面地址
@property(nonatomic, strong) NSString *imageUrl;
/// 昵称
@property(nonatomic, strong) NSString *nickName;
/// 被评论id-如果是一级评论，此ID为空
@property(nonatomic, strong) NSString *parentCommentId;
/// 动态id
@property(nonatomic, strong) NSString *pubId;
/// 动态文本内容
@property(nonatomic, strong) NSString *text;
/// 用户id
@property(nonatomic, assign) NSInteger userId;


@end

NS_ASSUME_NONNULL_END
