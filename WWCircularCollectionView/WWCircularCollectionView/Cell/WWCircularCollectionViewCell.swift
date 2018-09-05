//
//  WWCircularCollectionViewCell.swift
//  CircularCollectionView
//
//  Created by William-Weng on 2018/8/29.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

class WWCircularCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView?
    
    static let reuseIdentifier = String.init(describing: WWCircularCollectionViewCell.self)

    var imageName: String = String() {
        didSet { imageView!.image = UIImage(named: imageName) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetting()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let circularLayoutAttributes = layoutAttributes as? WWCircularCollectionViewLayoutAttributes else { return }
        circularLayoutSetting(with: circularLayoutAttributes)
    }
}

extension WWCircularCollectionViewCell {
    
    /// 初始化外型的設定
    func initSetting() {
        contentView.layer.cornerRadius = 5
        contentView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        contentView.layer.borderWidth = 0
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.main.scale
        contentView.clipsToBounds = true
    }
    
    /// 設定成圓形外型 (圓心 / 中點)
    func circularLayoutSetting(with circularLayoutAttributes: WWCircularCollectionViewLayoutAttributes) {
        layer.anchorPoint = circularLayoutAttributes.anchorPoint
        center.y += fixCenterY(with: circularLayoutAttributes)
    }

    /// 修正圓心在半徑圓點上的偏移量
    func fixCenterY(with circularLayoutAttributes: WWCircularCollectionViewLayoutAttributes) -> CGFloat {
        return WWLayoutParameter.radius
    }
}


