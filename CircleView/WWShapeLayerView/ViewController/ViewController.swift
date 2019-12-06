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
    @IBOutlet weak var lineView: WWLineView!
    @IBOutlet weak var nomeyLabel: WWAnimationLabel!
    @IBOutlet weak var persentLabel: WWAnimationLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func changeValue(_ sender: UISlider) {
    
        let animationDuration: TimeInterval = 1.5
        let rate = CGFloat(sender.value)
        
        circleView.setting(animationDuration: animationDuration)
        circleView.drawing(with: rate)
        
        nomeyLabel.setting(startNumber: 1, endNumber: 12345678, animationDuration: animationDuration, numberType: .money(currencyCode: "HKD"))
        nomeyLabel.running()
        
        lineView.setting(animationDuration: animationDuration)
        lineView.drawing(with: rate)
        
        persentLabel.setting(startNumber: 1, endNumber: TimeInterval(rate), animationDuration: animationDuration, numberType: .persent)
        persentLabel.running()
    }
}

