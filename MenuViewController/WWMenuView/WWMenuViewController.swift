//
//  MenuViewController.swift
//  ContainerView_Demo
//
//  Created by William-Weng on 2018/11/6.
//  Copyright © 2018年 William-Weng. All rights reserved.
//
/// [SideMenuSwift](https://github.com/kukushi/SideMenu)

import UIKit

open class WWMenuViewController: UIViewController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// 切換ContainerView的內容
    public func changePage(to newViewController: UIViewController) {
        
        guard let menuViewController = WWMainViewController.shared,
              let containerView = menuViewController.mainContainerView,
              var selectedViewController = menuViewController.viewControllers.main
        else {
            return
        }
        
        selectedViewController.willMove(toParent: nil)
        selectedViewController.view.removeFromSuperview()
        selectedViewController.removeFromParent()
        
        menuViewController.addChild(newViewController)
        containerView.addSubview(newViewController.view)
        newViewController.view.frame = containerView.bounds
        newViewController.didMove(toParent: menuViewController)
        
        if let pageViewController = findPageViewController(with: newViewController) {
            selectedViewController = pageViewController
            DispatchQueue.main.async { menuViewController.hideMenuView() }
        }
    }
    
    /// 取得主頁面的PageViewController
    private func findPageViewController(with viewController: UIViewController) -> WWPageViewController? {
        
        if let pageViewController = viewController as? WWPageViewController {
            return pageViewController
        }
        
        if let navigationController = viewController as? UINavigationController {
            guard let pageViewController = navigationController.viewControllers.first as? WWPageViewController else { return nil }
            return pageViewController
        }
        
        if let tabBarController = viewController as? UITabBarController {
            guard let pageViewController = tabBarController.viewControllers?.first as? WWPageViewController else { return nil }
            return pageViewController
        }
        
        return nil
    }
}
