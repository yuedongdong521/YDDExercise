//
//  YDDVideoShowModel.h
//  YDDExercise
//
//  Created by ydd on 2020/6/18.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString YDDAttentionStaue;
/// 未关注
extern YDDAttentionStaue * const YDDAttention_unAttention;
/// 已关注
extern YDDAttentionStaue * const YDDAttention_attention;
/// 本人
extern YDDAttentionStaue * const YDDAttention_principal;
/// 未知
extern YDDAttentionStaue * const YDDAttention_unknown;

@interface YDDVideoInfo : NSObject

/// 视频封面地址
@property (nonatomic, strong) NSString *videoCoverUrl;
/// 视频地址
@property (nonatomic, strong) NSString *videoUrl;
/// 视频持续时长, 以秒为单位, 保留两位小数
@property (nonatomic, assign) CGFloat duration;
/// 高
@property (nonatomic, assign) NSInteger high;
/// 视频大小，以M为单位, 保留两位小数
@property (nonatomic, assign) CGFloat scale;
/// 宽
@property (nonatomic, assign) NSInteger wide;


@end

@interface YDDVideoShowModel : NSObject
/// 动态地址: 格式: 省名称+市名称, 例如: 上海市-闵行区
@property (nonatomic, strong) NSString *address;
/// 主播等级
@property (nonatomic, assign) NSInteger anchorLevel;
/// 头像
@property (nonatomic, strong) NSString *avatarUrl;
/// 评论总数
@property (nonatomic, assign) NSInteger commentsTotal;
/// 直播封面
@property (nonatomic, strong) NSString *coverUrl;
/// 发布时间
@property (nonatomic, assign) NSInteger createTime;
/// 是否点赞: true-是，false-未点赞或取消点赞
@property (nonatomic, assign) BOOL dirty;
/// 距离, 单位km, 保留2位小数
@property (nonatomic, strong) NSString *distance;
/// 当前集合主键id
@property (nonatomic, strong) NSString *mainId;
/// 用户类型，0-普通用户，1-主播
@property (nonatomic, assign) NSInteger isAnchor;
/// 0-没有直播，1-正在直播
@property (nonatomic, assign) NSInteger isPlaying;
/// 点赞总数
@property (nonatomic, assign) NSInteger likedTotal;
/// 昵称
@property (nonatomic, strong) NSString *nickName;
/// 动态id
@property (nonatomic, strong) NSString *pubId;
/// 关系: UNATTENTION-未关注, ATTENTION-关注, PRINCIPAL-当事人, UNKNOWN-未知
@property (nonatomic, strong) YDDAttentionStaue *relationship;
/// 性别: 0-未知,1-男，2-女
@property (nonatomic, assign) NSInteger sex;
/// 靓号
@property (nonatomic, assign) NSInteger showId;
/// 主播拉流ACC地址
@property (nonatomic, strong) NSString *urlPlayAcc;
/// 主播拉流FLV地址
@property (nonatomic, strong) NSString *urlPlayFlv;
/// 主播拉流HLS地址
@property (nonatomic, strong) NSString *urlPlayHls;
/// 主播拉流RTMP地址
@property (nonatomic, strong) NSString *urlPlayRtmp;

/// 新版用户头像框ID,非空且大于零有效
@property (nonatomic, assign) NSInteger userAvatarFrameIdNew;
/// 用户id
@property (nonatomic, assign) NSInteger userId;
/// 用户等级
@property (nonatomic, assign) NSInteger userLevel;
/// 视频信息
@property (nonatomic, strong) YDDVideoInfo *video;
/// 描述内容
@property (nonatomic, strong) NSString *text;
/// 短视视频音乐名称
@property (nonatomic, strong) NSString *videoMusicName;
/// 分享数
@property (nonatomic, assign) NSInteger sharedCount;


@end

NS_ASSUME_NONNULL_END
