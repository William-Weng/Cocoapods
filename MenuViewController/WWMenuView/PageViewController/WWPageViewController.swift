//
//  PageViewController.swift
//  ContainerView_Demo
//
//  Created by William-Weng on 2018/11/7.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

open class WWPageViewController: UIViewController {

    var isLoaded = false
    
    public enum MenuStatus {
        case show
        case hide
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension WWPageViewController {
    
    /// 切換側邊選單開關的狀態
    open func menuStatus(_ status: MenuStatus) {
        
        guard let menuViewController = WWMainViewController.shared else { return }
        
        switch status {
        case .show:
            menuViewController.showMenuView()
        case .hide:
            menuViewController.hideMenuView()
        }
    }
}
