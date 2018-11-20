//
//  ViewController.swift
//  RadioButton
//
//  Created by William-Weng on 2018/11/20.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit
import WWRadioButton

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func showButton(_ sender: WWRadioButton) {
        
        sender.isTouched = true
        
        guard let selectedButton = WWRadioButton.selectedButtonList[sender.groupIdentifier],
              let nowSelectedButton = selectedButton
        else {
            return
        }
        
        print(nowSelectedButton.tag)
    }
}

