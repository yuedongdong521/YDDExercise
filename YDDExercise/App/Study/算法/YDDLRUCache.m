//
//  YDDLRUCache.m
//  YDDExercise
//
//  Created by ydd on 2021/4/25.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDLRUCache.h"

#import <objc/runtime.h>

static const void *klruCacheId = &klruCacheId;

@implementation NSObject (YDDLRUCModel)

- (NSString *)lruCacheId
{
    return objc_getAssociatedObject(self, klruCacheId);
}

- (void)setLruCacheId:(NSString *)lruCacheId
{
    objc_setAssociatedObject(self, klruCacheId, lruCacheId, OBJC_ASSOCIATION_COPY);
}

@end

typedef struct YDDNode YDDNode;

struct YDDNode {
    YDDNode *head;
    YDDNode *next;
    NSObject *obj;
};




@interface YDDLRUNode : NSObject<NSCopying>

@property (nonatomic, weak, nullable) YDDLRUNode *head;

@property (nonatomic, strong) NSObject *content;

@property (nonatomic, weak, nullable) YDDLRUNode *next;


@end

@implementation YDDLRUNode

- (instancetype)initWithContent:(NSObject *)content headContent:(nullable YDDLRUNode *)head nextContent:(nullable YDDLRUNode *)next
{
    self = [super init];
    if (self) {
        _head = head;
        
        _content = content;
        
        _next = next;
    }
    return self;
}

- (instancetype)initWithContent:(NSObject *)content
{
    self = [super init];
    if (self) {
        _head = nil;
        _content = content;
        _next = nil;
    }
    return self;
}

- (instancetype)initWithContent:(NSObject *)content next:(nullable YDDLRUNode *)next
{
    self = [super init];
    if (self) {
        _head = nil;
        _content = content;
        _next = next;
    }
    return self;
}

- (void)append:(YDDLRUNode *)node
{
    node.next = self.next;
    self.next = node;
}

- (void)insertAtNode:(YDDLRUNode *)node {
    
    self.head = node.head;
    self.next = node;
    node.head = self;
}

- (void)deletedNode
{
    self.head.next = self.next;
}

- (id)copyWithZone:(NSZone *)zone
{
    YDDLRUNode *node = [[YDDLRUNode alloc] init];
    
    
    return node;
}

@end


@interface YDDLRUCache ()


@property (nonatomic, strong) NSMutableDictionary <NSString *, YDDLRUNode*>* mutDic;

@property (nonatomic, copy) NSString *firstCacheId;

@property (nonatomic, copy) NSString *lastCacheId;

@property (nonatomic, assign) NSInteger count;


@end

static YDDLRUCache *_lruCache;

@implementation YDDLRUCache


+ (instancetype)shareLRUCache
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _lruCache = [[YDDLRUCache alloc] init];
    });
    return _lruCache;
}

+ (void)cacheObj:(NSObject *)obj
{
    [[YDDLRUCache shareLRUCache] cacheObj:obj];
}

+ (NSObject *)readCache:(NSString *)cacheId
{
    return [[YDDLRUCache shareLRUCache] readCache:cacheId];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _maxCount = 10;
    }
    return self;
}

- (void)cacheObj:(NSObject *)obj
{
    if (!obj.lruCacheId) {
        return;
    }
    if (self.mutDic[obj.lruCacheId]) {
        YDDLRUNode *node = self.mutDic[obj.lruCacheId];
        
        if ([self.firstCacheId isEqualToString:node.content.lruCacheId]) {
            return;
        }
        
        if ([self.lastCacheId isEqualToString:node.content.lruCacheId]) {
            self.lastCacheId = node.head.content.lruCacheId;
        }
        
        [node deletedNode];
        
        YDDLRUNode *firstNode = self.mutDic[self.firstCacheId];
        
        node.head = nil;
        node.next = firstNode;
        firstNode.head = node;
        self.firstCacheId = node.lruCacheId;
    } else {
        YDDLRUNode *node = [[YDDLRUNode alloc] init];
        node.content = obj;
        if (self.firstCacheId) {
            YDDLRUNode *firstNode = self.mutDic[self.firstCacheId];
            node.next = firstNode;
            firstNode.head = node;
        }
        self.firstCacheId = node.content.lruCacheId;
        
        
        
        self.mutDic[obj.lruCacheId] = node;
        self.count++;
        
        if (!self.lastCacheId) {
            self.lastCacheId = node.content.lruCacheId;
        }
        
        if (self.count > self.maxCount) {
            
            if (self.lastCacheId) {
                YDDLRUNode *lastNode = self.mutDic[self.lastCacheId];
                lastNode.head.next = nil;
                [self.mutDic removeObjectForKey:self.lastCacheId];
                self.lastCacheId =lastNode.head.lruCacheId;
                self.count--;
            }
        }
    }
}

- (NSObject *)readCache:(NSString *)cacheId
{
    
    if (!self.mutDic[cacheId]) {
        return nil;
    }
    YDDLRUNode *node = self.mutDic[cacheId];
    
    if (self.firstCacheId != cacheId) {
        [node deletedNode];
        node.head = nil;
        YDDLRUNode *firstNode = self.mutDic[self.firstCacheId];
        node.next = firstNode;
        firstNode.head = node;
        self.firstCacheId = node.content.lruCacheId;
    }
    return node.content;
}


- (NSMutableDictionary<NSString *,YDDLRUNode *> *)mutDic
{
    if (!_mutDic) {
        _mutDic = [NSMutableDictionary dictionary];
    }
    return _mutDic;
}


+ (void)debugNode
{
    YDDLRUNode *node = _lruCache.mutDic[_lruCache.firstCacheId];
    while (node) {
        NSLog(@"debug cachedId : %@", node.content.lruCacheId);
        node = node.next;
    }
}

@end
