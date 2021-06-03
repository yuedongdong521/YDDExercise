//
//  YDDDeviceAuthorizationTool.m
//  YDDExercise
//
//  Created by ydd on 2021/5/28.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDDeviceAuthorizationTool.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <Contacts/Contacts.h>

@implementation YDDDeviceAuthorizationTool



+ (void)checkCaptureAuthComplete:(void(^)(BOOL firstAuth, BOOL granted))complete
{
    AVAuthorizationStatus permission =
    [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (permission) {
        case AVAuthorizationStatusAuthorized:
            if(complete){
                complete(NO, YES);
            }
            break;
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                     completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (complete) {
                        complete(YES, granted);
                    }
                });
            }];
        }
            break;
        default:
            if(complete){
                complete(NO, NO);
            }
            break;
    }
}


+ (void)checkAudioAuthComplete:(void(^)(BOOL firstAuth, BOOL granted))complete
{
    AVAudioSessionRecordPermission permission = [[AVAudioSession sharedInstance] recordPermission];
    switch (permission) {
        case AVAudioSessionRecordPermissionUndetermined: {
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(complete){
                        complete(YES, granted);
                    }
                });
            }];
        }
            break;
        case AVAudioSessionRecordPermissionGranted:
            if(complete){
                complete(NO, YES);
            }
            break;
        default:
            if(complete){
                complete(NO, NO);
            }
            break;
    }
    
}


+ (void)checkPhotosAuthorComplete:(void(^)(BOOL firstAuth, BOOL granted))complete
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(complete){
                        complete(YES, status == PHAuthorizationStatusAuthorized);
                    }
                });
            }];
        }
            break;
        case PHAuthorizationStatusAuthorized:
            if(complete){
                complete(NO, YES);
            }
            break;
            
        default:
            if(complete){
                complete(NO, NO);
            }
            break;
    }
}



+ (void)checkContactAuthorComplete:(void (^)(BOOL firstAuth, BOOL granted))complete {
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (status) {
        case CNAuthorizationStatusAuthorized:
            if(complete){
                complete(NO, YES);
            }
            break;
        case CNAuthorizationStatusNotDetermined: {
            [[CNContactStore new] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(complete){
                        complete(YES, granted);
                    }
                });
            }];
        }
            break;
        default:
            if(complete){
                complete(NO, NO);
            }
        break;
    }
}



@end
