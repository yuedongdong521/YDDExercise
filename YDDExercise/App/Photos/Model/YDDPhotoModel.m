//
//  YDDPhotoModel.m
//  YDDExercise
//
//  Created by ydd on 2019/7/17.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "YDDPhotoModel.h"

@implementation YDDPhotoModel

- (UIImage *)image
{
    if ([_imageURL isFileURL]) {
        return [UIImage imageWithContentsOfFile:_imageURL.absoluteString];
    }
    return nil;
}


- (void)setupImage:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    if (imageData) {
        _imageURL = [NSURL fileURLWithPath:[self createImagePath]];
        [imageData writeToURL:_imageURL atomically:YES];
    }
}

- (void)setupImagePath:(NSString *)imagePath
{
    if ([imagePath hasPrefix:@"http://"] || [imagePath hasPrefix:@"https://"]) {
        _imageURL = [NSURL URLWithString:imagePath];
    } else {
        _imageURL = [NSURL fileURLWithPath:imagePath];
    }
   
}

- (NSString *)createImagePath
{
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"photos"];
    BOOL isDir = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir] || !isDir) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [NSString stringWithFormat:@"%@/%f.png", path, [[NSDate date] timeIntervalSince1970]];
}


@end
