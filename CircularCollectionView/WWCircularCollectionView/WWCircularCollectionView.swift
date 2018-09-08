//
//  WWCircularCollectionView.swift
//  CircularCollectionView
//
//  Created by William-Weng on 2018/8/29.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

public protocol WWCircularCollectionViewDelegate: class {
    
    /// 要不要無限旋轉
    func isInfinity(_ wwCircularCollectionView: WWCircularCollectionView) -> Bool
    
    /// item的image檔案路徑
    func imagesDiectory(_ wwCircularCollectionView: WWCircularCollectionView) -> [String]
}

public class WWCircularCollectionView: UICollectionView {
    
    typealias ItemCount = (original: Int, infinity: Int)
    typealias InfinityContentOffset = (start: CGFloat, middle: CGFloat, end: CGFloat)
    
    let reuseIdentifier = WWCircularCollectionViewCell.reuseIdentifier
    let xibName = String.init(describing: WWCircularCollectionViewCell.self)
    let cellItemsWidth = WWLayoutParameter.itemSize.width
    
    var scrollAngle: CGFloat = 0.0
    var isOffsetOver = false
    
    lazy var itemCount: ItemCount = { return makeItemCount(with: self.imagesDiectory) }()
    lazy var middleContentOffset: CGPoint = { makeContentOffsetCenter(with: isInfinity) }()
    lazy var isInfinity: Bool = { wwDelegate?.isInfinity(self) ?? false }()
    lazy var imagesDiectory = { wwDelegate?.imagesDiectory(self) ?? [String]() }()
    
    weak public var wwDelegate: WWCircularCollectionViewDelegate?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegateSetting()
        registerXib()
    }
    
    override public func draw(_ rect: CGRect) {
        contentOffset = middleContentOffset
    }
}
