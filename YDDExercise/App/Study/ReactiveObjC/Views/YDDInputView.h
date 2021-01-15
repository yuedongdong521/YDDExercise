//
//  YDDInputView.h
//  YDDExercise
//
//  Created by ydd on 2021/1/7.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YDDInputViewDelegate <NSObject>

@optional

- (BOOL)filterText:(NSString *)text;

- (void)updateInputViewHeight:(CGFloat)height;

@end

@interface YDDInputView : UIView

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, assign) UIEdgeInsets edgeInset;

@property (nonatomic, assign) NSInteger maxNum;

@property (nonatomic, assign) NSInteger maxLine;

@property (nonatomic, weak) id<YDDInputViewDelegate> delegate;



- (instancetype)initWithHeight:(CGFloat)height;

- (void)updateLayout;

- (void)updateHeightWithText:(NSString *)text;

@end


NS_ASSUME_NONNULL_END
