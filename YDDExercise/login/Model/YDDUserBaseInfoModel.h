//
//  YDDUserBaseInfoModel.h
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUserInfoWriteKey(userId) [NSString stringWithFormat:@"UserInfoWrite_%ld", userId]

NS_ASSUME_NONNULL_BEGIN



@interface YDDUserBaseInfoModel : NSObject<NSCopying, NSCoding>

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, strong) NSDate *loginDate;

@end

NS_ASSUME_NONNULL_END
