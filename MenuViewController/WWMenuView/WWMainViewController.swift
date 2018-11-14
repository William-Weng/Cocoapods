//
//  ViewController.swift
//  ContainerView_Demo
//
//  Created by William-Weng on 2018/11/6.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

open class WWMainViewController: UIViewController {

    let AnimateDuration: (show: TimeInterval, hide: TimeInterval) = (0.5, 0.5)
    let MenuPoint: (show: CGPoint, hide: CGPoint) = (.zero, CGPoint.init(x: -UIScreen.main.bounds.width, y: 0))
    
    var viewControllers: (main: WWPageViewController?, menu: WWMenuViewController?) = (nil, nil)
    
    public var mainContainerView: UIView!
    public var menuContainerView: UIView!

    static public let shared: WWMainViewController? = { return rootViewController() }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        performSegue(withIdentifier: WWMainSegue.identifier, sender: nil)
        performSegue(withIdentifier: WWMenuSegue.identifier, sender: nil)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        slideViewFrameSetting(with: MenuPoint.hide)
    }
    
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        initViewControllers(for: segue)
    }
}

// MARK: - 公開的函式
extension WWMainViewController {
    
    /// 顯示側邊選單
    public func showMenuView() {
        
        UIView.animate(withDuration: AnimateDuration.show, animations: {
            self.slideViewFrameSetting(with: self.MenuPoint.show)
        }, completion: { isOK in
            print("show => \(self.menuContainerView.frame)")
        })
    }
    
    /// 隱藏側邊選單
    public func hideMenuView() {
        
        UIView.animate(withDuration: AnimateDuration.hide, animations: {
            self.slideViewFrameSetting(with: self.MenuPoint.hide)
        }, completion: { isOK in
            print("hide => \(self.menuContainerView.frame)")
        })
    }
}

// MARK: - 小工具
extension WWMainViewController {
    
    /// 取得主要ViewController
    static private func rootViewController() -> WWMainViewController? {
        return UIApplication.shared.keyWindow?.rootViewController as? WWMainViewController
    }
    
    /// 設定側邊選單的初始位置
    private func slideViewFrameSetting(with origin: CGPoint) {
        menuContainerView.frame.origin = origin
    }
    
    /// 記錄畫面跟選單的ViewController
    private func initViewControllers(for segue: UIStoryboardSegue) {
        if segue.identifier == WWMainSegue.identifier { viewControllers.main = segue.destination as? WWPageViewController; return }
        if segue.identifier == WWMenuSegue.identifier { viewControllers.menu = segue.destination as? WWMenuViewController; return }
    }
}

