//
//  WheelUIControl.m
//  Wheel
//
//  Created by William-Weng on 2017/1/8.
//  Copyright © 2017年 William-Weng. All rights reserved.

#import "WheelUIControl.h"

#define HighLightColor 0xBEE8F4

@implementation WheelUIControl {
    CGFloat radiansOnBegin;
}

static float deltaAngle;
static bool isPressed;

#pragma mark - initial

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self defaultProperty];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultProperty];
    }
    return self;
}

#pragma mark - @override drawRect:(CGRect)rect

- (void)drawRect:(CGRect)rect { // @override
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect myFrame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);

    [self cleanObjectForRedraw];
    [self drawBackgroundColor:_backgroundColor];
    [self drawRotaryWheel:rect];
    [self buildButtonData];
    
    UIRectFrame(myFrame);
    CGContextFillRect(context, myFrame);
    UIGraphicsEndImageContext();
}

- (void)drawRotaryWheel:(CGRect)rect {
    
    CGFloat angleSizeForOneButton, offset, iconSize, iconRate;
    CGPoint containerCenter;

    iconRate = _iconRate / 100.0f;
    offset = (rect.size.height > rect.size.width) ? (rect.size.height / 4) : (rect.size.height / 4);
    iconSize = iconRate * offset;
    angleSizeForOneButton = 2 * M_PI / _buttonCount;
    
    _containerView = [[UIView alloc] initWithFrame:rect];
    _containerView.userInteractionEnabled = NO;
    _containerView.backgroundColor = [UIColor clearColor];
    
    containerCenter = [self getCenterWithView:_containerView];
    
    for (int index = 0; index < _buttonCount; index++) {

        UIImageView* baseImageView = [self setBaseImageViewWithIndex:index layerAnchorPoint:CGPointMake(1.0f, 0.5f) layerPosition:containerCenter angleSize:angleSizeForOneButton touch:YES];
        WheelButton* deviceButton = [self setDeviceButtonWithIndex:index frame:CGRectMake(offset, offset, iconSize, iconSize) buttonImage:_noDataImage angleSize:angleSizeForOneButton touch:YES];
        
        [baseImageView addSubview:deviceButton];
        [_containerView addSubview:baseImageView];
    }

    [self addSubview:_containerView];
    [self.delegate wheelDidSelectedValue:_currentIndex];
}

#pragma mark - @override TrackingWithTouch

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {

    CGPoint touchPoint = [touch locationInView:self];
    NSInteger distance = [self calculateDistanceFromCenter:touchPoint];
    float dx = touchPoint.x - _containerView.center.x;
    float dy = touchPoint.y - _containerView.center.y;
    float radius = self.bounds.size.height / 2.0;
    
    isPressed = NO;
    radiansOnBegin = atan2f(_containerView.transform.b, _containerView.transform.a);
    deltaAngle = atan2(dy,dx);
    
    if(distance < radius * 0.7 || distance > radius * 1.2) {
        NSLog(@"ignoring tap (%f,%f)", touchPoint.x, touchPoint.y);
        return NO;
    }
    
    for(WheelButton *button in _buttonArray) {
        button.startTranform = button.transform;
    }
    
    NSLog(@"(%f, %f) ==> %f",dx ,dy, deltaAngle);
    
    _startTransform = _containerView.transform;
    
    UITouch *touchAll = [[event allTouches] anyObject];
    CGPoint touchLocation = [touchAll locationInView:self];
    
    for (WheelButton *view in _buttonArray) {
        
        NSLog(@"%ld ==> [view class = %@],view.x = %f, touch.x = %f",view.tag ,[view class], view.frame.origin.x, touchLocation.x);
        
        CGRect viewRect = [view.superview convertRect:view.frame toView:self];        
        if ([view isKindOfClass:[WheelButton class]] && CGRectContainsPoint(viewRect, touchLocation)) {
            NSLog(@"GOOD ==> %ld", view.tag);
            isPressed = YES;
            _touchedIndex = view.wheelData.indexOfButton;
        }
    }
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event {
    
    CGFloat radians = atan2f(_containerView.transform.b, _containerView.transform.a);
    CGPoint pt = [touch locationInView:self];
    float dx = pt.x  - _containerView.center.x;
    float dy = pt.y  - _containerView.center.y;
    float angle = atan2(dy,dx);
    float angleDifference = deltaAngle - angle;
    
    isPressed = NO;
    _containerView.transform = CGAffineTransformRotate(_startTransform, -angleDifference);
    
    for (WheelButton *button in _buttonArray) {
        button.transform = CGAffineTransformRotate(button.startTranform, angleDifference);
    }
    
    NSLog(@"[Degrees is ==> %f]",  RadiansToDegrees(radians));
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event {

    CGFloat radians = atan2f(_containerView.transform.b, _containerView.transform.a);
    CGFloat undoneRadians = 0.0, rangeMin = 0.0f, rangeMax = 0.0f;
    
    undoneRadians = radians - radiansOnBegin;
    for (WheelButton *button in _buttonArray) {
   
        WheelData* butttonData = button.wheelData;
        rangeMin = butttonData.minValueOfRotateRange;
        rangeMax = butttonData.midValueOfRotateRange;
        
        NSLog(@"[rad %f] ==> (max:%f, min:%f)",RadiansToDegrees(radians), RadiansToDegrees(rangeMax), RadiansToDegrees(rangeMin));
        
        button.backgroundColor = [UIColor clearColor];
        if (radians > rangeMin && radians < rangeMax) {
    
            _currentIndex = butttonData.indexOfButton;
            undoneRadians = radians - butttonData.minValueOfRotateRange;
            
            NSLog(@"[+currentValue] ==> %ld", _currentIndex);
        }
    }
    
    [_buttonArray objectAtIndex:_currentIndex].backgroundColor = _selectedDeviceBackgroundColor;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    
    CGAffineTransform transform = CGAffineTransformRotate(_containerView.transform, -undoneRadians);
    _containerView.transform = transform;
    for (WheelButton *button in _buttonArray) {
        button.transform = CGAffineTransformRotate(button.transform, +undoneRadians);
    }
    
    [UIView commitAnimations];
    
    if (isPressed) { [self.delegate wheelDidTouchedValue:_touchedIndex]; }
    [self.delegate wheelDidSelectedValue:_currentIndex];
    
    isPressed = NO;
}

#pragma mark - default

- (void)defaultProperty { // 初值的設定 ==> default

    _currentIndex = 0;
    _buttonCount = 8;
    _angleFixToZero = 45;
    _iconRate = 40;
    _touchedIndex = -1;
    _fontSize = 14.0f;
    _titleString = @"";
    
    _backgroundColor = [UIColor clearColor];
    _selectedDeviceBackgroundColor = [UIColor clearColor];
    _imageViewArray = [NSMutableArray array];
    _buttonArray = [NSMutableArray array];
    _fontColor = [UIColor blackColor];
    
    _buttonOnImage = [UIImage imageNamed:@"House" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    _buttonOffImage = [UIImage imageNamed:@"Close" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    _noDataImage = [UIImage imageNamed:@"Paste" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    
    self.opaque = NO;
    self.layer.contentsScale = [UIScreen mainScreen].scale;
}

- (void)drawBackgroundColor:(UIColor*)color {

    self.backgroundColor = color;
    self.layer.backgroundColor = color.CGColor;
    [color set];
}

- (void)cleanObjectForRedraw {
    
    [_containerView removeFromSuperview];
    _buttonArray = [NSMutableArray array];
}

#pragma mark - set view

- (UIImageView*)setBaseImageViewWithIndex:(NSInteger)index layerAnchorPoint :(CGPoint)anchorPoint layerPosition:(CGPoint)position angleSize:(CGFloat)angleSize touch:(BOOL)touch {

    UIImageView* imageView = [UIImageView new];
    CGFloat angleFixToZero = DegreesToRadians(_angleFixToZero);
    imageView.tag = index;
    imageView.layer.anchorPoint = anchorPoint;
    imageView.layer.position = position;
    imageView.transform = CGAffineTransformMakeRotation(1.0f * (angleFixToZero + angleSize * index));
    imageView.userInteractionEnabled = touch;
    
    [_imageViewArray addObject:imageView];
    
    return imageView;
}

- (WheelButton*)setDeviceButtonWithIndex:(NSInteger)index frame:(CGRect)rect buttonImage:(UIImage*)image angleSize:(CGFloat)angleSize touch:(BOOL)touch {
    
    WheelButton* button = [[WheelButton alloc] initWithFrame:rect];
    CGFloat angleFixToZero = DegreesToRadians(_angleFixToZero);
    [button setImage:image forState:UIControlStateNormal];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:_fontSize]];
    [button setTitleColor:_fontColor forState:UIControlStateNormal];
    [button setTitle:_titleString forState:UIControlStateNormal];
    
    button.transform = CGAffineTransformMakeRotation(-1.0f * (angleFixToZero + angleSize * index));
    [button.layer setCornerRadius:button.bounds.size.height / 2.0f];

    if (index == 0) { button.backgroundColor = _selectedDeviceBackgroundColor; }
    
    [_buttonArray addObject:button];
    
    NSLog(@"[size ==> %f]", rect.size.height);
    
    return button;
}

#pragma mark - build button data

- (void)buildButtonData {
    
    BOOL isEven = (_buttonCount % 2 == 0) ? YES : NO;
    (isEven) ? [self buildButtonDataEven] : [self buildButtonDataOdd];
}

- (void)buildButtonDataOdd {
    
    CGFloat angleSizeForOneButton = M_PI * 2 / _buttonCount;
    CGFloat middle = [self fixMiddleAngleToOrigin];
    
    for (int index = 0; index < _buttonCount; index++) {
        WheelData* wheelData = [WheelData new];

        wheelData.midValueOfRotateRange = middle;
        wheelData.minValueOfRotateRange = middle - (angleSizeForOneButton / 2.0);
        wheelData.maxValueOfRotateRange = middle + (angleSizeForOneButton / 2.0);
        wheelData.indexOfButton = index;
        
        middle -= angleSizeForOneButton;
        
        if (middle < - M_PI) {
            wheelData.midValueOfRotateRange += 2 * M_PI;
            wheelData.minValueOfRotateRange += 2 * M_PI;
            wheelData.maxValueOfRotateRange += 2 * M_PI;
        }
        
        if (wheelData.maxValueOfRotateRange >= M_PI) {
            wheelData.minValueOfRotateRange -= 2* M_PI;
            wheelData.midValueOfRotateRange -= 2* M_PI;
            wheelData.maxValueOfRotateRange -= 2* M_PI;
        }

        [_buttonArray[index] setWheelData:wheelData];
        
        NSLog(@"[buildButtonDataOdd] ==> %@", wheelData);
    }
}

- (void)buildButtonDataEven {
    
    CGFloat angleSizeForOneButton = M_PI * 2 / _buttonCount;
    CGFloat middle = [self fixMiddleAngleToOrigin];
    
    for (int index = 0; index < _buttonCount; index++) {
        
        WheelData* wheelData = [[WheelData alloc] init];
        
        wheelData.midValueOfRotateRange = middle;
        wheelData.minValueOfRotateRange = middle - (angleSizeForOneButton / 2.0f);
        wheelData.maxValueOfRotateRange = middle + (angleSizeForOneButton / 2.0f);
        wheelData.indexOfButton = index;
        
        if ((wheelData.maxValueOfRotateRange - angleSizeForOneButton) < - M_PI) { // max > min
            wheelData.midValueOfRotateRange += 2 * M_PI;
            wheelData.minValueOfRotateRange += 2 * M_PI;
            wheelData.maxValueOfRotateRange += 2 * M_PI;
        }
        
        middle -= angleSizeForOneButton;
        [_buttonArray[index] setWheelData:wheelData];
        
        NSLog(@"[buildButtonDataEven] ==> %@", wheelData);
    }
}

#pragma mark - tools

- (CGPoint)getCenterWithView:(UIView*)view {

    return CGPointMake(view.bounds.size.width / 2.0 - view.frame.origin.x, view.bounds.size.height / 2.0 - view.frame.origin.y);
}

- (CGFloat)calculateDistanceFromCenter:(CGPoint)point {

    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    float dx = point.x - center.x;
    float dy = point.y - center.y;

    return sqrt(dx*dx + dy*dy);
}

- (CGFloat)fixMiddleAngleToOrigin {

    return (M_PI / _buttonCount);
}

@end
