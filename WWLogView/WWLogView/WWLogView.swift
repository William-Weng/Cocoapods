//
//  WWLogWindow.swift
//  UIWindow_Demo
//
//  Created by William-Weng on 2019/1/14.
//  Copyright © 2019年 William-Weng. All rights reserved.
//

import UIKit

/// 輸出文字
public func WWLog(_ log: String) {
    WWLogView.log(log)
}

// MARK: - 主體
open class WWLogView: UIWindow {
    
    static public let shared = WWLogView.initSetting()
    
    private override init(frame: CGRect) { super.init(frame: frame) }
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - 功能
extension WWLogView {
    
    /// 輸出訊息
    static func log<T>(_ msg: T, file: String = #file, method: String = #function, line: Int = #line) {
        
        if let viewController  = shared.rootViewController as? WWLogViewController {
            let message = "🚩 \((file as NSString).lastPathComponent)：\(line) - \(method) \n\t \(msg)"
            viewController.showLog(message)
        }
    }
}

// MARK: - 小工具
extension WWLogView {
    
    /// 產生一個新的Window
    private static func initSetting() -> WWLogView {
        
        let windowFrame = CGRect.init(x: 100, y: 100, width: 200, height: 200)
        let bundle = Bundle.init(for: WWLogView.self)
        let newWindow = WWLogView(frame: windowFrame)
        let newViewController = UIStoryboard.init(name: "WWLogView", bundle: bundle).instantiateViewController(withIdentifier: "WWLogViewController")
        
        newWindow.backgroundColor = .clear
        newWindow.windowLevel = UIWindow.Level.alert + 1000
        newWindow.rootViewController = newViewController
        newWindow.makeKeyAndVisible()
        
        return newWindow
    }
}
