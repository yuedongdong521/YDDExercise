//
//  YDDHomeModel.h
//  YDDExercise
//
//  Created by ydd on 2019/7/23.
//  Copyright © 2019 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDDHomeModel : NSObject

@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *signal;
@property (nonatomic, copy) NSString *linkUrl;

@end

NS_ASSUME_NONNULL_END
