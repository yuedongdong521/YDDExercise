//
//  YDDFileManager.m
//  YDDExercise
//
//  Created by ydd on 2021/2/9.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDFileManager.h"

#define _fileManager [NSFileManager defaultManager]

@implementation YDDFileManager


+ (NSString *)ydd_createDocumentDirectory:(NSString *)direName
{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    NSString *direPath = [documentPath stringByAppendingPathComponent:direName];
    BOOL isDire;
    if ([_fileManager fileExistsAtPath:direPath isDirectory:&isDire]) {
        if (isDire) {
            return direPath;
        }
    }
    [_fileManager createDirectoryAtPath:direPath withIntermediateDirectories:YES attributes:nil error:nil];
    return direPath;
}

+ (NSString *)ydd_createDocumentPathWithDire:(NSString *)direName fileName:(NSString *)fileName
{
    NSString *direPath = [self ydd_createDocumentDirectory:direName];
    return [direPath stringByAppendingPathComponent:fileName];
}


/// 创建文件夹
+ (NSString *)ydd_creatRandomDocumentWithDirName:(NSString *)dirName fileName:(nullable NSString *)fileName
{
    NSString *path = [self ydd_createDocumentDirectory:dirName];
    
    if (!fileName) {
        fileName = [NSString stringWithFormat:@"%lu.png", (NSUInteger)[[NSDate date] timeIntervalSince1970] * 1000];
    }
    return [path stringByAppendingPathComponent:fileName];
}

+ (nullable NSString *)ydd_readKTVDire
{
    return [self ydd_createDocumentDirectory:@"KTVHTTPCache"];
}

+ (nullable NSString *)ydd_readKTVCacheWithPath:(NSString *)path
{
    NSString *file = [self ydd_readKTVDire];
    NSString *name = [path md5String];
    NSString *direPath = [NSString stringWithFormat:@"%@/%@", file, name];
    BOOL isDire;
    BOOL isExits = [_fileManager fileExistsAtPath:direPath isDirectory:&isDire];
    if (isDire && isExits) {
        return [NSString stringWithFormat:@"%@/%@.mp4", direPath, name];
    }
    return nil;
}

+ (void)ydd_enumDire:(NSString *)direName fileBlock:(void(^)(NSString *filePath))fileBlock
{
    NSString *direPath = [self ydd_createDocumentDirectory:direName];

    NSArray <NSString *>*files = [_fileManager subpathsAtPath:direPath];
    
    for (NSString *fileName in files) {
        
        /** 判断是否是隐藏文件 */
        if ([fileName hasPrefix:@".DS"]) {
            continue;
        }
        /** 拼接获取完整路径 */
        NSString * subPath = [direPath stringByAppendingPathComponent:fileName];
        
        /** 判断是否是文件夹 */
        BOOL isDirectory;
        [_fileManager fileExistsAtPath:subPath isDirectory:&isDirectory];
        if (isDirectory) {
            [self ydd_enumDire:subPath fileBlock:fileBlock];
            continue;
        }
        if (fileBlock) {
            fileBlock(subPath);
        }
    }
}

+ (NSInteger)ydd_readFileSize:(NSString *)filePath
{
    if ([_fileManager fileExistsAtPath:filePath]) {
        return [[_fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+ (NSInteger)ydd_readDireSize:(NSString *)dire
{
    __block NSInteger size = 0;
    [self ydd_enumDire:dire fileBlock:^(NSString *filePath) {
        size += [self ydd_readFileSize:filePath];
    }];
    return size;
}

-(NSInteger)getSizeOfFilePath:(NSString *)filePath {
    
    /** 定义记录大小 */
    
    NSInteger totalSize = 0;
    
    /** 创建一个文件管理对象 */
    
    NSFileManager * manager = [NSFileManager defaultManager];
    
    /**获取文件下的所有路径包括子路径 */
    
    NSArray * subPaths = [manager subpathsAtPath:filePath];
    
    /** 遍历获取文件名称 */
    
    for (NSString * fileName in subPaths) {
        
        /** 拼接获取完整路径 */
        
        NSString * subPath = [filePath stringByAppendingPathComponent:fileName];
        
        /** 判断是否是隐藏文件 */
        
        if ([fileName hasPrefix:@".DS"]) {
            
            continue;
            
        }
        
        /** 判断是否是文件夹 */
        
        BOOL isDirectory;
        
        [manager fileExistsAtPath:subPath isDirectory:&isDirectory];
        
        if (isDirectory) {
            
            continue;
            
        }
        
        /** 获取文件属性 */
        
        NSDictionary *dict = [manager attributesOfItemAtPath:subPath error:nil];
        
        /** 累加 */
        
        totalSize += [dict fileSize];
        
    }
    
    /** 返回 */
    
    return totalSize;
    
}

+ (void)ydd_enumDireFileWithDireName:(NSString *)direName fileBlock:(void(^)(NSString *fileName))fileBlock
{
    NSString *direPath = [self ydd_createDocumentDirectory:direName];
    NSEnumerator *childFilesEnumerator = [[_fileManager subpathsAtPath:direPath] objectEnumerator];
    NSString *fileName;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString *fileAbsolutePath = [direPath stringByAppendingPathComponent:fileName];
        if (fileBlock) {
            fileBlock(fileAbsolutePath);
        }
    }
}


//单个文件的大小(字节)
+ (unsigned long long)ydd_fileSizeAtPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}



@end
