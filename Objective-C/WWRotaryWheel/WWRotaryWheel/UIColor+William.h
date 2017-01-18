//
//  UIColor+William.h
//  Wheel
//
//  Created by engineer on 2017/1/13.
//  Copyright © 2017年 William-Weng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (William)

+ (UIColor*)getUIColorFromHex:(int)rgbValue;
+ (UIColor*)getUIColorFromHex:(int)rgbValue alpha:(float)alphaValue;

@end
