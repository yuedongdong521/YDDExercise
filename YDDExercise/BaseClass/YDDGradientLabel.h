//
//  YDDGradientLabel.h
//  YDDExercise
//
//  Created by ydd on 2021/1/22.
//  Copyright © 2021 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YDDGradLabelDirection) {
    YDDGradLabelDirection_unknown = 0,
    YDDGradLabelDirection_leftToRight,
    YDDGradLabelDirection_rightToLeft,
    YDDGradLabelDirection_topToBottom,
    YDDGradLabelDirection_bottomToTop,
};

NS_ASSUME_NONNULL_BEGIN

@interface YDDGradientLabel : UIView

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, assign) NSTextAlignment alignment;

@property (nonatomic, copy) NSAttributedString *attributedString;

@property (nonatomic, copy) NSArray <UIColor *>* textColors;

@property (nonatomic, copy) NSArray <NSNumber *>* locations;

@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, assign) CGPoint endPoint;

/// default: YDDGradLabelDirection_leftToRight
@property (nonatomic, assign) YDDGradLabelDirection direction;

@property (nonatomic, assign) BOOL adjustsFontSizeToFitWidth;

- (CGSize)textSizeWithMaxSize:(CGSize)maxSize;


@end

NS_ASSUME_NONNULL_END
