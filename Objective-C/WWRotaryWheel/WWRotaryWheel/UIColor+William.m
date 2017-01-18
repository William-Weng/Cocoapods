//
//  UIColor+William.m
//  Wheel
//
//  Created by engineer on 2017/1/13.
//  Copyright © 2017年 William-Weng. All rights reserved.
//

#import "UIColor+William.h"

@implementation UIColor (William)

+ (UIColor*)getUIColorFromHex:(int)rgbValue {
    UIColor* color = [self getUIColorFromHex:rgbValue alpha:1.0];
    return color;
}

+ (UIColor*)getUIColorFromHex:(int)rgbValue alpha:(float)alphaValue {
    UIColor* color = [UIColor
                      colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0
                      green:((float)((rgbValue & 0x00FF00) >> 8)) / 255.0
                      blue:((float)((rgbValue & 0x0000FF) >> 0)) / 255.0
                      alpha:alphaValue];
    return color;
}

@end
