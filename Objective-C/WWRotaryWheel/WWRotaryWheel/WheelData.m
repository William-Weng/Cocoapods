//
//  WheelData.m
//  Wheel
//
//  Created by William-Weng on 2017/1/8.
//  Copyright © 2017年 William-Weng. All rights reserved.
//

#import "WheelData.h"
#import "NSObject+William.h"

@implementation WheelData

@synthesize minValueOfRotateRange, midValueOfRotateRange, maxValueOfRotateRange, indexOfButton;

- (NSString *) description {
    
    return [NSString stringWithFormat:@"%ld | %f, %f, %f", self.indexOfButton, RadiansToDegrees(self.minValueOfRotateRange), RadiansToDegrees(self.midValueOfRotateRange), RadiansToDegrees(self.maxValueOfRotateRange)];
}

@end
