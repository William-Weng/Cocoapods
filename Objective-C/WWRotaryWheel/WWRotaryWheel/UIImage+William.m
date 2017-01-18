//
//  UIImage+William.m
//  Wheel
//
//  Created by engineer on 2017/1/13.
//  Copyright © 2017年 William-Weng. All rights reserved.
//

#import "UIImage+William.h"

@implementation UIImage (William)

+ (UIImage*)imageNamed:(NSString *)name changeToColor:(UIColor*)color scaledToSize:(CGSize)newSize { // https://goo.gl/CponFx ==> How to change the color of an UIImage
    
    UIImage* image = [UIImage imageNamed:name];
    
    CGRect rect = CGRectMake(0, 0, newSize.width, newSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *flippedImage = [UIImage imageWithCGImage:img.CGImage scale:2.0 orientation: UIImageOrientationDownMirrored];
    
    return flippedImage;
}

+ (UIImage*)imageNamed:(NSString *)name changeToColor:(UIColor*)color {
    UIImage* image = [self imageNamed:name changeToColor:color scaledToSize:[UIImage imageNamed:name].size];
    
    return image;
}
@end
