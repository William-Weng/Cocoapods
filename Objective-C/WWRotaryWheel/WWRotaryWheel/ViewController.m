//
//  ViewController.m
//  Wheel
//
//  Created by William-Weng on 2017/1/8.
//  Copyright © 2017年 William-Weng. All rights reserved.
//  http://www.jianshu.com/p/33a28bb14749

#import "ViewController.h"
#import "WheelUIControl.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet WheelUIControl *wheel;

@end

@implementation ViewController

- (void)viewDidLoad {
    _wheel.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)refresh:(UIButton *)sender {
    _wheel.buttonCount = 10;
    _wheel.currentIndex = 0;
    [_wheel setNeedsDisplay];
}

- (void)wheelDidSelectedValue:(NSInteger)nowSelectedIndex {
    
    WheelButton* button = [_wheel.buttonArray objectAtIndex:nowSelectedIndex];
    [button setTitle:@"Selected" forState:UIControlStateNormal];
    
    if (button.wheelData.isOn) {
        [button setImage:_wheel.buttonOnImage forState:UIControlStateNormal];
    } else {
        [button setImage:_wheel.buttonOffImage forState:UIControlStateNormal];
    }
}

- (void)wheelDidTouchedValue:(NSInteger)nowTouchedIndex {
    
    WheelButton* button = [_wheel.buttonArray objectAtIndex:nowTouchedIndex];
    [button setTitle:@"Touched" forState:UIControlStateNormal];
    NSLog(@"[button.wheelData.isOn] ==> %d", button.wheelData.isOn);
    
    if (button.wheelData.isOn) {
        [button setImage:_wheel.buttonOnImage forState:UIControlStateNormal];
    } else {
        [button setImage:_wheel.buttonOffImage forState:UIControlStateNormal];
    }
    
    button.wheelData.isOn = !button.wheelData.isOn;
}

@end
