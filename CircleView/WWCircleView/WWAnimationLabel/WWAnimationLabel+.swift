
//
//  WWAnimationLabel+.swift
//  WWCircleView
//
//  Created by William.Weng on 2019/12/5.
//  Copyright © 2019 William.Weng. All rights reserved.
//

import UIKit

// MARK: - API
extension WWAnimationLabel {
    
    /// 執行動畫 (金額往上加)
    public func running() {
        initValue()
        timerSetting()
    }

    /// 設定相關參數
    public func setting(startNumber: TimeInterval, endNumber: TimeInterval, animationDuration: TimeInterval, numberType: NumberType = .number) {
        
        self.startNumber = startNumber
        self.endNumber = endNumber
        self.animationDuration = animationDuration
        self.numberType = numberType
    }
}

// MARK: -  @objc
extension WWAnimationLabel {
    
    /// 更新數值
    @objc private func updateValue(timer: Timer) {
                
        progressTime = Date.timeIntervalSinceReferenceDate

        if progressTime >= endTime { clearTimer() }
        textSetting()
    }
}

// MARK: - 主工具
extension WWAnimationLabel {
    
    /// 設定初值
    private func initValue() {
        startTime = Date.timeIntervalSinceReferenceDate
        endTime = startTime + animationDuration
        progressNumber = startNumber
    }
    
    /// Timer設定
    private func timerSetting() {
        
        clearTimer()
        
        timer = CADisplayLink(target: self, selector: #selector(updateValue(timer:)))
        timer?.add(to: .main, forMode: .default)
        timer?.add(to: .main, forMode: .tracking)
    }
    
    /// 設定金額文字
    private func textSetting() {
        
        let value = valueMaker()
        let textMessage = numberMessage(value, type: numberType)
        
        text = "\(textMessage)"
    }
}

// MARK: - 小工具
extension WWAnimationLabel {
    
    /// 顯示的類型設定 (CGFloat => String)
    private func numberMessage(_ number: TimeInterval, type: NumberType) -> String {
        
        switch type {
        case .number: return "\(number)"
        case .persent: return persentFormat(number: number)
        case .money(let currencyCode): return moneyFormat(money: number, currencyCode: currencyCode) ?? ""
        }
    }

    /// 清除Timer
    private func clearTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// 數字的值 (依比例變化)
    private func valueMaker() -> TimeInterval {
        
        if progressTime >= endTime { return endNumber }
        progressNumber = startNumber + (endNumber - startNumber) / (endTime - startTime) * (progressTime - startTime)

        return progressNumber
    }
    
    /// 數字 => 金額 (1000.0 => $1,000.0)
    private func moneyFormat(money: TimeInterval, currencyCode: String) -> String? {

        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.currencyCode = currencyCode
        
        return formatter.string(from: NSNumber(value: money))
    }
    
    /// 數字 => 百分比 (87.2512232131212423 => 8.25%)
    private func persentFormat(number: TimeInterval) -> String {
        return String(format: "%5.2f", number) + " %"
    }
}
