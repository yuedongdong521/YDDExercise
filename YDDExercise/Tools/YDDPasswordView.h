//
//  YDDPasswordView.h
//  YDDExercise
//
//  Created by ydd on 2021/1/7.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDDPasswordView : UIView

@property (nonatomic, strong, readonly) NSString *password;

@property (nonatomic, copy) void(^passwordChanged)(NSString *password);


- (instancetype)initWithLenght:(NSInteger)lenght;

- (void)clearPassword;

- (CGSize)viewSize;


- (void)viewDidAppear;

@end

NS_ASSUME_NONNULL_END
