//
//  WWRippleEffect.swift
//  WWRippleEffect
//
//  Created by William-Weng on 2019/2/11.
//  Copyright © 2019年 William-Weng. All rights reserved.
//
/// [Swift:Add Ripple effect to a view](https://medium.com/@anoopm6/swift-add-ripple-effect-to-a-view-7b16af3da4f)

import UIKit

// MARK: - 工具
open class WWRippleEffect: Any {
    
    /// 按下View時的反應
    static public func click(for sender: UIView, duration: Double, lineWidth: CGFloat, color: UIColor, scale: CGFloat) {
        
        let ripplePosition = CGPoint(x: sender.bounds.size.width * 0.5, y: sender.bounds.size.height * 0.5)
        let rippleShape = rippleShapeMaker(for: sender, position: ripplePosition, duration: duration, lineWidth: lineWidth, color: color, scale: scale)
        
        sender.layer.addSublayer(rippleShape)
    }
    
    /// 點下UIViewController.view時的反應
    static public func touch(touches: Set<UITouch>, viewController: UIViewController, duration: Double, lineWidth: CGFloat, color: UIColor, scale: CGFloat, rippleSize: CGFloat) {
        
        guard let touch = touches.first,
              let baseView = viewController.view,
              let postion = Optional.some(touch.location(in: baseView)),
              let rippleView = Optional.some(UIView(frame: CGRect(origin: postion, size: CGSize(width: rippleSize, height: rippleSize))))
        else {
            return
        }
        
        let ripplePosition = rippleView.frame.origin
        let rippleShape = rippleShapeMaker(for: rippleView, position: ripplePosition, duration: duration, lineWidth: lineWidth, color: color, scale: scale)
        
        baseView.layer.addSublayer(rippleShape)
    }
}

// MARK: - 小工具
extension WWRippleEffect {
    
    /// 產生Ripple動畫Layer
    static private func rippleShapeMaker(for sender: UIView, position: CGPoint, duration: Double, lineWidth: CGFloat, color: UIColor, scale: CGFloat) -> CAShapeLayer {
        
        let ripplePath = UIBezierPath(ovalIn: sender.bounds)
        let rippleShape = CAShapeLayer()
        
        rippleShape.bounds = sender.bounds
        rippleShape.path = ripplePath.cgPath
        rippleShape.position = position
        rippleShape.fillColor = UIColor.clear.cgColor
        rippleShape.strokeColor = color.cgColor
        rippleShape.lineWidth = lineWidth
        rippleShape.opacity = 0.0
        rippleShape.add(rippleAnimations(with: scale, duration: duration), forKey: "rippleEffect")
        
        return rippleShape
    }
    
    /// 組合動畫 (放大 + 透明度)
    static private func rippleAnimations(with scale: CGFloat, duration: CFTimeInterval) -> CAAnimationGroup {
        
        let animationGroup = CAAnimationGroup()
        
        animationGroup.animations = [scaleAnimation(scale), opacityAnimation()]
        animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animationGroup.duration = duration
        animationGroup.repeatCount = 1
        animationGroup.isRemovedOnCompletion = true
        
        return animationGroup
    }
    
    /// 等比例放大動畫
    static private func scaleAnimation(_ scale: CGFloat) -> CABasicAnimation {
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        
        scaleAnimation.fromValue = CATransform3DIdentity
        scaleAnimation.toValue = CATransform3DMakeScale(scale, scale, 1)
        
        return scaleAnimation
    }
    
    /// 透明度動畫
    static private func opacityAnimation() -> CABasicAnimation {
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = nil
        
        return opacityAnimation
    }
}
