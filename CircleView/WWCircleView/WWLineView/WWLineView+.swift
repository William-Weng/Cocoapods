//
//  WWLineView+.swift
//  WWCircleView
//
//  Created by William.Weng on 2019/12/6.
//  Copyright © 2019 William.Weng. All rights reserved.
//

import UIKit

/// MARK: API
extension WWLineView {

    /// 繪製動畫
    public func drawing(with percent: CGFloat) {
        
        rootLayer.sublayers?.forEach({ (layer) in
            layer.removeFromSuperlayer()
        })

        rootLayer.sublayers = nil
        rootLayer.removeAllAnimations()

        self.percent = percent
        
        shapeLayerDrawing()
        animateCAShapeLayerDrawing()
    }
    
    /// 相關設定
    public func setting(animationDuration: TimeInterval) {
        self.animationDuration = animationDuration
    }
}

/// MARK: 主功能
extension WWLineView {
    
    /// 載入XIB的一些基本設定
    func initViewFromXib(with name: String) {
        
        let bundle = Bundle.init(for: WWLineView.self)

        bundle.loadNibNamed(name, owner: self, options: nil)
        contentView.frame = bounds

        addSubview(contentView)
    }

    /// 基本設定 (底圖)
    func layerSetting(with rect: CGRect) {
        
        rootLayer.frame = rect
        rootLayer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)

        layer.addSublayer(rootLayer)
    }
    
    /// 畫線 (100%)
    func shapeLayerDrawing() {
        let layer = baseShapeLayer(color: baseLineColor)
        rootLayer.addSublayer(layer)
    }
    
    /// 畫直線 (動畫)
    func animateCAShapeLayerDrawing() {
        let layer = baseShapeLayer(color: drawLineColor)
        layer.add(pathAnimation(rate: realPercent(for: percent)), forKey: "strokeEndAnimation")
        rootLayer.addSublayer(layer)
    }
    
    /// 基本的直線路徑Layer
    private func baseShapeLayer(color: UIColor, rate: CGFloat = 1.0) -> CAShapeLayer {
        
        let layer = CAShapeLayer()
        let path = CGMutablePath()

        path.move(to: CGPoint(x: 0, y: frame.height * 0.5))
        path.addLine(to: CGPoint(x: frame.width * rate, y: frame.height * 0.5))

        layer.path = path
        layer.strokeColor = color.cgColor
        layer.lineWidth = frame.height
        layer.fillColor = nil
        layer.lineCap = .round
        
        return layer
    }

    /// 基本的畫圓動畫
    private func pathAnimation(rate: CGFloat) -> CABasicAnimation {
        
        let animationKeyPath = "strokeEnd"
        let pathAnimation = CABasicAnimation(keyPath: animationKeyPath)
        
        pathAnimation.duration = animationDuration
        pathAnimation.fromValue = 0
        pathAnimation.toValue = rate
        pathAnimation.repeatCount = 1
        
        pathAnimation.isRemovedOnCompletion = false
        pathAnimation.fillMode = .forwards

        return pathAnimation
    }
}

/// MARK: 小工具
extension WWLineView {
    
    /// 百分比換算成有效小數
    private func realPercent(for number: CGFloat) -> CGFloat {
        
        switch number {
        case 0..<100:
            return percent / 100.0
        case 100...:
            return 1.0
        default:
            return 0.0
        }
    }
}

/// MARK: Demo
extension WWLineView {
    
    /// 在Storyboard上畫出Demo的動畫線
    func demoDrawLine() {
        
        #if TARGET_INTERFACE_BUILDER

        let layer = baseShapeLayer(color: drawLineColor, rate: realPercent(for: percent))
        rootLayer.addSublayer(layer)
        
        #endif
    }
}
