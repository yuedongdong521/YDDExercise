//
//  YDDLRUMutDic.h
//  YDDExercise
//
//  Created by ydd on 2021/4/22.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 最近最少使用算法，缓存算法

@interface YDDLRUMutDic<__covariant KeyType, __covariant ObjectType> : NSObject


// maxCountLRU: 执行LRU算法时的最大存储的元素数量
- (instancetype)initWithMaxCountLRU:(NSUInteger)maxCountLRU;

//*****NSDictionary
@property (readonly) NSUInteger count;

- (NSEnumerator<KeyType> *)keyEnumerator;

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(KeyType key, ObjectType obj, BOOL *stop))block;

//*****NSMutableDictionary
- (void)removeObjectForKey:(KeyType)aKey;
- (void)setObject:(ObjectType)anObject forKey:(KeyType <NSCopying>)aKey;

- (void)removeAllObjects;
- (void)removeObjectsForKeys:(NSArray<KeyType> *)keyArray;

//*****LRUMutableDictionary
// 执行LRU算法，当访问的元素可能是被淘汰的时候，可以通过在block中返回需要访问的对象，会根据LRU机制自动添加到dictionary中
- (ObjectType)objectForKey:(KeyType)aKey returnEliminateObjectUsingBlock:(ObjectType (^)(BOOL maybeEliminate))block;



@end

NS_ASSUME_NONNULL_END
