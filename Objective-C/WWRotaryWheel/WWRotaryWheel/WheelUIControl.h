//
//  WheelUIControl.h
//  Wheel
//
//  Created by William-Weng on 2017/1/8.
//  Copyright © 2017年 William-Weng. All rights reserved.
//
//  http://wonderffee.github.io/blog/2013/10/13/understand-anchorpoint-and-position/
//  https://www.raywenderlich.com/9864/how-to-create-a-rotating-wheel-control-with-uikit
//  https://github.com/funkyboy/How-To-Create-a-Rotating-Wheel-Control-with-UIKit
//  https://cocoapods.org/pods/HCRotaryWheel
//  http://www.jianshu.com/p/48d5433fc954
//  https://zsisme.gitbooks.io/ios-/content/chapter3/anchor.html

#import <UIKit/UIKit.h>
#import "WheelButton.h"
#import "WheelData.h"
#import "WheelProtocol.h"
#import "NSObject+William.h"
#import "UIColor+William.h"

IB_DESIGNABLE

@interface WheelUIControl : UIControl

@property (nonatomic) IBInspectable CGFloat angleFixToZero;
@property (nonatomic) IBInspectable CGFloat fontSize;
@property (nonatomic) IBInspectable NSInteger buttonCount;
@property (nonatomic) IBInspectable NSInteger iconRate;
@property (nonatomic) IBInspectable NSString* titleString;
@property (nonatomic, strong) IBInspectable UIColor* backgroundColor;
@property (nonatomic) IBInspectable UIColor* selectedDeviceBackgroundColor;
@property (nonatomic) IBInspectable UIColor* fontColor;
@property (nonatomic) IBInspectable UIImage* buttonOnImage;
@property (nonatomic) IBInspectable UIImage* buttonOffImage;
@property (nonatomic) IBInspectable UIImage* noDataImage;

@property (nonatomic, weak) id <WheelProtocol> delegate;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic) CGAffineTransform startTransform;

@property (nonatomic) UIImageView* defaultImageView;
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, strong) NSMutableArray<WheelButton*> *buttonArray;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSInteger touchedIndex;

@end
