//
//  YDDGradientLabel.m
//  YDDExercise
//
//  Created by ydd on 2021/1/22.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDGradientLabel.h"

@interface YDDGradientLabel ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) UILabel *label;

@end

@implementation YDDGradientLabel

@synthesize
font = _font,
alignment = _alignment,
attributedString = _attributedString,
startPoint = _startPoint,
endPoint = _endPoint,
adjustsFontSizeToFitWidth = _adjustsFontSizeToFitWidth;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.gradientLayer];
        self.gradientLayer.mask = self.label.layer;
        
        self.direction = YDDGradLabelDirection_leftToRight;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gradientLayer.frame = self.bounds;
    self.label.frame = self.gradientLayer.bounds;
}

- (void)setDirection:(YDDGradLabelDirection)direction
{
    _direction = direction;
    
    switch (_direction) {
        case YDDGradLabelDirection_leftToRight:
            self.startPoint = CGPointMake(0, 0.5);
            self.endPoint = CGPointMake(1, 0.5);
            break;
        case YDDGradLabelDirection_rightToLeft:
            self.startPoint = CGPointMake(1, 0.5);
            self.endPoint = CGPointMake(0, 0.5);
            break;
        case YDDGradLabelDirection_topToBottom:
            self.startPoint = CGPointMake(0.5, 0);
            self.endPoint = CGPointMake(0.5, 1);
            break;
        case YDDGradLabelDirection_bottomToTop:
            self.startPoint = CGPointMake(0.5, 1);
            self.endPoint = CGPointMake(0.5, 0);
            break;
        default:
            
            break;
    }
}

- (void)setText:(NSString *)text
{
    _text = text;
    _label.text = text;
}

- (void)setLocations:(NSArray<NSNumber *> *)locations
{
    _locations = locations;
    _gradientLayer.locations = locations;
}

- (void)setTextColors:(NSArray<UIColor *> *)textColors
{
    _textColors = textColors;
    NSMutableArray *mutAtt = [NSMutableArray array];
    [_textColors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [mutAtt addObject:(id)obj.CGColor];
    }];
    
    _gradientLayer.colors = mutAtt;
    
    NSInteger count = mutAtt.count;
    if (count < 1) {
        return;
    }
    
    if (count == 1) {
        self.locations = @[@(1)];
        return;
    }
    
    if (!self.locations || self.locations.count != count) {
        NSMutableArray *locations = [NSMutableArray array];
        CGFloat l = 1.0 / (count - 1);
        for (NSInteger i = 0; i < count; i++) {
            [locations addObject:@(l * i)];
        }
        self.locations = locations;
    }
}

- (CGSize)textSizeWithMaxSize:(CGSize)maxSize
{
    CGSize size = [self.attributedString boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}


- (void)setFont:(UIFont *)font
{
    _font = font;
    _label.font = font;
}

- (UIFont *)font
{
    return self.label.font;
}

- (void)setAlignment:(NSTextAlignment)alignment
{
    _alignment = alignment;
    _label.textAlignment = alignment;
}

- (NSTextAlignment)alignment
{
    return self.label.textAlignment;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    _attributedString = attributedString;
    _label.attributedText = attributedString;
}

- (NSAttributedString *)attributedString
{
    return self.label.attributedText;
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth
{
    _adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
    self.label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
}

- (BOOL)adjustsFontSizeToFitWidth
{
    return self.label.adjustsFontSizeToFitWidth;
}

- (void)setStartPoint:(CGPoint)startPoint
{
    _startPoint = startPoint;
    self.gradientLayer.startPoint = startPoint;
}

- (CGPoint)startPoint
{
    return self.gradientLayer.startPoint;
}

- (void)setEndPoint:(CGPoint)endPoint
{
    _endPoint = endPoint;
    self.gradientLayer.endPoint = endPoint;
}

- (CGPoint)endPoint
{
    return self.gradientLayer.endPoint;
}


- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
    }
    return _label;
}

- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer) {
        _gradientLayer = [[CAGradientLayer alloc] init];
    }
    return _gradientLayer;
}




@end
