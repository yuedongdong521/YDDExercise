//
//  AppDelegate.m
//  YDDExercise
//
//  Created by ydd on 2019/7/17.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "AppDelegate.h"
#import "YDDPhotosViewController.h"
#import "CocoaDebugTool.h"
#import <KTVHTTPCache/KTVHTTPCache.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"didFinishLaunchingWithOptions");
    // 禁用多点触控
    [[UIButton appearance] setExclusiveTouch:YES];
    
    [self configKTVHTTPCache];
    
    [YDDAppManager checkLoginState];
    
    [CocoaDebugTool logWithString:@"Custom Messages...."];
    [CocoaDebugTool logWithString:@"Custom Messages...." color:[UIColor redColor]];
    
    return YES;
}


- (void)configKTVHTTPCache
{
    NSError *error;
    [KTVHTTPCache proxyStart:&error];
    [KTVHTTPCache cacheSetMaxCacheLength:1024 * 1024 * 100];
    KTVHCDataCacheItem *item = [KTVHTTPCache cacheCacheItemWithURL:[NSURL URLWithString:@"https://video.17kuxiu.com/social_dynamic/video/1267508_1596780091.mp4"]];
    NSLog(@"cache path: %@", item.URL);
    
    
    if (error) {
        NSLog(@"Proxy Start Failure, %@", error);
    } else {
        NSLog(@"Proxy Start Success");
    }
    [KTVHTTPCache encodeSetURLConverter:^NSURL *(NSURL *URL) {
        NSLog(@"URL Filter reviced URL : %@", URL);
        return URL;
    }];
    [KTVHTTPCache downloadSetUnacceptableContentTypeDisposer:^BOOL(NSURL *URL, NSString *contentType) {
        NSLog(@"Unsupport Content-Type Filter reviced URL : %@, %@", URL, contentType);
        return NO;
    }];
    NSArray *arr = [KTVHTTPCache downloadAcceptableContentTypes];
    NSLog(@"arr : %@", arr);
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
