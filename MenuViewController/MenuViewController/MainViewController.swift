//
//  ViewController.swift
//  ContainerView_Demo
//
//  Created by William-Weng on 2018/11/13.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit
import WWMenuView

class MainViewController: WWMainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMenuContainerViews()
    }
}

extension MainViewController {
    
    /// 初始化ContainerView
    private func initMenuContainerViews() {
        
        let containerViews = (main: UIView.init(frame: view.frame), menu: UIView.init(frame: view.frame))
        
        view.addSubview(containerViews.main)
        view.addSubview(containerViews.menu)
        
        (mainContainerView, menuContainerView) = (containerViews.main, containerViews.menu)
    }
}
