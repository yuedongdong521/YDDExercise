//
//  YDDDeviceManager.h
//  YDDExercise
//
//  Created by ydd on 2021/5/10.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDDDeviceManager : NSObject

/// 设备名
@property (nonatomic, strong, readonly) NSString *deviceName;
/// 系统版本
@property (nonatomic, strong, readonly) NSString *systemName;
/// app版本
@property (nonatomic, strong, readonly) NSString *appVersion;
/// app编译版本
@property (nonatomic, strong, readonly) NSString *appBuild;
/// app包名， bundleId
@property (nonatomic, strong, readonly) NSString *appPackageName;
/// app名
@property (nonatomic, strong, readonly) NSString *appName;
/// 电池电量
@property (nonatomic, assign, readonly) CGFloat batteryLevel;

/// 设备唯一标识，卸载后会重新生成，所以保存到钥匙串里面
@property (nonatomic, strong, readonly) NSString *uuid;

+ (instancetype)shareManager;


@end

NS_ASSUME_NONNULL_END
