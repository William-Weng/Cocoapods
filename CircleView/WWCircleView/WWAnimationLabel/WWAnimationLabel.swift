//
//  WWAnimationLabel.swift
//  UILabelAnimation
//
//  Created by William.Weng on 2019/12/5.
//  Copyright © 2019 William.Weng. All rights reserved.
//
/// [Swift實現UILabel中數字動畫效果](https://ios.devdon.com/archives/507)
/// [利用 NumberFormatter 顯示 Money](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/利用-numberformatter-顯示-money-2ef9e1abfc10)

import UIKit

// MARK: - 有金額上加動畫的UILabel
open class WWAnimationLabel: UILabel {

    /// 數值類型 (金額 / 百分比 / 數字)
    public enum NumberType {
        case money(currencyCode: String)
        case percent
        case number
    }
    
    var timer: CADisplayLink?
    
    var startNumber: TimeInterval = 10
    var endNumber: TimeInterval = 100000
    var animationDuration: TimeInterval = 3

    var startTime: TimeInterval = 0
    var endTime: TimeInterval = 0
    var progressTime: TimeInterval = 0
    var progressNumber: TimeInterval = 0
    
    var numberType: NumberType = .number    
}


