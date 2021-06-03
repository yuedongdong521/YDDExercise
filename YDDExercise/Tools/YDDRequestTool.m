//
//  YDDRequestTool.m
//  YDDExercise
//
//  Created by ydd on 2021/5/14.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDRequestTool.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface YDDRequestTool ()

@property (nonatomic, strong) RACCommand *rac_command;

@property (nonatomic, strong) NSMutableURLRequest *request;

@property (nonatomic, weak) RACDisposable *disposable;

@end

@implementation YDDRequestTool

- (instancetype)init
{
    self = [super init];
    if (self) {
        _timeOut = 60;
        _method = YDDRequestMethod_GET;
        
        @weakify(self);
        [self.rac_command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if (self.success) {
                self.success(x);
            }
        }];
        
        [[[self.rac_command.executing skip:1] take:1] subscribeNext:^(NSNumber * _Nullable x) {
            @strongify(self);
            NSLog(@"%@ 请求 ： %@", self.requestUrl, [x intValue] == 1 ? @"开始" : @"结束");
        }];
        
        [self.rac_command.errors subscribeNext:^(NSError * _Nullable x) {
            @strongify(self);
            if (self.failuer) {
                self.failuer(x);
            }
        }];
    }
    return self;
}

- (void)start
{
    [self.rac_command execute:nil];
}

- (void)cancel
{
    [_disposable dispose];
}

- (void)createRequest
{
    if (!_requestUrl) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:_requestUrl];
    if (!url) {
        return;
    }
    _request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.timeOut];
    
    [_headDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [_request setValue:obj forHTTPHeaderField:key];
    }];
    if (_method == YDDRequestMethod_GET) {
        _request.HTTPMethod = @"GET";
    } else {
        _request.HTTPMethod = @"POST";
        
        NSMutableString *bodyStr = [NSMutableString string];
        [_bodyDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            if (bodyStr.length > 0) {
                [bodyStr appendString:[NSString stringWithFormat:@"&%@=%@", key, obj]];
            } else {
                [bodyStr appendString:[NSString stringWithFormat:@"%@=%@", key, obj]];
            }
        }];
        if (bodyStr.length > 0) {
            NSData *data = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
            if (data) {
                [_request setHTTPBody:data];
            }
        }
    }
}

- (RACCommand *)rac_command
{
    if (!_rac_command) {
        @weakify(self);
        _rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [self createRequest];
                if (!self.request) {
                    [subscriber sendError:[NSError errorWithDomain:@"url is null" code:-1 userInfo:nil]];
                    return nil;
                }
                NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                NSURLSessionDataTask *task = [session dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (!error || error.code == 0) {
                        if (data) {
                            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                            if (!error || error.code == 0) {
                                [subscriber sendNext:result];
                                [subscriber sendCompleted];
                                return;
                            }
                        }
                    }
                    [subscriber sendError:error];
                }];
                [task resume];
                self.disposable = [RACDisposable disposableWithBlock:^{
                    [task cancel];
                }];
                return self.disposable;
            }];
        }];
    }
    return _rac_command;
}



@end
