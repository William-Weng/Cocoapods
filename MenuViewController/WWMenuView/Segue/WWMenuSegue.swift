//
//  MenuSegue.swift
//  ContainerView_Demo
//
//  Created by William-Weng on 2018/11/13.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

open class WWMenuSegue: UIStoryboardSegue {
    
    static let identifier = "Segue.Menu"
    
    override open func perform() {
        embedInMenuController()
    }
}

extension WWMenuSegue {
    
    /// 嵌入MenuController到ContainerView中
    private func embedInMenuController() {
        
        guard let viewController = source as? WWMainViewController,
              let menuController = destination as? WWMenuViewController,
              let menuView = viewController.menuContainerView
        else {
            return
        }
        
        menuController.view.frame = menuView.bounds
        
        viewController.addChild(menuController)
        menuView.addSubview(menuController.view)
        menuController.didMove(toParent: viewController)
    }
}
