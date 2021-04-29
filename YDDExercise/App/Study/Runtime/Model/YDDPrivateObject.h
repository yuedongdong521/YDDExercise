//
//  YDDPrivateObject.h
//  YDDExercise
//
//  Created by ydd on 2021/4/13.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDDPrivateObject : NSObject

@property (nonatomic, strong, readonly) NSString *name;

- (void)changeName:(NSString *)name;

- (NSString*)readName;


@end

NS_ASSUME_NONNULL_END
