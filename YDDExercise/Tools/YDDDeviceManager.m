//
//  YDDDeviceManager.m
//  YDDExercise
//
//  Created by ydd on 2021/5/10.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDDeviceManager.h"
#import <sys/utsname.h>
#import "YDDKeychainTool.h"

static YDDDeviceManager *_device;

@interface YDDDeviceManager ()

/// 设备名
@property (nonatomic, strong) NSString *deviceName;
/// 系统版本
@property (nonatomic, strong) NSString *systemName;
/// app版本
@property (nonatomic, strong) NSString *appVersion;
/// app编译版本
@property (nonatomic, strong) NSString *appBuild;
/// app包名， bundleId
@property (nonatomic, strong) NSString *appPackageName;
/// app名
@property (nonatomic, strong) NSString *appName;

@property (nonatomic, strong) NSString *uuid;

@end

@implementation YDDDeviceManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _device = [[YDDDeviceManager alloc] init];
    });
    return _device;
}

- (NSString *)deviceName
{
    if (!_deviceName) {
        struct utsname name;
        uname(&name);
        _deviceName = [NSString stringWithCString:name.machine encoding:NSUTF8StringEncoding];
    }
    return _deviceName;
}

- (NSString *)systemName
{
    if (!_systemName) {
        _systemName = [UIDevice currentDevice].systemName;
    }
    return _systemName;
}

- (NSString *)appVersion {
    
    if (nil == _appVersion) {
        _appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    return _appVersion;
}

- (NSString *)appBuild {
    if (!_appBuild) {
        _appBuild = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }
    return _appBuild;
}

- (NSString *)appPackageName
{
    if (!_appPackageName) {
        _appPackageName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    }
    return _appPackageName;
}

- (NSString *)appName {
    if (!_appName) {
        _appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    }
    return _appName;
}

- (CGFloat)batteryLevel{

    return [[UIDevice currentDevice] batteryLevel];
}


- (NSString *)uuid
{
    if (!_uuid) {
        
        NSString *str = [[YDDKeychainTool share] objectForKey:kSecAttrService];
        if ([str isKindOfClass:[NSString class]] && str.length > 0) {
            _uuid = str;
        } else {
            CFUUIDRef uuid = CFUUIDCreate(nil);
            CFStringRef uuidStr = CFUUIDCreateString(nil, uuid);
            _uuid = (NSString *)CFBridgingRelease(CFStringCreateCopy(nil, uuidStr));
            CFRelease(uuid);
            CFRelease(uuidStr);
            [[YDDKeychainTool share] setObject:_uuid forKey:kSecAttrService];
        }
    }
    return _uuid;
}


@end
