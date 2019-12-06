
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
    public func setting(startNumber: TimeInterval, endNumber: TimeInterval, animationDuration: TimeInterval, currencyCode: String? = nil) {
        self.startNumber = startNumber
        self.endNumber = endNumber
        self.animationDuration = animationDuration
        self.currencyCode = currencyCode ?? "TWD"
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
    
    /// 數字的值 (依比例變化)
    private func moneyeMaker() -> TimeInterval {
        
        if progressTime >= endTime { return endNumber }
        progressNumber = startNumber + (endNumber - startNumber) / (endTime - startTime) * (progressTime - startTime)

        return progressNumber
    }
    
    /// 設定金額文字
    private func textSetting() {
        
        let money = moneyeMaker()
        text = valueFormat(money: money)
    }
}

// MARK: - 小工具
extension WWAnimationLabel {

    /// 清除Timer
    private func clearTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// 數字 => 金額 (1000.0 => $1,000.0)
    private func valueFormat(money: TimeInterval) -> String? {

        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.currencyCode = currencyCode
        
        return formatter.string(from: NSNumber(value: money))
    }
}
