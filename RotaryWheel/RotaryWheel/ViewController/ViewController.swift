//
//  ViewController.swift
//  RotaryWheel
//
//  Created by William-Weng on 2018/8/20.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit
import WWRotaryWheel

class ViewController: UIViewController {

    @IBOutlet weak var myRotaryWheel: WWRotaryWheel!
    @IBOutlet weak var myLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myRotaryWheel.delegate = self
        // myRotaryWheel.imageSetting([#imageLiteral(resourceName: "list"), #imageLiteral(resourceName: "like"), #imageLiteral(resourceName: "meeting"), #imageLiteral(resourceName: "plus"), #imageLiteral(resourceName: "check-mark")])
        myRotaryWheel.titleSetting(["🐶", "🐭", "👻", "🦊", "🐼"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: WWRotaryWheelDelegate {
    
    func wwRotaryWheel(_ wwRotaryWheel: WWRotaryWheel, clickedItemAt index: Int, for buttons: [UIButton]) {
        myLabel.text = index.description
    }
    
    func wwRotaryWheel(_ wwRotaryWheel: WWRotaryWheel, selectedItemAt index: Int, for buttons: [UIButton]) {
        for button in buttons { button.backgroundColor = .clear }
        buttons[index].backgroundColor = .yellow
    }
}

