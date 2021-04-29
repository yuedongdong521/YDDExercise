//
//  YDDPrivateObject.m
//  YDDExercise
//
//  Created by ydd on 2021/4/13.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDPrivateObject.h"

@interface YDDPrivateObject ()


@property (nonatomic, strong, readwrite) NSString *name;

@end


@implementation YDDPrivateObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"对外只读，对内可写";
    }
    return self;
}

- (void)changeName:(NSString *)name
{
    self->_name = name;
}

- (NSString*)readName
{
    return self.name;
}

- (void)setName:(NSString *)name
{
    _name = name;
    
    NSLog(@"私有属性被修改 : %@", name);
}


@end
