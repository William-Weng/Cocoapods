//
//  WWCircleView+.swift
//  WWCircleView
//
//  Created by William.Weng on 2019/12/4.
//  Copyright © 2019 William.Weng. All rights reserved.
//

import UIKit

/// MARK: API
extension WWCircleView {

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
}

/// MARK: 主功能
extension WWCircleView {
    
    /// 載入XIB的一些基本設定
    func initViewFromXib(with name: String) {
        
        let bundle = Bundle.init(for: WWCircleView.self)

        bundle.loadNibNamed(name, owner: self, options: nil)
        contentView.frame = bounds

        addSubview(contentView)
    }

    /// 基本設定 (圓形)
    func layerSetting(with rect: CGRect) {
        
        parameter.radius = (rect.width > rect.height) ? rect.height * 0.5 : rect.width  * 0.5
        parameter.center = contentView.center
        
        rootLayer.frame = rect
        rootLayer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        
        layer.addSublayer(rootLayer)
    }
    
    /// 畫圓 (360度)
    func shapeLayerDrawing() {
        let layer = baseShapeLayer(endAngle: CGFloat(Double.pi) * 2.0, color: baseLineColor)
        rootLayer.addSublayer(layer)
    }

    /// 畫圓弧 (動畫)
    func animateCAShapeLayerDrawing() {
        let layer = baseShapeLayer(startAngle: angleToRadian(startAngle), endAngle: CGFloat(Double.pi) * 2.0, color: drawLineColor)
        layer.add(pathAnimation(), forKey: "strokeEndAnimation")
        rootLayer.addSublayer(layer)
    }
}

/// MARK: 小工具
extension WWCircleView {
    
    /// 基本的圓形路徑Layer
    private func baseShapeLayer(startAngle: CGFloat = 0, endAngle: CGFloat, color: UIColor) -> CAShapeLayer {
        
        let layer = CAShapeLayer()
        let path = CGMutablePath()
        
        path.addArc(center: parameter.center, radius: realRadius(), startAngle: startAngle, endAngle: startAngle + endAngle, clockwise: false)
        
        layer.path = path
        layer.strokeColor = color.cgColor
        layer.lineWidth = lineWidth
        layer.fillColor = nil
        layer.lineCap = .round
    
        return layer
    }
    
    /// 基本的圓弧動畫
    private func pathAnimation() -> CABasicAnimation {
        
        let animationKeyPath = "strokeEnd"
        let pathAnimation = CABasicAnimation(keyPath: animationKeyPath)
        
        pathAnimation.duration = animationDuration
        pathAnimation.fromValue = 0
        pathAnimation.toValue = realPercent()
        pathAnimation.repeatCount = 1
        
        pathAnimation.isRemovedOnCompletion = false
        pathAnimation.fillMode = .forwards

        return pathAnimation
    }

    /// 取得有效半徑
    private func realRadius() -> CGFloat {
        return parameter.radius - lineWidth / 2.0
    }
    
    /// 百分比換算成有效小數
    private func realPercent() -> CGFloat {
        
        switch percent {
        case 0..<100:
            return percent / 100.0
        case 100...:
            return 100
        default:
            return 0.0
        }
    }

    /// 角度 => 弧度 (180 => π)
    private func angleToRadian(_ angle: Double) -> CGFloat {
        let radian = angle * Double.pi / 180
        return CGFloat(radian)
    }
}

// MARK: - Demo
extension WWCircleView {
    
    /// 在Storyboard上畫出Demo的動畫線
    func demoDrawLine() {
        
        #if TARGET_INTERFACE_BUILDER

        let layer = baseShapeLayer(startAngle: angleToRadian(startAngle), endAngle: CGFloat(Double.pi * 2) * realPercent(), color: drawLineColor)
        rootLayer.addSublayer(layer)
        
        #endif
    }
}
