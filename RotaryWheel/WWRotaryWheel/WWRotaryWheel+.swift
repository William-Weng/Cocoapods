//
//  WWRotaryWheel+.swift
//  RotaryWheel
//
//  Created by William-Weng on 2018/8/22.
//  Copyright © 2018年 William-Weng. All rights reserved.
//
/// [Drag + Rotation using UIPanGestureRecognizer touch getting off track](https://stackoverflow.com/questions/10181255/drag-rotation-using-uipangesturerecognizer-touch-getting-off-track)
/// [How To Create a Rotating Wheel Control with UIKit](https://www.raywenderlich.com/2953-how-to-create-a-rotating-wheel-control-with-uikit)
/// [Pinch, Pan, and Rotate Text Simultaneously like Snapchat [SWIFT 3]](https://stackoverflow.com/questions/45402639/pinch-pan-and-rotate-text-simultaneously-like-snapchat-swift-3)
/// [iOS手勢識別的詳細使用(拖動,縮放,旋轉,點擊,手勢依賴,自定義手勢)](https://blog.csdn.net/totogo2010/article/details/8615940)
/// [模仿美圖秀秀單指旋轉圖片](https://www.jianshu.com/p/dbb05bdccf18)
/// [UIResponder-(學習整理)](https://www.jianshu.com/p/4285c26f1d2c)
/// [swift 無條件進位、捨去，四捨五入](https://www.jianshu.com/p/a041416056e4)

import UIKit

/// MARK: Override UIResponder (Touch)
public extension WWRotaryWheel {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        recordInitialValues(with: Array(touches))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveRotaionView(with: Array(touches))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        rotaionViewEndding(with: Array(touches))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
}

// MARK: init
extension WWRotaryWheel {
    
    /// 載入XIB的一些基本設定
    public func initViewFromXib() {
        
        let bundle = Bundle.init(for: WWRotaryWheel.self)
        let name = String(describing: WWRotaryWheel.self)
        
        bundle.loadNibNamed(name, owner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    /// 按鈕與背後移動View的初始化設定 (改變錨點 => 底部對齊 => 對齊中點 => 按照比較旋轉) => (button要比label小，不然按了沒反應)
    public func wheelSetting(with count: UInt, rect: CGRect, shortenRadius: CGFloat, startAngle: CGFloat) {
        
        let labelSize = CGSize.init(width: rotatingShaftWidth, height: rotaryAxisMaxHeight(with: rect, shortenRadius: shortenRadius))
        
        for index in 0..<count {
            
            let averageAngle = circleAngle360 / CGFloat(count) * CGFloat(index) + startAngle
            let wheelLabel = wheelLabelSetting(with: labelSize, for: index, and: averageAngle)
            let wheelButton = wheelButtonSetting(with: labelSize, for: index, and: averageAngle, isVerticalWord: isVerticalWord)
            
            wheelLabel.addSubview(wheelButton)
            baseView.addSubview(wheelLabel)
            
            wheelAngles.append(averageAngle)
            wheelButtons.append(wheelButton)
            wheelLabels.append(wheelLabel)
        }
        
        buttonsImageSetting(images: wheelButtonsImage)
        delegate?.wwRotaryWheel(self, selectedItemAt: 0, for: wheelButtons)
    }
    
    /// 設定各Button的圖形
    public func imageSetting(_ images: [UIImage]) {
        wheelButtonsImage = images
    }
}

// MARK: Selector
extension WWRotaryWheel {
    
    /// 按下按鈕
    @objc func clickButton(_ sender: UIButton) {
        delegate?.wwRotaryWheel(self, clickedItemAt: sender.tag, for: wheelButtons)
    }
}

/// MARK: 設定
extension WWRotaryWheel {
    
    /// 設定背景圖片
    func backgroundImageSetting(with image: UIImage?) {
        backgroundImageView.image = image
    }
    
    /// 設定各Button的圖形
    func buttonsImageSetting(images: [UIImage]) {
        
        if wheelButtons.count > images.count{
            for (index, image) in images.enumerated() { wheelButtons[index].setImage(image, for: .normal) }
        } else {
            for (index, button) in wheelButtons.enumerated() { button.setImage(images[index], for: .normal) }
        }
    }
}

/// MARK: UITouch
extension WWRotaryWheel {
    
    /// 記錄一些初始值
    func recordInitialValues(with touchArray: [UITouch]) {
        
        for touch in touchArray {
            saveWheelParameters(with: touch)
            saveWheelButtonsStartTransforms()
        }
    }
    
    /// 旋轉View
    func moveRotaionView(with touchArray: [UITouch]) {
        
        for touch in touchArray {
            let parameter = rotationRadianParameter(with: touch, for: baseView)
            let rotationRadian = parameter.delta - wheelParameters.deltaRadian
            
            rotateWheel(with: rotationRadian, isVerticalWord: isVerticalWord)
        }
        
        wheelStatus(with: false)
    }
    
    /// 旋轉結束 => 自動轉到最接近的點 (因為轉的方向跟一般認知相反，所以index要修正)
    func rotaionViewEndding(with touchArray: [UITouch]) {
        
        for touch in touchArray {
            
            let parameter = rotationRadianParameter(with: touch, for: baseView)
            let index = buttonIndexVaules(with: parameter.start)
            let angle = wheelAngles[index]
            let rotationRadian = angleToRadian(with: angle) - wheelParameters.startRadian
            
            UIView.animate(withDuration: 0.5, animations: {
                self.rotateWheel(with: rotationRadian, isVerticalWord: self.isVerticalWord)
            }, completion: { _ in
                
                let count = self.wheelButtons.count
                let fixIndex = (count - index) % count
                
                self.wheelStatus(with: true)
                self.delegate?.wwRotaryWheel(self, selectedItemAt: fixIndex, for: self.wheelButtons)
            })
        }
    }
}

/// MARK: UITouch Tools
extension WWRotaryWheel {

    /// 紀錄滾輪的初始值
    func saveWheelParameters(with touch: UITouch) {
        let parameter = rotationRadianParameter(with: touch, for: baseView)
        wheelParameters = (parameter.start, parameter.delta, baseView.transform)
    }
    
    /// 紀錄滾輪上按鈕的初始值
    func saveWheelButtonsStartTransforms() {
        wheelButtonsStartTransforms = [CGAffineTransform]()
        for button in wheelButtons { wheelButtonsStartTransforms.append(button.transform) }
    }
    
    /// 計算結束的角度最近哪一個
    func buttonIndexVaules(with endRadian: CGFloat) -> Int {
        
        let angle = radianToAngle(with: endRadian)
        let endAngle = (angle > 0) ? angle : (angle + circleAngle360)
        let averageAngle = Float(endAngle / (circleAngle360 / CGFloat(count)))
        let index = lroundf(averageAngle) % Int(count)
        
        return index
    }
    
    /// 計算旋轉View時所需的參數
    func rotationRadianParameter(with touch: UITouch, for rotationView: UIView) -> (start: CGFloat, delta: CGFloat) {
        
        let touchPoint = touch.location(in: self)
        let (dx, dy) = (touchPoint.x - rotationView.center.x, touchPoint.y - rotationView.center.y)
        let nowStartRadian = atan2(rotationView.transform.b, rotationView.transform.a)
        let nowDeltaRadian = atan2(dy, dx)
        
        return (nowStartRadian, nowDeltaRadian)
    }
    
    /// 滾輪輪軸的設定 (錨點設定在底部中央)
    func wheelLabelSetting(with size: CGSize, for index: UInt, and angle: CGFloat) -> UILabel {
        
        let anchorPoint = CGPoint(x: 0.5, y: 1.0)
        let wheelLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        
        wheelLabel.text = index.description
        wheelLabel.textColor = rotatingShaftTextColor
        wheelLabel.backgroundColor = rotatingShaftColor
        wheelLabel.center = baseView.center
        wheelLabel.layer.anchorPoint = anchorPoint
        wheelLabel.transform = CGAffineTransform.init(rotationAngle: angleToRadian(with: angle))
        wheelLabel.textAlignment = .center
        wheelLabel.isUserInteractionEnabled = true
        
        return wheelLabel
    }
    
    /// 滾輪按鈕的設定 (把按鈕轉正)
    func wheelButtonSetting(with size: CGSize, for index: UInt, and angle: CGFloat, isVerticalWord: Bool) -> UIButton {
        
        let wheelButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: size.width, height: size.width))
        
        wheelButton.tag = Int(index)
        wheelButton.backgroundColor = buttonColor
        wheelButton.setTitleColor(buttonTextColor, for: .normal)
        wheelButton.setTitle("\(index)", for: .normal)
        wheelButton.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
        wheelButton.layer.cornerRadius = size.width * 0.5
        wheelButton.clipsToBounds = true
        
        if isVerticalWord { wheelButton.transform = wheelButton.transform.rotated(by: angleToRadian(with: -1 * angle)) }
        
        return wheelButton
    }
    
    /// 旋轉滾輪
    func rotateWheel(with rotationRadian: CGFloat, isVerticalWord: Bool) {
        baseView.transform = wheelParameters.startTransform.rotated(by: rotationRadian)
        if isVerticalWord { antiRotateButton(with: rotationRadian) }
    }
    
    /// 讓按鍵反轉，讓文字一直是垂直的
    func antiRotateButton(with rotationRadian: CGFloat) {
        for (index, button) in wheelButtons.enumerated() {
            button.transform = wheelButtonsStartTransforms[index].rotated(by: -1 * rotationRadian)
        }
    }
    
    /// 轉軸的最大高度 (可以向內縮)
    func rotaryAxisMaxHeight(with rect: CGRect, shortenRadius: CGFloat) -> CGFloat {
        let size = rect.size
        let maxRadius = (size.width > size.height) ? (size.height / 2.0) : (size.width / 2.0)
        
        cornerRadiusSetting(with: maxRadius)
        
        return maxRadius - shortenRadius
    }
    
    /// 變成圓形的外框
    func cornerRadiusSetting(with maxRadius: CGFloat) {
        layer.cornerRadius = maxRadius
        clipsToBounds = true
    }
    
    /// 按鍵動作與否 (讓軸按下沒有反應)
    func wheelStatus(with isEnabled: Bool) {
        for label in wheelLabels { label.isUserInteractionEnabled = isEnabled }
    }
}

/// MARK: 小工具
extension WWRotaryWheel {
    
    /// 180 -> π
    func angleToRadian(with angle: CGFloat) -> CGFloat {
        return CGFloat(angle * CGFloat.pi / 180)
    }
    
    /// π -> 180
    func radianToAngle(with radian: CGFloat) -> CGFloat {
        return CGFloat(radian / CGFloat.pi * 180)
    }
}

