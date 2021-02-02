//
//  YDDVideoCommentInputView.h
//  YDDExercise
//
//  Created by ydd on 2020/6/22.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPStickerKeyboard.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDDVideoCommentInputView : UIView

@property (nonatomic, assign) CGFloat            keyBoardHeight;
@property (nonatomic, assign) CGFloat            bottomDistance;

@property (nonatomic, assign, readonly)   BOOL isShowKeyBoard;

/// 是否输入内容
@property (nonatomic, assign, readonly)   BOOL isHaveText;

@property (nonatomic, copy) void(^checkUserLevelBlock)(void);

@property (nonatomic, copy) void(^sendTextBlock)(NSString *text);

@property (nonatomic, copy) void(^keyBoardChangeBlock)(CGFloat bottom, CGFloat height, CGFloat duration);


- (instancetype)initWithInputViewHeight:(CGFloat)height;

/// 设置占位文字
- (void)setupKeyBoardPlaceholderContent:(NSString *)text;
/// 清除文字,并回到初始状态
- (void)clearTextAndReturnInitState;
/// 弹出键盘
- (void)showKeyBoard;
/// 隐藏键盘
- (void)hideKeyBoard;
/// 更新用户等级/绑卡状态
- (void)uploadKeyBoardStatus;

- (void)uploadSendButtonStatus:(BOOL)enabled;




@end

NS_ASSUME_NONNULL_END
