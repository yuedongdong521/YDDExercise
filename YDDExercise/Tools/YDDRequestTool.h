//
//  YDDRequestTool.h
//  YDDExercise
//
//  Created by ydd on 2021/5/14.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    YDDRequestMethod_GET = 0,
    YDDRequestMethod_POST,
} YDDRequestMethod;

@interface YDDRequestTool : NSObject

@property (nonatomic, strong, readonly) NSMutableURLRequest *request;

@property (nonatomic, copy) NSString *requestUrl;

@property (nonatomic, copy) NSDictionary<NSString*, NSString*> *headDic;

@property (nonatomic, copy) NSDictionary<NSString*, NSString*> *bodyDic;

@property (nonatomic, assign) YDDRequestMethod method;

@property (nonatomic, assign) CGFloat timeOut;

@property (nonatomic, copy) void(^success)(id data);

@property (nonatomic, copy) void(^failuer)(NSError *error);

- (void)start;

- (void)cancel;

@end

NS_ASSUME_NONNULL_END
