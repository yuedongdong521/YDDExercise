//
//  YDDLRUCache.h
//  YDDExercise
//
//  Created by ydd on 2021/4/25.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YDDLRUCModel)

@property (nonatomic, copy) NSString *lruCacheId;

@end


@interface YDDLRUCache : NSObject

@property (nonatomic, assign) NSInteger maxCount;


+ (void)cacheObj:(NSObject *)obj;

+ (NSObject *)readCache:(NSString *)cacheId;

+ (void)debugNode;


@end

NS_ASSUME_NONNULL_END
