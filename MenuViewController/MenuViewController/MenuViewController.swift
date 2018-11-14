//
//  sdsViewController.swift
//  ContainerView_Demo
//
//  Created by William-Weng on 2018/11/13.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit
import WWMenuView

class MenuViewController: WWMenuViewController {
    
    lazy var page1ViewController: Page1_ViewController = {
        self.storyboard!.instantiateViewController(withIdentifier: "Page1") as! Page1_ViewController
    }()
    
    lazy var pageTabBarController: UITabBarController = {
        self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
    }()
    
    lazy var pageNavigationController: UINavigationController = {
        self.storyboard!.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
    }()
    
    var pages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pages = [
            page1ViewController,
            pageTabBarController,
            pageNavigationController
        ]
    }
    
    @IBAction func showPage1(_ sender: UIButton) {
        changePage(to: pages[0])
    }
    
    @IBAction func showPage2(_ sender: UIButton) {
        changePage(to: pages[1])
    }
    
    @IBAction func showPage3(_ sender: UIButton) {
        changePage(to: pages[2])
    }
    
    @IBAction func hideMenuView(_ sender: UIButton) {
        guard let menuViewController = WWMainViewController.shared else { return }
        menuViewController.hideMenuView()
    }
}
