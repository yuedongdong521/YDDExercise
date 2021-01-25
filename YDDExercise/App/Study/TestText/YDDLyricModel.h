//
//  YDDLyricModel.h
//  YDDExercise
//
//  Created by ydd on 2021/1/22.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDDLyricModel : NSObject

@property (nonatomic, copy) NSString *lyricText;

@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign, readonly) CGFloat speed;

@end

NS_ASSUME_NONNULL_END
