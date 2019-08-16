//
//  BillViewController.swift
//  yinchengYQH
//
//  Created by jnt on 2019/8/15.
//  Copyright © 2019 qirong. All rights reserved.
//

import UIKit

// pageTitleView 的高度
let KPageTitleViewH : CGFloat = 50

class BillViewController: UIViewController {
    
    // MARK : - 懒加载属性
    fileprivate lazy var pageTitleView : PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: KNavigation_Bar_Height, width: KScreenWidth, height: KPageTitleViewH)
        let titles = ["待完成账单", "待还款账单", "已完成账单", "失败账单"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        
        return titleView
    }()
    private lazy var pageContentView : PageContentView = {[weak self] in
        // 1. 确定内容的frame
        let contentHeight = KScreenHeight - KNavigation_Bar_Height - KPageTitleViewH
        let contentFrame = CGRect(x: 0, y: KNavigation_Bar_Height + KPageTitleViewH, width: KScreenWidth, height: contentHeight)
        // 2. 确定所有的子控制器
        var childVcs = [UIViewController]()
        childVcs = [UnfinishedBillViewController(), NoReimbursementViewController(), FinishedBillViewController(), FailedBillViewController()]
        for vc in childVcs{
            vc.view.backgroundColor = UIColor.white
            childVcs.append(vc)
        }
        let pageContentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        pageContentView.delegate = self
        
        return pageContentView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK : - 设置UI界面
        configUI()
    }

}

// MARK : -设置UI界面
extension BillViewController {
    private func configUI () {
        // 不需要调整UIScrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
        
        // 1. 添加titleView
        view.addSubview(pageTitleView)
        
        // 2. 添加contentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.purple
    }
}

// MARK : -遵守PageTitleViewDelegate协议
extension BillViewController : PageTitleViewDelegate {
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}

// MARK : -遵守PageContentViewDelegate协议
extension BillViewController : PageContentViewDelegate {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
