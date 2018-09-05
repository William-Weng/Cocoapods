//
//  WWCircularCollectionView+.swift
//  WWCircularCollectionView
//
//  Created by William-Weng on 2018/9/5.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

// MARK: UICollectionViewDataSource
extension WWCircularCollectionView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isInfinity ? itemCount.infinity : itemCount.original
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? WWCircularCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let index = indexPath.row % itemCount.original
        cell.imageName = imagesDiectory[index]
        
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension WWCircularCollectionView: UICollectionViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        infinityScrollSetting(scrollView, isInfinity: isInfinity)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        isOffsetOver = targetContentOffsetIsOver(targetContentOffset.pointee, isInfinity: isInfinity)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        fixTargetContentOffset(with: isOffsetOver, isInfinity: isInfinity)
    }
}

// MARK: 基本設定
extension WWCircularCollectionView {
    
    /// 註冊Xib
    public func registerXib() {
        let bundle = Bundle.init(for: WWCircularCollectionView.self)
        let xib = UINib.init(nibName: xibName, bundle: bundle)
        register(xib, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    /// 初始化DataSource與Delegate
    public func delegateSetting() {
        dataSource = self
        delegate = self
    }
    
    /// 計算item的數量 (如果是要無限旋轉的話，數量要修正為3倍)
    func makeItemCount(with images: [String]) -> ItemCount {
        let count = images.count
        return (count, count * 3)
    }
}

// MARK: 無限旋轉
extension WWCircularCollectionView {
    
    /// 產生在正中央的contentOffset的值
    func makeContentOffsetCenter(with isInfinity: Bool) -> CGPoint {
        
        guard isInfinity,
              let layout = collectionViewLayout as? WWCircularCollectionViewLayout
        else {
            return .zero
        }
        
        let centerWidth = contentSize.width * 1 / 3 - WWLayoutParameter.itemSize.width
        let point = CGPoint.init(x: centerWidth, y: 0)
        let contentOffsetCenter = layout.autofixContentOffset(point, velocity: point)
        
        return contentOffsetCenter
    }
    
    /// 無限旋轉的設定 (讓旋轉的範圍介於 => 第二列的開頭 ~ θ ~ 第三列的開頭)
    func infinityScrollSetting(_ scrollView: UIScrollView, isInfinity: Bool) {
        
        if !isInfinity { return }
        
        let centerWidth: InfinityContentOffset = (0, middleContentOffset.x, middleContentOffset.x * 2)
        
        if (scrollView.contentOffset.x <= centerWidth.middle) {
            scrollView.contentOffset.x = centerWidth.end; return
        }
        
        if (scrollView.contentOffset.x > centerWidth.end) {
            scrollView.contentOffset.x = centerWidth.middle; return
        }
    }
    
    /// 看看有沒有轉過了頭
    func targetContentOffsetIsOver(_ offset: CGPoint, isInfinity: Bool) -> Bool {
        
        guard isInfinity else { return false }
        
        let scrollOffsetX = (min: CGFloat(0.0), max: contentSize.width - bounds.width)
        
        if offset.x >= scrollOffsetX.max { return true }
        if offset.x <= scrollOffsetX.min { return true }
        
        return false
    }
    
    /// 轉過頭的話就修正自動轉到正中央
    func fixTargetContentOffset(with isOffsetOver: Bool, isInfinity: Bool) {
        
        guard isInfinity, isOffsetOver,
              let layout = collectionViewLayout as? WWCircularCollectionViewLayout,
              let fixOffset = Optional.some(layout.autofixContentOffset(contentOffset, velocity: contentOffset))
        else {
            return
        }
        
        setContentOffset(fixOffset, animated: true)
    }
}

