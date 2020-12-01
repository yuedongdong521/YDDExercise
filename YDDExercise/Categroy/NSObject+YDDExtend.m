//
//  NSObject+YDDExtend.m
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "NSObject+YDDExtend.h"
#import <objc/runtime.h>
@implementation NSObject (YDDExtend)



+(NSArray<NSString*>*)ydd_GetAllProperty:(id)object
{
    u_int count;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    NSMutableArray *propertyArr = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        const char* propertyNameChar = property_getName(propertyList[i]);
        NSString *propertyName = [NSString stringWithUTF8String:propertyNameChar];
        [propertyArr addObject:propertyName];
    }
    free(propertyList);
    return propertyArr;
}

+ (void)ydd_GoThroughAllProperty:(id)object
                   propertyBlock:(void(^)(NSString *propertyName))propertyBlcok {
    u_int count;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    for (int i = 0; i < count; i++) {
        const char *propertyChar = property_getName(propertyList[i]);
        NSString *propertyName = [NSString stringWithUTF8String:propertyChar];
        if (propertyBlcok) {
            propertyBlcok(propertyName);
        }
    }
    free(propertyList);
}

+(id)ydd_readModelForKey:(NSString *)key
{
    id modelId = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (modelId && [modelId isKindOfClass:[NSData class]]) {
        id model = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)modelId];
        if (model && [model isKindOfClass:[self class]]) {
            return model;
        }
    }
    return nil;
}

- (void)ydd_writeModelForKey:(NSString *)key
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    if (data) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
