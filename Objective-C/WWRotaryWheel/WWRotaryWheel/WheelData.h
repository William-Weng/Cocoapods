//
//  WheelData.h
//  Wheel
//
//  Created by William-Weng on 2017/1/8.
//  Copyright © 2017年 William-Weng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WheelData : NSObject

@property NSInteger indexOfButton;
@property CGFloat minValueOfRotateRange;
@property CGFloat midValueOfRotateRange;
@property CGFloat maxValueOfRotateRange;

@property BOOL isOn;
@property NSString* imageOfDevice;
@property NSString* macOfDevice;

@end
