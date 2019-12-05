//
//  ViewController.swift
//  WWShapeLayerView
//
//  Created by William.Weng on 2019/12/4.
//  Copyright © 2019 William.Weng. All rights reserved.
//

import UIKit
import WWCircleView

final class ViewController: UIViewController {

    @IBOutlet weak var circleView: WWCircleView!
    @IBOutlet weak var animationLabel: WWAnimationLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func changeValue(_ sender: UISlider) {
        
        let animationDuration: TimeInterval = 5
        
        circleView.setting(animationDuration: animationDuration)
        circleView.drawing(with: CGFloat(sender.value))
        
        animationLabel.setting(startNumber: 100, endNumber: 10000, animationDuration: animationDuration, currencyCode: "HKD")
        animationLabel.running()
    }
}

