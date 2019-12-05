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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func changeValue(_ sender: UISlider) {
        circleView.drawing(with: CGFloat(sender.value))
    }
}

