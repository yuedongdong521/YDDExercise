//
//  NSObject+YDDExtend.m
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "NSObject+YDDExtend.h"
#import "UIView+YDDExtend.h"
#import <objc/runtime.h>
@implementation NSObject (YDDExtend)

+ (UIViewController *)curTopViewController
{
    UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [self curTopViewControllerWithVC:vc];
}

+ (UIViewController *)curTopViewControllerWithVC:(UIViewController *)vc
{
    if (vc.presentedViewController) {
        [self curTopViewControllerWithVC:[vc presentedViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        [self curTopViewControllerWithVC:[((UITabBarController *)vc) selectedViewController]];
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        [self curTopViewControllerWithVC:[[((UINavigationController *)vc) viewControllers] lastObject]];
    }
    return vc;
}

+ (UIViewController *)curTopViewControllerWithView:(UIView *)view
{
    UIViewController *vc = [view superViewController];
    return [self curTopViewControllerWithVC:vc];
}



+ (NSArray<NSString*>*)ydd_GetAllProperty:(id)object
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
