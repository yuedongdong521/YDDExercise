//
//  YDDVideoShowModel.m
//  YDDExercise
//
//  Created by ydd on 2020/6/18.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoShowModel.h"
/// 未关注
YDDAttentionStaue * const YDDAttention_unAttention = @"UNATTENTION";
/// 已关注
YDDAttentionStaue * const YDDAttention_attention = @"ATTENTION";
/// 本人
YDDAttentionStaue * const YDDAttention_principal = @"PRINCIPAL";
/// 未知
YDDAttentionStaue * const YDDAttention_unknown = @"UNKNOWN";


@implementation YDDVideoInfo


@end

@implementation YDDVideoShowModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"mainId" : @[@"id",@"mainId"]
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
  return @{@"video" : [YDDVideoInfo class]
  };
}


@end
