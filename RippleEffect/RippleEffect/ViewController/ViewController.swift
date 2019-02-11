//
//  ViewController.swift
//  RippleEffect
//
//  Created by William-Weng on 2019/2/11.
//  Copyright © 2019年 William-Weng. All rights reserved.
//

import UIKit
import WWRippleEffect

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        WWRippleEffect.touch(touches: touches, viewController: self, duration: 2.0, lineWidth: 1.0, color: .blue, scale: 5.0, rippleSize: 32.0)
    }
    
    @IBAction func rippleShowed(_ sender: UIButton) {
        WWRippleEffect.click(for: sender, duration: 2.0, lineWidth: 1.0, color: .red, scale: 5.0)
    }
}
