//
//  WWSegmentControl+.swift
//  WWSegmentControl
//
//  Created by William-Weng on 2018/8/15.
//  Copyright © 2018年 William-Weng. All rights reserved.
//
/// [快速入門指南：使用 UIViewPropertyAnimator 做動畫](https://swift.gg/2017/04/20/quick-guide-animations-with-uiviewpropertyanimator/)
/// [iOS – 通過Swift Framework發開製作可重複利用的 View](https://www.jianshu.com/p/5f1a008d45bc)
/// [Swift構建通用版本Framework以及Framework的使用及其注意事項](https://www.jianshu.com/p/13ee670f21ac)
/// [delegateをweakで宣言する際にprotocolにclassを継承する理由](https://qiita.com/yimajo/items/892bd2fe1ccb808ffe49)
/// [Swift製作Framework，提供給OC項目和Swift項目通用](https://www.jianshu.com/p/1ad5bede88bd)
/// [iOS開發之Framework上傳到Cocoapods看我應該夠了！](https://www.jianshu.com/p/a181b47f8881)

import UIKit

extension WWSegmentControl {
    
    /// Segment的基本設定
    public func countSetting(_ count: UInt? = nil, radius: CGFloat? = nil, width: CGFloat? = nil, textSize: CGFloat? = nil, disableTextColor: UIColor? = nil, enableTextColor: UIColor? = nil, selectedTag: UInt? = nil) {
        self.count = count ?? 2
        self.radius = radius ?? 0.0
        self.width = width ?? 1.0
        self.textSize = textSize ?? 14.0
        self.disableTextColor = disableTextColor ?? #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        self.enableTextColor = enableTextColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.selectedTag = selectedTag ?? 0
    }
    
    /// 設定Autolayout
    public func autolayoutSetting(to view: UIView) {
        
        let layoutAttributes: [NSLayoutAttribute] = [.top, .leading, .bottom, .trailing]
        var layoutConstraints: [NSLayoutConstraint] = []
        
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        for attribute in layoutAttributes {
            let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: 1.0, constant: 0.0)
            layoutConstraints.append(constraint)
        }

        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    /// 設定Segment按鈕的文字
    public func titleSetting(_ titles: [String]) {
        
        guard let buttons = baseSegmentView.arrangedSubviews as? [UIButton] else { return }
        
        for (index, title) in titles.enumerated() {
            if index < buttons.count { buttons[index].setTitle(title, for: .normal) }
        }
    }
}

extension WWSegmentControl {
    
    /// 按鈕移動動畫 => 變長變扁 => 移動中點
    @objc func moveButton(_ sender: UIButton) {
        
        if sender.tag == nowSelectedTag { return }
        guard let myButtons = baseSegmentView.arrangedSubviews as? [UIButton] else { return }
        
        let multiple = CGFloat(abs(sender.tag - nowSelectedTag) + 1)
        
        buttonsStatusSetting(false)
        buttonsColorSetting(with: sender)
        
        animator = UIViewPropertyAnimator.init(duration: 0.3, dampingRatio: 1, animations: {
            self.stretchMoveUIView(with: multiple, size: sender.frame.size)
        })
        
        animator?.addAnimations({
            let nowTag = (sender.tag > self.nowSelectedTag) ? self.nowSelectedTag : sender.tag
            self.changeMoveUIViewCenter(to: myButtons[nowTag])
        })
        
        animator?.addCompletion({ _ in
            _ = UIViewPropertyAnimator.init(duration: 0.3, dampingRatio: 0.7, animations: {
                self.revertMoveUIViewSize(to: sender)
                self.nowSelectedTag = sender.tag
                self.buttonsStatusSetting(true)
                self.delegate?.wwSegmentControl(self, selectedItemAt: self.nowSelectedTag, for: sender)
            }).startAnimation()
        })
        
        animator?.startAnimation()
    }
}


extension WWSegmentControl {
    
    /// 載入XIB的一些基本設定
    func initViewFromXib() {
        
        let bundle = Bundle.init(for: WWSegmentControl.self)
        let name = String(describing: WWSegmentControl.self)
        
        bundle.loadNibNamed(name, owner: self, options: nil)
        contentView.frame = bounds
        
        addSubview(contentView)
    }
    
    /// 按鈕與背後的移動View的初始化設定
    func buttonsSetting(with count: UInt) {
        
        if let buttons = baseSegmentView.arrangedSubviews as? [UIButton] {
            for button in buttons { button.removeFromSuperview() }
        }
        
        for index in 0..<count {
            
            let button = UIButton()
            
            button.tag = Int(index)
            button.setTitleColor(disableTextColor, for: .normal)
            button.backgroundColor = .clear
            button.setTitle("\(index)", for: .normal)
            button.addTarget(self, action: #selector(moveButton(_:)), for: .touchUpInside)
            
            baseSegmentView.addArrangedSubview(button)
        }
        
        moveUIViewWidth = moveUIViewWidth.setMultiplier(1 / CGFloat(count))
    }
    
    /// 設定Segment按鈕的文字內容
    func titleStringSetting(with titleString: String) {
        
        let titles = titleString.split(separator: ",").map { (string) -> String in
            return string.description
        }
        titleSetting(titles)
    }
    
    /// 設定一開始的選在哪一個選項
    func selectedTagSetting(with tag: UInt) {
        
        guard let segmentButtons = baseSegmentView.arrangedSubviews as? [UIButton] else { return }
        
        nowSelectedTag = (tag < count) ? Int(tag) : 0
        let selectedButton = segmentButtons[nowSelectedTag]
        
        moveUIViewLeading = moveUIViewLeading.setSecondItem(selectedButton)
        selectedButton.setTitleColor(enableTextColor, for: .normal)
    }
    
    /// 設定相關的半徑
    func radiusSetting(with radius: CGFloat) {
        layer.cornerRadius = radius
        moveUIView.layer.cornerRadius = radius
    }
    
    /// 設定外框的顏色與未選的字型顏色
    func borderColorSetting(with color: UIColor) {
        layer.borderColor = color.cgColor
        moveUIView.layer.backgroundColor = color.cgColor
        
        guard let buttons = baseSegmentView.arrangedSubviews as? [UIButton] else { return }
        
        for button in buttons {
            button.setTitleColor(color, for: .normal)
        }
    }
    
    /// 設定外框粗細
    func borderWidthSetting(with width: CGFloat) {
        layer.borderWidth = width
    }
    
    /// 設定字型大小
    func textSizeSetting(with fontSize: CGFloat) {
        
        guard let segmentButtons = baseSegmentView.arrangedSubviews as? [UIButton] else { return }
        
        for button in segmentButtons {
            button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    /// 拉伸選擇框的大小
    func stretchMoveUIView(with multiple: CGFloat, size: CGSize) {
        moveUIView.frame.size.width = size.width * multiple
        moveUIView.frame.size.height = size.height / multiple
        moveUIView.layer.cornerRadius = size.height / multiple / 2
    }
    
    /// 改變中點的位置
    func changeMoveUIViewCenter(to button: UIButton) {
        moveUIView.frame.origin.x = button.frame.origin.x
        moveUIView.center.y = button.center.y
    }
    
    /// 還原選擇框的大小
    func revertMoveUIViewSize(to button: UIButton) {
        moveUIView.frame.size = button.frame.size
        moveUIView.center = button.center
        moveUIView.layer.cornerRadius = radius
        moveUIViewLeading = moveUIViewLeading.setSecondItem(button)
    }
    
    /// 設定各Button的狀態
    func buttonsStatusSetting(_ status: Bool) {
        guard let myButtons = baseSegmentView.arrangedSubviews as? [UIButton] else { return }
        for button in myButtons { button.isEnabled = status }
    }
    
    /// 設定各按鈕的文字顏色
    func buttonsColorSetting(with sender: UIButton) {
        
        guard let myButtons = baseSegmentView.arrangedSubviews as? [UIButton] else { return }
        
        for button in myButtons {
            button.setTitleColor(disableTextColor, for: .normal)
        }
        
        sender.setTitleColor(enableTextColor, for: .normal)
    }
}
