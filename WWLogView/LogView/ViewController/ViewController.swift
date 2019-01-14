//
//  ViewController.swift
//  UIWindow_Demo
//
//  Created by William-Weng on 2019/1/11.
//  Copyright © 2019年 William-Weng. All rights reserved.
//
/// [UIAlertController+Window.m](https://github.com/dariachuiko/Weather/blob/master/Weather/UIAlertController%2BWindow.m)
/// [MLLog](https://github.com/nomoneynohoney/MLLog)

import UIKit
import WWLogView

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showWindow(_ sender: UIButton) {
        let time = Date()
        WWLog(time.description(with: Locale.init(identifier: "zh-TW")))
    }
}
