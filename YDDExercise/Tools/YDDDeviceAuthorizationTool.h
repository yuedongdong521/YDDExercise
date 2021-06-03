//
//  YDDDeviceAuthorizationTool.h
//  YDDExercise
//
//  Created by ydd on 2021/5/28.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDDDeviceAuthorizationTool : NSObject

/// 相机权限
+ (void)checkCaptureAuthComplete:(void(^)(BOOL firstAuth, BOOL granted))complete;

/// 麦克风权限
+ (void)checkAudioAuthComplete:(void(^)(BOOL firstAuth, BOOL granted))complete;

/// 相册权限
+ (void)checkPhotosAuthorComplete:(void(^)(BOOL firstAuth, BOOL granted))complete;

/// 通讯录权限
+ (void)checkContactAuthorComplete:(void (^)(BOOL firstAuth, BOOL granted))complete;


@end

NS_ASSUME_NONNULL_END
