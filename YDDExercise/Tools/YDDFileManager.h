//
//  YDDFileManager.h
//  YDDExercise
//
//  Created by ydd on 2021/2/9.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDDFileManager : NSObject

+ (NSString *)ydd_createDocumentDirectory:(NSString *)direName;

+ (NSString *)ydd_createDocumentPathWithDire:(NSString *)direName fileName:(NSString *)fileName;

+ (NSString *)ydd_creatRandomDocumentWithDirName:(NSString *)dirName fileName:(nullable NSString *)fileName;

/// 读取KTV缓存文件夹
+ (nullable NSString *)ydd_readKTVDire;
/// 读取 KTVHTTPCache 缓存MP4文件
/// @param path <#path description#>
+ (nullable NSString *)ydd_readKTVCacheWithPath:(NSString *)path;

/// 遍历文件夹
/// @param direName <#direName description#>
/// @param fileBlock <#fileBlock description#>
+ (void)ydd_enumDire:(NSString *)direName fileBlock:(void(^)(NSString *filePath))fileBlock;

/// 读取文件大小，单位：字节
/// @param filePath <#filePath description#>
+ (NSInteger)ydd_readFileSize:(NSString *)filePath;


/// 读取文件夹大小，单位：字节
/// @param dire <#dire description#>
+ (NSInteger)ydd_readDireSize:(NSString *)dire;


/// 遍历文件夹
/// @param direName <#direName description#>
/// @param fileBlock <#fileBlock description#>
+ (void)ydd_enumDireFileWithDireName:(NSString *)direName fileBlock:(void(^)(NSString *fileName))fileBlock;

/// 读取问价大小
/// @param filePath <#filePath description#>
+ (unsigned long long)ydd_fileSizeAtPath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
