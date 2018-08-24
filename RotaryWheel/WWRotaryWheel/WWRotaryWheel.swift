//
//  WWRotaryWheel.swift
//  RotaryWheel
//
//  Created by William-Weng on 2018/8/20.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

public protocol WWRotaryWheelDelegate: class {
    /// 現在按到哪一個
    func wwRotaryWheel(_ wwRotaryWheel: WWRotaryWheel, clickedItemAt index: Int, for buttons: [UIButton])
    
    /// 現在選到哪一個
    func wwRotaryWheel(_ wwRotaryWheel: WWRotaryWheel, selectedItemAt index: Int, for buttons: [UIButton])
}

@IBDesignable
public class WWRotaryWheel: UIView {

    typealias WheelParameter = (startRadian: CGFloat, deltaRadian: CGFloat, startTransform: CGAffineTransform)
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBInspectable var backgroundImage: UIImage? { willSet { backgroundImageSetting(with: newValue)}}
    @IBInspectable var rotatingShaftColor: UIColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    @IBInspectable var rotatingShaftTextColor: UIColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
    @IBInspectable var buttonColor: UIColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    @IBInspectable var buttonTextColor: UIColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
    @IBInspectable var buttonTextSize: CGFloat = 24.0
    @IBInspectable var rotatingShaftWidth: CGFloat = 36.0
    @IBInspectable var shortenRadius: CGFloat = 0.0
    @IBInspectable var isVerticalWord: Bool = false
    @IBInspectable var startAngle: CGFloat = 0.0
    @IBInspectable var count: UInt = 3 { willSet { setNeedsDisplay() }}
    
    let rotationZ = "transform.rotation.z"
    let circleAngle360: CGFloat = 360.0

    var wheelParameters: WheelParameter = (CGFloat(0), CGFloat(0), CGAffineTransform())
    var wheelButtonsStartTransforms = [CGAffineTransform]()
    var wheelAngles = [CGFloat]()
    var wheelButtons = [UIButton]()
    var wheelLabels = [UILabel]()
    var wheelButtonsImage = [UIImage]()
    var wheelButtonsTitle = [String]()

    public weak var delegate: WWRotaryWheelDelegate? = nil
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromXib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromXib()
    }
    
    override public func draw(_ rect: CGRect) {
        wheelSetting(with: count, rect: rect, shortenRadius: shortenRadius, startAngle: startAngle)
    }
}

