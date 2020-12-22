//
//  YDDCoordinateSystemView.h
//  YDDExercise
//
//  Created by ydd on 2020/12/8.
//  Copyright © 2020 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN




@interface YDDCoordinateSystemView : UIView


@property (nonatomic, assign) CGFloat arrowSize;

@property (nonatomic, strong) NSArray <NSNumber *>*xPoints;

@property (nonatomic, strong) NSArray <NSNumber *>*yPoints;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

- (instancetype)initWithArrowSize:(CGFloat)arrowSize NS_DESIGNATED_INITIALIZER;

- (void)updateXAxisValues:(NSArray <NSNumber *>*)xValues yAxisValues:(NSArray <NSNumber *>*)yValues;

- (void)updateContentValues:(NSArray <NSNumber *>*)values;


@end

NS_ASSUME_NONNULL_END
