//
//  ViewController.swift
//  CustomSegment
//
//  Created by William-Weng on 2018/8/13.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit
import WWSegmentControl

class ViewController: UIViewController {
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myUIView: UIView!
    @IBOutlet weak var mySegmentControl: WWSegmentControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initWithIBOutlet()
        initWithFrame()
        initWithAutolayout(with: myUIView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController {
    
    /// 使用IBOutlet
    private func initWithIBOutlet() {
        mySegmentControl.delegate = self
    }
    
    /// 使用Frame
    private func initWithFrame() {
        let mySegmentControl = WWSegmentControl.init(frame: CGRect.init(x: 50, y: 250, width: 200, height: 50))
        mySegmentControl.countSetting(3)
        mySegmentControl.titleSetting(["A", "B", "C"])
        view.addSubview(mySegmentControl)
    }
    
    /// 使用Autolayout
    private func initWithAutolayout(with view: UIView) {
        let mySegmentControl = WWSegmentControl()
        mySegmentControl.countSetting(3)
        mySegmentControl.titleSetting(["あ", "い", "う"])
        mySegmentControl.autolayoutSetting(to: view)
    }
}

extension ViewController: WWSegmentControlDelegate {
    
    func wwSegmentControl(_ wwSegmentControl: WWSegmentControl, selectedItemAt index: Int, for button: UIButton) {
        myLabel.text = button.titleLabel?.text
        print(index)
    }
}




