//
//  WWCircleView.swift
//  WWShapeLayerView
//
//  Created by William.Weng on 2019/12/4.
//  Copyright © 2019 William.Weng. All rights reserved.
//
/// [iOS顏色漸變之CAGradientLayer](https://www.jianshu.com/p/8c45d8a1645d)

import UIKit

@IBDesignable open class WWCircleView: UIView {

    @IBOutlet var contentView: UIView!

    @IBInspectable var animationDuration: Double = 1.0
    
    @IBInspectable var lineWidth: CGFloat = 10.0
    @IBInspectable var percent: CGFloat = 0.0
    @IBInspectable var startAngle: Double = 0
    
    @IBInspectable var baseLineColor: UIColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    @IBInspectable var drawLineColor: UIColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
    
    @IBInspectable var isGradient: Bool = false
    @IBInspectable var fromColor: UIColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    @IBInspectable var toColor: UIColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)

    let rootLayer = CAGradientLayer()
    let xibName = String(describing: WWCircleView.self)

    var parameter: (radius: CGFloat, center: CGPoint) = (.zero, .zero)

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromXib(with: xibName)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromXib(with: xibName)
    }

    override public func draw(_ rect: CGRect) {
        layerSetting(with: rect)
        shapeLayerDrawing()
        demoDrawLine()
    }

    /// [IB Designables: Failed to render and update auto layout status](https://stackoverflow.com/questions/46723683/ib-designables-failed-to-render-and-update-auto-layout-status)
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        contentView?.prepareForInterfaceBuilder()
    }
}

