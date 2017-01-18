//
//  WheelProtocol.h
//  Wheel
//
//  Created by William-Weng on 2017/1/8.
//  Copyright © 2017年 William-Weng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WheelProtocol <NSObject>

- (void) wheelDidSelectedValue:(NSInteger)nowSelectedIndex;
- (void) wheelDidTouchedValue:(NSInteger)nowTouchedIndex;

@end
