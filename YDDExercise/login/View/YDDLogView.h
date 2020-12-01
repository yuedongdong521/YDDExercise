//
//  YDDLogView.h
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LogViewType_Login = 0,
    LogViewType_Logon,
} LogViewType;

@interface YDDLogView : UIView

@property (nonatomic, strong) YDDUserBaseInfoModel *infoModel;

@property (nonatomic, copy) void(^loginBlock)(YDDUserBaseInfoModel *userInfo);

@property (nonatomic, copy) void(^logonBlock)(void);

- (instancetype)initWithViewType:(LogViewType)type;


@end

NS_ASSUME_NONNULL_END
