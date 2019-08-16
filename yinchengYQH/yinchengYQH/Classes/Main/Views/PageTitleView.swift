//
//  PageTitleView.swift
//  yinchengYQH
//
//  Created by jnt on 2019/8/15.
//  Copyright © 2019 qirong. All rights reserved.
//

import UIKit

// MARK : -定义协议
protocol PageTitleViewDelegate : class {
    func pageTitleView(titleView : PageTitleView, selectedIndex index : Int)
}

// MARK : -定义常量
private let KScrollLineH : CGFloat = 2
private let KNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let KSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

class PageTitleView: UIView {
    // MARK : -定义属性
    private var titles : [String]
    private var currentIndex : Int = 0
    weak var delegate : PageTitleViewDelegate?
    // MARK : -懒加载属性
    private lazy var titleLabels : [UILabel] = [UILabel]()
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = false
        scrollView.bounces = false
        return scrollView
    }()
    private lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()

    // MARK : - 自定义构造函数
    init(frame : CGRect, titles : [String]) {
        self.titles = titles
        
        super.init(frame : frame)
        
        // 设置UI界面
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PageTitleView {
    private func setUpUI (){
        // 1. 添加scrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        // 2. 添加title对应的label
        setUpTitleLabels()
        
        // 3. 设置底线和滚动的滑块
        setUpBottomMenuAndScrollLine()
    }
    
    private func setUpTitleLabels() {
        // 0. 确定label的frame值
        let labelW : CGFloat = frame.width / CGFloat(titles.count)
        let labelH : CGFloat = frame.height - KScrollLineH
        let labelY : CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            // 1. 创建UILabel
            let label = UILabel()
            
            // 2. 设置label属性
            label.text = title
            label.textAlignment = .center
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 15*widthScale)
            label.textColor = UIColor(r: KNormalColor.0, g: KNormalColor.1, b: KNormalColor.2)
            
            // 3. 设置label的frame
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            // 4. 将label添加到scrollView中
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            // 5. 给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelChick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    private func setUpBottomMenuAndScrollLine () {
        // 1. 添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height-lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        // 2. 添加ScrollLine
        // 2.1 获取第一个label，设置scrllLine的宽度
        guard let firstLabel = titleLabels.first else{ return }
        firstLabel.textColor = UIColor(r: KSelectColor.0, g: KSelectColor.1, b: KSelectColor.2)
        // 2.2 设置scrollLine的属性
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height-KScrollLineH, width: firstLabel.frame.width, height: KScrollLineH)
    }
}

// MARK : -监听label的点击事件
extension PageTitleView {
    @objc private func titleLabelChick(tapGes : UITapGestureRecognizer) {
        // 1. 获取当前label
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        // 2. 获取之前label
        let oldLabel = titleLabels[currentIndex]
        
        // 3. 切换文字的颜色
        currentLabel.textColor = UIColor(r: KSelectColor.0, g: KSelectColor.1, b: KSelectColor.2)
        oldLabel.textColor = UIColor(r: KNormalColor.0, g: KNormalColor.1, b: KNormalColor.2)
        
        // 4. 保存最新的下标值
        currentIndex = currentLabel.tag
        
        // 5. 滚动条的位置改变
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        // 6. 通知代理
        delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
    }
}


// MARK : -对外暴露的方法
extension PageTitleView {
    func setTitleWithProgress(progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        // 1. 取出source对应的label
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2. 处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        // 3. 处理label文字的颜色渐变(复杂)
        // 3.1 取出变化的范围
        let colorDelta = (KSelectColor.0 - KNormalColor.0, KSelectColor.1 - KNormalColor.1, KSelectColor.2 - KNormalColor.2)
        // 3.2 变化sourceLabel
        sourceLabel.textColor = UIColor(r: KSelectColor.0 - colorDelta.0 * progress, g: KSelectColor.1 - colorDelta.1 * progress, b: KSelectColor.2 - colorDelta.2 * progress)
        // 3.3 变化targetLabel
        targetLabel.textColor = UIColor(r: KNormalColor.0 + colorDelta.0*progress, g: KNormalColor.1 + colorDelta.1*progress, b: KNormalColor.2 + colorDelta.2*progress)
        
        // 4. 记录最新的targetIndex
        currentIndex = targetIndex
    }
}
