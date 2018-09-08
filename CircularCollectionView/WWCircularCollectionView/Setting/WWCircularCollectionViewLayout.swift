//
//  WWCircularCollectionViewLayout.swift
//  CircularCollectionView
//
//  Created by William-Weng on 2018/8/29.
//  Copyright © 2018年 William-Weng. All rights reserved.
//
/// [UICollectionView Custom Layout Tutorial: A Spinning Wheel](https://www.raywenderlich.com/1702-uicollectionview-custom-layout-tutorial-a-spinning-wheel)
/// [輪轉式卡片效果 - 個性化UICollectionView Layout(譯)](https://www.jianshu.com/p/45f39b70263d)
/// [UICollectionViewLayout佈局詳解](https://www.jianshu.com/p/45ff718090a8)
/// [【Swift】UICollectionViewで無限スクロールをやってみた](https://qiita.com/ryokosuge/items/828e436349aac569b3e6)
/// [創建自定義UICollectionView layout](https://www.jianshu.com/p/40868928a1cf)
/// [集合視圖的自動佈局：UICollectionViewLayout是抽象根類,必須用它的子類才能創建實例,下面是重寫的方法,計算item的佈局屬性](https://www.cnblogs.com/XYQ-208910/p/4985546.html)
/// [【Swift4】UICollectionViewを使ってカルーセルを実装してみた。【無限スクロール編】](https://uruly.xyz/carousel-infinite-scroll/)
/// [Swift - 多列表格組件的實現（樣例1：基本功能的實現）](http://www.hangge.com/blog/cache/detail_1081.html)
/// [UIScrollView的delegate方法妙用之讓UICollectionView滑動到某個你想要的位置 - scrollViewWillEndDragging(_:withVelocity:targetContentOffset:)](https://www.cnblogs.com/Phelthas/p/4584645.html)

import UIKit

public protocol WWCircularCollectionViewLayoutDelegate: class {
    
    /// 目前選到的是哪一個
    func wwCircularCollectionViewLayout(_ wwCircularCollectionViewLayout: WWCircularCollectionViewLayout, selectedIndex index: Int)
    
    /// 最後選到的是哪一個
    func wwCircularCollectionViewLayout(_ wwCircularCollectionViewLayout: WWCircularCollectionViewLayout, lastSelectedIndex index: Int)
}

public class WWCircularCollectionViewLayout: UICollectionViewLayout {
    
    let itemSize = WWLayoutParameter.itemSize

    var circularAttributesList: [WWCircularCollectionViewLayoutAttributes]?
    var radius: CGFloat = WWLayoutParameter.radius { didSet { invalidateLayout() } }
    var anglePerItem: CGFloat { return averageAngle() }
    var firstItemAngle: CGFloat { return firstItemAngleFromLast() }
    var scrollAngle: CGFloat { return makeScrollAngle() }

    weak public var wwDelegate: WWCircularCollectionViewLayoutDelegate?
    
    override public func prepare() {
        super.prepare()
        attributesSetting()
    }
    
    override public var collectionViewContentSize: CGSize {
        return makeContentSize()
    }
}

// MARK: Override
extension WWCircularCollectionViewLayout {
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return circularAttributesList
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return circularAttributesList?[indexPath.row]
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return recalculateForBoundsChange()
    }
    
    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        return autofixContentOffset(proposedContentOffset, velocity: velocity)
    }
}

// MARK: 基本設定
extension WWCircularCollectionViewLayout {
    
    /// 設定各item的屬性
    func attributesSetting() {
        
        let itemCount = collectionView?.numberOfItems(inSection: 0)
        let center = offsetCenter()
        let anchorPoint = itemAnchorPoint(with: itemSize, radius: radius)
        
        circularAttributesList = makeAttributesList(with: itemCount, center: center, anchorPoint: anchorPoint)
    }
    
    /// 計算內容的總大小
    func makeContentSize() -> CGSize {
        
        guard let collectionView = collectionView as? WWCircularCollectionView else { return .zero }
        
        let count = collectionView.numberOfItems(inSection: 0)
        let size = CGSize(width: CGFloat(count) * itemSize.width, height: collectionView.bounds.height)
        
        return size
    }
}

// MARK: 小工具
extension WWCircularCollectionViewLayout {
    
    /// 計算Item旋轉的平均角度 (可自訂)
    func averageAngle() -> CGFloat {
        return WWLayoutParameter.averageAngle
    }

    /// 產生各屬性的值 (在可視的範圍內 => 0..15)
    func makeAttributesList(with count: Int?, center: CGPoint, anchorPoint: CGPoint) -> [WWCircularCollectionViewLayoutAttributes]? {
        
        guard let collectionView = collectionView as? WWCircularCollectionView,
              let count = count,
              let indexRange = makeItemIndexRange(with: scrollAngle, count: count),
              !indexRange.isEmpty
        else {
            return nil
        }

        let attributesList = indexRange.map { (index) -> WWCircularCollectionViewLayoutAttributes in
            return makeAttributes(with: index, center: center, anchorPoint: anchorPoint)
        }
        
        selectedIndexDelegate(with: collectionView)
        
        return attributesList
    }

    /// 屬性值設定 (大小 / 中心點 / 角度 / 錨點)
    func makeAttributes(with index: Int, center: CGPoint, anchorPoint: CGPoint) -> WWCircularCollectionViewLayoutAttributes {
        
        let attributes = WWCircularCollectionViewLayoutAttributes(forCellWith: IndexPath.init(row: index, section: 0))
        
        attributes.size = itemSize
        attributes.center = center
        attributes.anchorPoint = anchorPoint
        attributes.angle = anglePerItem * CGFloat(index) + scrollAngle
        
        return attributes
    }
    
    /// 計算跟著offset移動的中心點在哪裡
    func offsetCenter() -> CGPoint {
        
        guard let collectionView = collectionView as? WWCircularCollectionView else { return .zero }
        
        let centerX = (collectionView.bounds.width / 2.0) + collectionView.contentOffset.x
        let center = CGPoint(x: centerX, y: collectionView.bounds.midY)
        
        return center
    }
    
    /// 計算各錨點(圓心)的位置 => ∵ 旋轉圓心不在item裡面 ∴ anchorPointY > 1.0
    func itemAnchorPoint(with size: CGSize, radius: CGFloat) -> CGPoint {
        
        let centerPointY = WWLayoutParameter.centerAnchor.y + radius / size.height
        let anchorPoint = CGPoint(x: WWLayoutParameter.centerAnchor.x, y: centerPointY)
        
        return anchorPoint
    }
    
    /// 計算當contentOffsetX移動時，相對的旋轉角度(比例)
    func makeScrollAngle() -> CGFloat {
        
        guard let collectionView = collectionView as? WWCircularCollectionView else { return 0 }
        
        let maxContentOffsetX = collectionViewContentSize.width - collectionView.bounds.width
        let ratio = collectionView.contentOffset.x / maxContentOffsetX
        let angle = firstItemAngle * ratio
        
        return angle
    }
    
    /// 寬度變化時重新計算其數值
    func recalculateForBoundsChange() -> Bool {
        return true
    }
    
    /// 由最後一個item為零度時，倒回來計算第一個item的角度
    func firstItemAngleFromLast() -> CGFloat {
        
        guard let collectionView = collectionView as? WWCircularCollectionView,
              let count = Optional.some(collectionView.numberOfItems(inSection: 0))
        else {
            return 0
        }
        
        let angle = (count > 0) ? CGFloat(count - 1) * anglePerItem * -1 : 0
        return angle
    }
    
    /// 利用三角函數計算出可視範圍的角度 (看得到的item => -θ > visibleAngle > +θ)
    func visibleAngle() -> CGFloat {
        
        guard let collectionView = collectionView as? WWCircularCollectionView else { return 0 }
        
        let size = CGSize.init(width: collectionView.bounds.width * 0.5, height: radius + (itemSize.height * 0.5) - (collectionView.bounds.height * 0.5))
        let visibleAngle = atan(size.width / size.height)
        
        return visibleAngle
    }
    
    /// 計算出該角度內的item範圍 (介於最左邊~最右邊之間)
    func makeItemIndexRange(with angle: CGFloat, count: Int) -> CountableClosedRange<Int>? {
        
        guard count > 0 else { return nil }
        
        let visibleAngleMax = visibleAngle()
        let endIndex = count - 1
        let indexRange: CountableClosedRange<Int>
        let nowScrollAngle = (left: floor(-visibleAngleMax - angle), right: ceil(visibleAngleMax - angle))
        
        var index = (start: 0, end: endIndex)
        
        if (angle < -visibleAngleMax) { index.start = Int(nowScrollAngle.left / anglePerItem) }
        index.end = min(index.end, Int(nowScrollAngle.right / anglePerItem))
        
        indexRange = (index.end < index.start) ? 0...0 : index.start...index.end
        
        return indexRange
    }
    
    /// 自動補足未完成的Offset (讓item一直在正中央)
    func autofixContentOffset(_ offset: CGPoint, velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = collectionView as? WWCircularCollectionView else { return .zero }
        
        let ratio = firstItemAngle / (collectionViewContentSize.width - collectionView.bounds.width) * -1
        let endDraggingAngle = offset.x * ratio
        let indexRatio = autofixRatio(endDraggingAngle, velocity: velocity)
        
        var finalContentOffset = offset
        
        finalContentOffset.x = (indexRatio * anglePerItem / ratio)
        lastSelectedIndexDelegate(with: collectionView, index: Int(indexRatio))

        return finalContentOffset
    }
    
    /// 計算自動修正的比例 (向左轉 / 向右轉 / 剛剛好不動)
    func autofixRatio(_ angle: CGFloat, velocity: CGPoint) -> CGFloat {
        
        let ratio = angle / anglePerItem
        
        if (velocity.x > 0) { return ceil(ratio) }
        if (velocity.x < 0) { return floor(ratio) }
        if (velocity.x == 0) { return round(ratio) }

        return 0.0
    }
    
    /// 計算出合適的Index (四捨五入)
    func makeSelectedIndex(indexRatio: CGFloat) -> Int {
        return Int(round(indexRatio * -1))
    }
}

// MARK: Delegate
extension WWCircularCollectionViewLayout {
    
    /// 回傳目前選到的是哪一個
    func selectedIndexDelegate(with collectionView: WWCircularCollectionView) {
        let selectedIndex = makeSelectedIndex(indexRatio: scrollAngle / anglePerItem)
        let originalItemCount = collectionView.itemCount.original
        wwDelegate?.wwCircularCollectionViewLayout(self, selectedIndex: selectedIndex % originalItemCount)
    }
    
    /// 回傳最後選到的是哪一個
    func lastSelectedIndexDelegate(with collectionView: WWCircularCollectionView, index: Int) {
        let originalItemCount = collectionView.itemCount.original
        wwDelegate?.wwCircularCollectionViewLayout(self, lastSelectedIndex: index % originalItemCount)
    }
}
