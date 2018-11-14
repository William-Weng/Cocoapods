//
//  Page2a_ViewController.swift
//  ContainerView_Demo
//
//  Created by William-Weng on 2018/11/9.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit
import WWMenuView

class Page2a_ViewController: WWPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showMenu(_ sender: UIButton) {
        menuStatus(.show)
    }
    
    @IBAction func hideMenu(_ sender: UIButton) {
        menuStatus(.hide)
    }
}
