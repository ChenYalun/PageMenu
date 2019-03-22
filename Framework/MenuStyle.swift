//
//  MenuStyle.swift
//  PageMenu
//
//  Created by Chen,Yalun on 2019/3/18.
//  Copyright © 2019 Chen,Yalun. All rights reserved.
//

import UIKit

class MenuStyle: UIView {
    // 标题之间的间距
    var margin: CGFloat = 10
    // 默认颜色
    var defaultColor = UIColor(r: 0, g: 0, b: 0)
    // 默认字体
    var defaultFont = UIFont.systemFont(ofSize: 17)
    // 选中态颜色
    var selectedColor = UIColor(r: 239, g: 154, b: 64)
    // 选中态字体
    var selectedFont = UIFont.systemFont(ofSize: 18)
    
    // 指示条高度, 为0表示隐藏
    var lineHeight: CGFloat = 2
    // 指示条宽度, 为0表示自适应
    var lineWidth: CGFloat = 0
    // 指示条颜色, 默认与selectedColor保持一致
    var lineColor: UIColor?
    // 是否开启指示条颜色渐变
    var lineColorGradual = true
    // 指示条圆角
    var lineCornerRadius: CGFloat = 2
    
    // 标题区的frame
    var pageTitleFrame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 25)
    // 标题区与内容区的间距
    var titleContentMargin: CGFloat = 5
}
