//
//  YDDCoordinateSystemView.m
//  YDDExercise
//
//  Created by ydd on 2020/12/8.
//  Copyright © 2020 ydd. All rights reserved.
//

#import "YDDCoordinateSystemView.h"

@interface YDDGridView : UIView

@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger column;

@property (nonatomic, assign) NSInteger scale;

@end

@implementation YDDGridView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _lineColor = [UIColor grayColor];
        _row = 0;
        _column = 0;
        _scale = 0;
    }
    return self;
}

- (void)updateRow:(NSInteger)row
           column:(NSInteger)column
            scale:(NSInteger)scale
{
    _row = row;
    _column = column;
    _scale = scale;
    [self setNeedsDisplay];
}

- (UIBezierPath *)createGridPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if (_row == 0 || _column == 0) {
        return path;
    }
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat spaceX = width / _column;
    CGFloat spaceY = height / _row;
    
    CGFloat x = 0;
    CGFloat y = height;
    
    while (x + spaceX <= width) {
        if (_scale > 0) {
            CGFloat scaleSpace = spaceX / _scale;
            CGFloat scaleX = 0;
    
            while (scaleX + scaleSpace < spaceX) {
                CGFloat px = x + scaleX + scaleSpace;
                
                UIBezierPath *scaleXPath = [self createStartPoint:CGPointMake(px, 0) endPoint:CGPointMake(px, height)];
                [path appendPath:scaleXPath];
               
                scaleX += scaleSpace;
            }
            
            UIBezierPath *scaleXPath = [self createStartPoint:CGPointMake(x + spaceX, 0) endPoint:CGPointMake(x + spaceX, height)];
            [path appendPath:scaleXPath];
            
            
        } else {
        
            UIBezierPath *scaleXPath = [self createStartPoint:CGPointMake(x + spaceX, 0) endPoint:CGPointMake(x + spaceX, height)];
            [path appendPath:scaleXPath];
            
        }
        x += spaceX;
    }
    
    while (y - spaceY >= 0) {
        if (_scale > 0) {
            
            CGFloat scaleSpace = spaceY / _scale;
            CGFloat scaleY = 0;
    
            while (scaleY <= spaceY) {
                CGFloat py = y - scaleY;
                
                UIBezierPath *scaleYPath = [self createStartPoint:CGPointMake(0, py) endPoint:CGPointMake(width, py)];
                [path appendPath:scaleYPath];
                scaleY += scaleSpace;
            }
            
            UIBezierPath *scaleYPath = [self createStartPoint:CGPointMake(0, y - spaceY) endPoint:CGPointMake(width, y - spaceY)];
            [path appendPath:scaleYPath];
            
            
        } else {
            
            UIBezierPath *scaleYPath = [self createStartPoint:CGPointMake(0, y - spaceY) endPoint:CGPointMake(width, y - spaceY)];
            [path appendPath:scaleYPath];
        }
        y -= spaceY;
    }
    
    /**
     绘制虚线
     dash 第一个值是虚线中实线长度，第二个参数是虚线中空格长度
     count
     */
    CGFloat dash[] = {20, 5};
    [path setLineDash:dash count:2 phase:1];
    return path;
}

- (UIBezierPath *)createStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    return path;
}


- (void)drawRect:(CGRect)rect
{
    [_lineColor setStroke];
    [[self createGridPath] stroke];
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    
    [self setNeedsDisplay];
}




@end

@interface YDDAxisView : UIView

@property (nonatomic, assign) CGFloat arrowSize;


@end



@implementation YDDAxisView


- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [[UIColor blackColor] setStroke];
    [[UIColor blackColor] setFill];
    
    UIBezierPath *path = [self createCoordinateSystemWithRect:rect];
    
    [path stroke];
}

- (UIBezierPath *)createCoordinateSystemWithRect:(CGRect)rect
{
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    /// y轴箭头
    UIBezierPath *path1 = [[UIBezierPath alloc] init];
    [path1 moveToPoint:CGPointMake(self.arrowSize, 0)];
    [path1 addLineToPoint:CGPointMake(0, self.arrowSize)];
    [path1 addLineToPoint:CGPointMake(self.arrowSize * 2, self.arrowSize)];
    [path1 closePath];
    
    [path1 fill];
    
    [path appendPath:path1];
    
    UIBezierPath *axisPath = [[UIBezierPath alloc] init];
    [axisPath moveToPoint:CGPointMake(self.arrowSize, self.arrowSize)];
    [axisPath addLineToPoint:CGPointMake(self.arrowSize, height - self.arrowSize)];
    [axisPath addLineToPoint:CGPointMake(width - self.arrowSize, height - self.arrowSize)];
    [path appendPath:axisPath];
    
    /// x轴箭头
    UIBezierPath *path2 = [[UIBezierPath alloc] init];
    [path2 moveToPoint:CGPointMake(width, height - self.arrowSize)];
    [path2 addLineToPoint:CGPointMake(width - self.arrowSize, height - self.arrowSize * 2)];
    [path2 addLineToPoint:CGPointMake(width - self.arrowSize, height)];
    [path2 closePath];
    [path2 fill];
    
    [path appendPath:path2];
    
    return path;
}

@end

@interface YDDCoordContentView : UIView

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation YDDCoordContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.shapeLayer];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.shapeLayer.frame = self.bounds;
}

- (CAShapeLayer *)shapeLayer
{
    if (!_shapeLayer) {
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.strokeColor = [UIColor greenColor].CGColor;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _shapeLayer;
}

- (void)updateWithPath:(CGPathRef)path
{
    self.shapeLayer.path = path;
    self.shapeLayer.strokeStart = 0;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.duration = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.shapeLayer addAnimation:animation forKey:@"animationKey"];
}

@end

@interface YDDCoordinateSystemView ()

/// 坐标系图层
@property (nonatomic, strong) UIView *coordinateSystemView;

/// 展示层
@property (nonatomic, strong) YDDCoordContentView *contentView;

/// 坐标轴图层
@property (nonatomic, strong) YDDAxisView *axisView;
/// 网格图层
@property (nonatomic, strong) YDDGridView *gridView;

@property (nonatomic, strong) NSArray <UILabel *>*xTitles;

@property (nonatomic, strong) NSArray <UILabel *>*yTitles;

@property (nonatomic, assign) CGFloat maxX;

@property (nonatomic, assign) CGFloat minX;

@property (nonatomic, assign) CGFloat maxY;

@property (nonatomic, assign) CGFloat minY;


@end

const NSInteger XTitleHeight = 25;
const NSInteger YTitleWidth = 55;

@implementation YDDCoordinateSystemView


- (instancetype)initWithArrowSize:(CGFloat)arrowSize
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.coordinateSystemView];
        self.axisView.arrowSize = arrowSize;
        
        
        [self.coordinateSystemView addSubview:self.gridView];
        [self.coordinateSystemView addSubview:self.contentView];
        [self.coordinateSystemView addSubview:self.axisView];
        
        
        [self.coordinateSystemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(XTitleHeight, YTitleWidth, XTitleHeight, YTitleWidth));
        }];
        
        [self.gridView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(arrowSize, arrowSize, arrowSize, arrowSize));
        }];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(arrowSize, arrowSize, arrowSize, arrowSize));
        }];
        
        [self.axisView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)updateXAxisValues:(NSArray <NSNumber *>*)xValues yAxisValues:(NSArray <NSNumber *>*)yValues
{
    if (!xValues || xValues.count <= 1) {
        return;
    }
    
    if (!yValues || yValues.count <= 1) {
        return;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self.xTitles enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [self.yTitles enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    NSMutableArray <UILabel *>* xMutArr = [NSMutableArray array];
    [xValues enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [self createTitleLabel:obj alignment:NSTextAlignmentLeft];
        [self addSubview:label];
        [xMutArr addObject:label];
        
    }];
    
    self.xTitles = xMutArr;
    
    NSMutableArray <UILabel *>* yMutArr = [NSMutableArray array];
    
    [yValues enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [self createTitleLabel:obj alignment:NSTextAlignmentRight];
        [self addSubview:label];
        [yMutArr addObject:label];
    }];
    
    self.yTitles = yMutArr;
    
    CGFloat space = 5;
    CGFloat xWidth = self.axisView.frame.size.width / (xValues.count - 1);
    CGFloat yHeight = self.axisView.frame.size.height / (yValues.count - 1);
    
    [self.gridView updateRow:yValues.count - 1 column:xValues.count - 1 scale:1];
    
    CGFloat arrowSize = self.axisView.arrowSize;
    

    [self.xTitles mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:xWidth leadSpacing:YTitleWidth tailSpacing:(YTitleWidth - xWidth)];
    
    [self.xTitles mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coordinateSystemView.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(XTitleHeight - 5);
    }];
    
    [self.yTitles mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:20 leadSpacing:XTitleHeight tailSpacing:XTitleHeight];
    
    [self.yTitles mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.coordinateSystemView.mas_left).mas_offset(-5);
        make.width.mas_equalTo(YTitleWidth - 5);
    }];
    
    _maxX = xValues.lastObject.floatValue;
    _minX = xValues.firstObject.floatValue;
    
    _maxY = yValues.lastObject.floatValue;
    _minY = yValues.firstObject.floatValue;
    
}

- (void)updateContentValues:(NSArray <NSNumber *>*)values
{
    if (!values || values.count == 0) {
        return;
    }
    
    CGFloat xSection = _maxX - _minX;
    CGFloat ySection = _maxY - _minY;
    
    if (xSection == 0 || ySection == 0) {
        return;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CGFloat width = self.contentView.frame.size.width;
    CGFloat height = self.contentView.frame.size.height;
    

    CGFloat xSpace = width / self.gridView.row;
    CGFloat ySpace = width / self.gridView.column;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [values enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat y = height - (obj.floatValue - _minY) / ySection * height ;
        CGFloat x = idx * xSpace;
        
        CGPoint p = CGPointMake(x, y);
        if (idx == 0) {
            [path moveToPoint:p];
        } else {
            [path addLineToPoint:p];
        }
            
    }];
    
    [self.contentView updateWithPath:path.CGPath];
    
    
}

- (UILabel *)createTitleLabel:(NSNumber *)num alignment:(NSTextAlignment)alignment
{
    UILabel *label = [[UILabel alloc] init];
    label.font = kFontPFMedium(12);
    label.textAlignment = alignment;
    YDDNumber number = [NSString ydd_maxFourNum:[num integerValue]];
    label.text = [NSString stringWithFormat:@"%@%@", number.value, number.unit] ;
    label.backgroundColor = [UIColor greenColor];
    return label;
}

- (UIView *)coordinateSystemView
{
    if (!_coordinateSystemView) {
        _coordinateSystemView = [[UIView alloc] init];
    }
    return _coordinateSystemView;
}

- (YDDCoordContentView *)contentView
{
    if (!_contentView) {
        _contentView = [[YDDCoordContentView alloc] init];
    }
    return _contentView;
}

- (YDDAxisView *)axisView
{
    if (!_axisView) {
        _axisView = [[YDDAxisView alloc] init];
        _axisView.backgroundColor = [UIColor clearColor];
    }
    return _axisView;
}

- (YDDGridView *)gridView
{
    if (!_gridView) {
        _gridView = [[YDDGridView alloc] init];
        _gridView.backgroundColor = [UIColor clearColor];
    }
    return _gridView;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.



@end
