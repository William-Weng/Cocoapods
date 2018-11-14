//
//  MainSegue.swift
//  ContainerView_Demo
//
//  Created by William-Weng on 2018/11/13.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

open class WWMainSegue: UIStoryboardSegue {
    
    static let identifier = "Segue.Main"
    
    override open func perform() {
        
        guard let viewController = source as? WWMainViewController,
              let rootPageViewController = destination as? WWPageViewController,
              let mainView = viewController.mainContainerView
        else {
            return
        }
        
        rootPageViewController.view.frame = mainView.bounds
        
        viewController.addChild(rootPageViewController)
        mainView.addSubview(rootPageViewController.view)
        rootPageViewController.didMove(toParent: viewController)
    }
}
