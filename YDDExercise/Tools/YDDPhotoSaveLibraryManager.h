//
//  YDDPhotoSaveLibraryManager.h
//  YDDExercise
//
//  Created by ydd on 2019/4/3.
//  Copyright © 2019 ibobei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
extern NSString *const YDDALBUM;

@interface YDDPhotoSaveLibraryManager : NSObject


/**
 将图片存入kuxiu相册

 @param image 目标图片
 @param completionHandler 结果返回
 */
+ (void)saveImage:(UIImage *)image toKXAlbumCompletionHandler:(void(^)(BOOL success))completionHandler;
+ (void)saveImages:(NSArray<UIImage *>*)images toAlbum:(nullable NSString *)albumName completionHandler:(void(^)(BOOL success))completionHandler;

/**
 将图片存入指定的相册文件夹

 @param image 要存入的图片对象
 @param albumName 要存入的相册名称,nil表示存入系统图库
 @param completionHandler 存入结果回调
 */
+ (void)saveImage:(UIImage *)image toAlbum:(nullable NSString *)albumName completionHandler:(void(^)(BOOL success))completionHandler;

+ (void)saveVideo:(NSURL *)videoUrl toAlbumName:(nullable NSString *)albumName completionHandler:(void(^)(BOOL success))completionHandler;

+ (void)saveVideo:(NSURL *)videoUrl
      toAlbumName:(nullable NSString *)albumName
         needTips:(BOOL)needTips
completionHandler:(void(^)(BOOL success))completionHandler;


/**
 请求相册访问权限

 @param block <#block description#>
 */
+ (void)requestPhotoAuthorizationBlock:(void(^)(BOOL hasAuthorize))block;

@end

NS_ASSUME_NONNULL_END
