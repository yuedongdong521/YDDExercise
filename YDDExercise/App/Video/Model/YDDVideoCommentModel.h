//
//  YDDVideoCommentModel.h
//  YDDExercise
//
//  Created by ydd on 2020/6/22.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDDVideoCommentModel : NSObject


/// 主播等级
@property (nonatomic, assign)   NSInteger  anchorLevel;
/// 头像
@property (nonatomic, copy)     NSString  *avatarUrl;
/// 评论的内容
@property (nonatomic, copy)     NSString  *content;
/// 评论用户id
@property (nonatomic, copy)     NSString  *fromUserId;
/// 当前评论的主键
@property (nonatomic, copy)     NSString  *commentId;
/// 用户类型，0-普通用户，1-主播
@property (nonatomic, assign)   NSInteger  isAnchor;
/// 昵称
@property (nonatomic, copy)     NSString  *nickName;
/// 被评论的主键
@property (nonatomic, copy)     NSString  *referencePrimaryKey;
/// 性别
@property (nonatomic, assign)   NSInteger  sex;
/// 被评论者昵称
@property (nonatomic, copy)     NSString  *targetNickName;
/// 被评论者id
@property (nonatomic, copy)     NSString  *targetUserId;
/// 评论时间
@property (nonatomic, copy)     NSString  *timestamp;
/// 内容的类型: COMMENT-评论, REPLY-回复
@property (nonatomic, copy)     NSString  *type;
/// 用户等级
@property (nonatomic, assign)  NSInteger  userLevel;
// 头像框添加
@property (nonatomic, assign) NSInteger fromUserAvatarFrameId; // 用户头像框ID,非空且大于零有效
@property (nonatomic, assign) NSInteger targetUserAvatarFrameId; // 被评论者头像框ID,非空且大于零有效
/// 回复目标对象的ID
@property (nonatomic, copy)     NSString *parentCommentId;


/// item高度
@property (nonatomic, assign)  NSInteger  cellHeight;



/// 评论点赞数
@property (nonatomic, assign) NSInteger likeTotal;
/// 是否点赞: true-是，false-未点赞或取消点赞
@property (nonatomic, assign) BOOL dirty;

@property (nonatomic, assign) CGFloat contentHeight;

@property(nonatomic, strong, nullable) NSAttributedString *contentAtt;


@end

@interface KXVideoCommentListModel : NSObject

/// 评论列表
@property (nonatomic, strong) NSArray <YDDVideoCommentModel*>*commentPageRespList;

/// 评论总数
@property (nonatomic, assign) NSInteger commentsTotal;

@end


NS_ASSUME_NONNULL_END
