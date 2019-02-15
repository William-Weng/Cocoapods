//
//  ViewController.swift
//  TouchIdTesting
//
//  Created by William-Weng on 2019/2/15.
//  Copyright © 2019年 William-Weng. All rights reserved.
//

import UIKit
import WWTouchIdTesting

class ViewController: UIViewController {

    @IBOutlet weak var successLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// TouchID / FaceID 測試 (info.plist => NSFaceIDUsageDescription)
    @IBAction func touchIdAction(_ sender: UIButton) {
        
        let myBiometryType = WWTouchIdTesting.run(reason: "ID辨識測試") { policyResult in
            
            DispatchQueue.main.async {
                switch policyResult {
                case .failure(let error):
                    self.successLabel.backgroundColor = .red
                    print("error = \(error.debugDescription)")
                case .success(let isOK):
                    self.successLabel.backgroundColor = .green
                    print("isOK = \(isOK.debugDescription)")
                }
            }
        }
        
        successLabel.text = "\(myBiometryType.toString())"
    }
}

