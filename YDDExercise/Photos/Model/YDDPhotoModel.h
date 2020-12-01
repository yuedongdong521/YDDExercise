//
//  YDDPhotoModel.h
//  YDDExercise
//
//  Created by ydd on 2019/7/17.
//  Copyright © 2019 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDDPhotoModel : NSObject

@property (nonatomic, strong, readonly) NSURL *imageURL;

@property (nonatomic, strong, readonly) UIImage *image;

@property (nonatomic, assign) BOOL isAdd;

- (void)setupImage:(UIImage * _Nonnull)image;

- (void)setupImagePath:(nonnull NSString *)imagePath;


@end

NS_ASSUME_NONNULL_END
