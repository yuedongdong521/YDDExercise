//
//  YDDAddImageTools.h
//  YDDExercise
//
//  Created by ydd on 2019/7/17.
//  Copyright © 2019 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface YDDAddImageTools : NSObject

+(void)addImagePickerWithTargetViewController:(UIViewController *)targeVC completeHandle:(void(^)(UIImage *image))completeHandle;


@end

NS_ASSUME_NONNULL_END
