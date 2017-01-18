//
//  WheelButton.m
//  Wheel
//
//  Created by William-Weng on 2017/1/8.
//  Copyright © 2017年 William-Weng. All rights reserved.
//
//  http://blog.csdn.net/lqq200912408/article/details/51323336

#import "WheelButton.h"

@implementation WheelButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect { // @override
    
    CGFloat inteval = CGRectGetHeight(contentRect);
    CGFloat imageH = CGRectGetHeight(contentRect) - contentRect.size.height * inteval;
    CGRect rect = CGRectMake(inteval * 0.8f, inteval / 1.8f, CGRectGetWidth(contentRect) - imageH - 2 * inteval, CGRectGetHeight(contentRect) - 2 * inteval);
    NSLog(@"[contentRect ==> %f]", contentRect.size.height);

    return rect;
}

// - (CGRect)imageRectForContentRect:(CGRect)contentRect { }

@end
