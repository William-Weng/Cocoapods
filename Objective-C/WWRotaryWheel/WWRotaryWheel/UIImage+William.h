//
//  UIImage+William.h
//  Wheel
//
//  Created by engineer on 2017/1/13.
//  Copyright © 2017年 William-Weng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (William)

+(UIImage*)imageNamed:(NSString *)name changeToColor:(UIColor*)color;
+(UIImage*)imageNamed:(NSString *)name changeToColor:(UIColor*)color scaledToSize:(CGSize)newSize;

@end
