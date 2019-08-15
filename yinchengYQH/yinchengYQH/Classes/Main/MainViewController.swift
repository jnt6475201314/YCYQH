//
//  MainViewController.swift
//  yinchengYQH
//
//  Created by jnt on 2019/8/15.
//  Copyright © 2019 qirong. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 如果需要支持iOS9以前的系统，需要使用这种方式添加tabbar的子控制器
//        addchildVC(storyName: "Home")
//        addchildVC(storyName: "Bill")
//        addchildVC(storyName: "Mine")
        
    }
    
    private func addchildVC(storyName : String) {
        // 1. 通过storyboard获取控制器
        let childVC = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        
        // 2. 将childVC作为子控制器
        addChild(childVC)
    }

}
