//
//  WWCircularCollectionViewLayoutAttributes.swift
//  CircularCollectionView
//
//  Created by William-Weng on 2018/8/30.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

class WWCircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var anchorPoint = WWLayoutParameter.centerAnchor
    
    var angle: CGFloat = 0 {
        didSet { transformSetting(with: angle) }
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copiedAttributes = copyAttributes(with: super.copy(with: zone), anchorPoint: anchorPoint, angle: angle)
        return copiedAttributes
    }
}

extension WWCircularCollectionViewLayoutAttributes {
    
    /// 紀錄錨點與角度的值 (備份)
    func copyAttributes(with zoneAttributes: Any, anchorPoint: CGPoint, angle: CGFloat) -> Any {
        
        guard let copiedAttributes = zoneAttributes as? WWCircularCollectionViewLayoutAttributes else { return zoneAttributes }
        
        copiedAttributes.anchorPoint = anchorPoint
        copiedAttributes.angle = angle
        
        return copiedAttributes
    }
    
    /// 設定旋轉角度 / 前後層的關係
    func transformSetting(with angle: CGFloat) {
        zIndex = Int(angle * 1_000_000)
        transform = CGAffineTransform(rotationAngle: angle)
    }
}

