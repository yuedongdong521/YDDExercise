//
//  YDDAddImageTools.m
//  YDDExercise
//
//  Created by ydd on 2019/7/17.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "YDDAddImageTools.h"
#import "TZImagePickerController.h"
#import "TOCropViewController.h"


static YDDAddImageTools *_YDDAddImageTools;

@interface YDDAddImageTools ()<TZImagePickerControllerDelegate, TOCropViewControllerDelegate>

@property (nonatomic, copy) void(^completeHandle)(UIImage *image);

@end


@implementation YDDAddImageTools

+ (instancetype)shareTools
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _YDDAddImageTools = [[YDDAddImageTools alloc] init];
    });
    return _YDDAddImageTools;
}

+(void)addImagePickerWithTargetViewController:(UIViewController *)targeVC completeHandle:(void(^)(UIImage *image))completeHandle
{
    
    [YDDAddImageTools shareTools].completeHandle = completeHandle;
    [[YDDAddImageTools shareTools] openImagePickerWithTargetViewController:targeVC];
}


- (void)openImagePickerWithTargetViewController:(UIViewController *)targeVC
{
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVC.allowPickingGif = NO;
    imagePickerVC.allowPickingVideo = NO;
    imagePickerVC.preferredLanguage = @"zh-Hans";
    [targeVC presentViewController:imagePickerVC animated:YES completion:nil];
}


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    
    if (self.completeHandle) {
        self.completeHandle(photos.firstObject);
    }
}


- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    
}






@end
