//
//  AppDelegate.swift
//  UIWindow_Demo
//
//  Created by William-Weng on 2019/1/11.
//  Copyright © 2019年 William-Weng. All rights reserved.
//

import UIKit
import WWLogView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = WWLogView.shared
        return true
    }
}

