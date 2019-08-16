//
//  Common.swift
//  yinchengYQH
//
//  Created by jnt on 2019/8/15.
//  Copyright © 2019 qirong. All rights reserved.
//

import UIKit

// 获取屏幕的宽度
let KScreenWidth = UIScreen.main.bounds.width
// 获取屏幕的高度
let KScreenHeight = UIScreen.main.bounds.height
// 获取屏幕的bounds
let KScreenBounds = UIScreen.main.bounds

let widthScale = (KScreenWidth/375)


//iPhoneX / iPhoneXS
let  isIphoneX_XS = (KScreenWidth == 375.0 && KScreenHeight == 812.0 ? true : false)
//iPhoneXR / iPhoneXSMax
let  isIphoneXR_XSMax = (KScreenWidth == 414.0 && KScreenHeight == 896.0 ? true : false)
//异性全面屏
let   isFullScreen = (isIphoneX_XS || isIphoneXR_XSMax)

//let IS_IPHONE_X =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1125, height: 2436).equalTo((UIScreen.main.currentMode?.size)!) : false)

// 获取状态栏高度
let KStatus_Bar_Height : CGFloat = (isFullScreen ? 44 : 22)
// 获取NavBar高度
let KNavigation_Bar_Height : CGFloat = (isFullScreen ? 88 : 64)
// 获取底部tab高度
let Tab_Bar_Height : CGFloat = (isFullScreen ? 83 : 49)





