//
//  PageContentView.swift
//  yinchengYQH
//
//  Created by jnt on 2019/8/15.
//  Copyright © 2019 qirong. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : class {
    func pageContentView(contentView : PageContentView, progress : CGFloat, sourceIndex : Int , targetIndex : Int)
}

private let ContentCellID = "ContentCellID"

class PageContentView: UIView {
    
    // MARK : -定义属性
    private var childVcs : [UIViewController]
    private weak var parentViewController : UIViewController?
    private var startOffsetX : CGFloat = 0
    private var isForbidScrollDelegate : Bool = false
    weak var delegate : PageContentViewDelegate?
    // MARK : -懒加载属性
    private lazy var collectionView : UICollectionView = {[weak self] in
        // 1. 创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        // 2. 创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView
    }()

    init(frame: CGRect, childVcs : [UIViewController], parentViewController : UIViewController?) {
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK : -设置UI界面
extension PageContentView {
    private func setUpUI(){
        // 1. 将所有子控制器添加到父控制器中
        for childVC in childVcs {
            parentViewController?.addChild(childVC)
        }
        
        // 2. 添加UICollectionView用于在cell中存放控制器的View
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

// MARK : -遵守UICollectionViewDataSource协议
extension PageContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1. 创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        // 2. 给cell设置内容
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childVC = childVcs[indexPath.item]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        
        
        return cell
    }
    
    
}

// MARK : -遵守UICollectionViewDelegate
extension PageContentView : UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 0. 判断是否是点击事件
        if isForbidScrollDelegate { return }
        
        // 1. 定义所需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        // 2. 判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX {
            // 左滑
            // 1. 计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            // 2. 计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            // 3. 计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            
            // 4. 如果完全滑过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        }else {
            // 右滑
            // 1. 计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            // 2. 计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            // 3. 计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
            
        }
        
        // 3. 将progress/sourceIndex/targetIndex传递给titleView
        print("progress\(progress), sourceIndex\(sourceIndex), targetIndex\(targetIndex)")
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

// MARK : -对外暴露的方法
extension PageContentView {
    func setCurrentIndex(currentIndex : Int) {
        // 1. 记录需要执行禁止代理方法
        isForbidScrollDelegate = true
        
        // 2. 滚动到正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}
