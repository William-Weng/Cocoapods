//
//  ViewController.swift
//  CircularCollectionView
//
//  Created by William-Weng on 2018/8/29.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit
import WWCircularCollectionView

class ViewController: UIViewController {
    
    @IBOutlet weak var nowLabel: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    @IBOutlet weak var collectionView: WWCircularCollectionView!
    
    let isInfinity = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateSetting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController {
    
    /// 設定delegate
    func delegateSetting() {
        
        guard let layout = collectionView.collectionViewLayout as? WWCircularCollectionViewLayout else { return }
        
        layout.wwDelegate = self
        collectionView.wwDelegate = self
    }
}

extension ViewController: WWCircularCollectionViewDelegate {
    
    func isInfinity(_ wwCircularCollectionView: WWCircularCollectionView) -> Bool {
        return isInfinity
    }
    
    func imagesDiectory(_ wwCircularCollectionView: WWCircularCollectionView) -> [String] {
        return Bundle.main.paths(forResourcesOfType: "jpg", inDirectory: "Images").sorted()
    }
}

extension ViewController: WWCircularCollectionViewLayoutDelegate {
    
    func wwCircularCollectionViewLayout(_ wwCircularCollectionViewLayout: WWCircularCollectionViewLayout, selectedIndex index: Int) {
        nowLabel.text = index.description
    }
    
    func wwCircularCollectionViewLayout(_ wwCircularCollectionViewLayout: WWCircularCollectionViewLayout, lastSelectedIndex index: Int) {
        lastLabel.text = index.description
    }
}
