//
//  WWLayoutParameter.swift
//  CircularCollectionView
//
//  Created by William-Weng on 2018/8/31.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

struct WWLayoutParameter {
    static let itemSize = CGSize(width: 133, height: 173)
    static let radius: CGFloat = 500
    static let averageAngle = atan(itemSize.width / radius)
    static let centerAnchor = CGPoint(x: 0.5, y: 0.5)
}

