//
//  PageTitle.swift
//  PageMenu
//
//  Created by Chen,Yalun on 2019/3/18.
//  Copyright © 2019 Chen,Yalun. All rights reserved.
//

import UIKit

// 代理
protocol PageTitleDelegate : class {
    func pageTitleDidSelected(pageTitle: PageTitle, pageTitleView: PageTitleView)
}



// 标题视图组件
class PageTitleView: UIView {
    // 索引
    var index: Int = 0
    // 标题
    var title: String?
    // 渐变颜色
    var color: UIColor? {
        didSet {
            label.textColor = color
        }
    }
    // 样式
    fileprivate var style: MenuStyle
    // 选中状态
    fileprivate var isSelected: Bool = false {
        didSet { reloadState() }// 刷新数据
    }
    // 自身宽度
    fileprivate var width: CGFloat {
        return title?.size(withAttributes: [NSAttributedString.Key.font: font]).width ?? 0
    }
    // 字体大小
    fileprivate var font: UIFont { return isSelected ? style.selectedFont : style.defaultFont }
    // 字体颜色
    fileprivate var fontColor: UIColor { return isSelected ? style.selectedColor : style.defaultColor }
    // 点击回调
    fileprivate var tapCallBack: ((_ view: PageTitleView) -> Void)?
    private lazy var label: UILabel = {
        let label = UILabel()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(action(_:)))
        label.addGestureRecognizer(gesture)
        label.isUserInteractionEnabled = true
        return label
    }()
    init(title: String?, isSelected: Bool, style: MenuStyle) {
        self.title = title
        self.isSelected = isSelected
        self.style = style
        super.init(frame: CGRect.zero)
        reloadState()
        self.addSubview(label)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 动态链接
    @objc fileprivate func action(_ tap: UITapGestureRecognizer) {
        if tapCallBack != nil {
            tapCallBack!(self)
        }
    }
    // 刷新数据
    private func reloadState() {
        label.text = title
        label.textColor = fontColor
        label.font = font
        label.sizeToFit()
    }
}



// 标题视图
class PageTitle: UIView {
    // 代理
    weak var delegate: PageTitleDelegate?
    private var titleList: [String]
    private lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView(frame: bounds)
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        return scrollView
    }()
    // 指示器
    private lazy var lineView: UIView = {
        var lineView = UIView()
        lineView.backgroundColor = menuStyle.lineColor ?? menuStyle.selectedColor
        lineView.layer.cornerRadius = menuStyle.lineCornerRadius
        lineView.layer.masksToBounds = true
        scrollView.addSubview(lineView)
        return lineView
    }()
    // 样式
    private var menuStyle: MenuStyle
    // 当前选中标题
    private var currentSelectedView: PageTitleView?
    // 标题列表
    private var titleViewList = [PageTitleView]()
    init(frame: CGRect, menuStyle: MenuStyle, titleList: [String]) {
        self.menuStyle = menuStyle
        self.titleList = titleList
        super.init(frame: frame)
        setupSubViews()
    }
    private func setupSubViews() {
        var totalWidth: CGFloat = 0
        // 设置子控件
        for (idx, title) in titleList.enumerated() {
            let view = PageTitleView(title: title as String, isSelected: false, style: menuStyle)
            view.index = idx
            titleViewList.append(view)
            let x = CGFloat(idx + 1) * menuStyle.margin + totalWidth
            view.frame = CGRect(x: x, y: 0, width: view.width, height: frame.height - menuStyle.lineHeight)
            totalWidth += view.width
            scrollView.addSubview(view)
            view.tapCallBack = { [weak self] view in
                guard let self = self else { return }
                self.changeToSelectedIndex(idx: view.index)
            }
        }
        scrollView.contentSize = CGSize(width: totalWidth + CGFloat(titleList.count + 1) * menuStyle.margin, height: 0)
        // 默认选中的索引 0
        changeToSelectedIndex()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// MARK: 切换过程中需要调用的函数
extension PageTitle {
    private func changeToSelectedIndex(idx: Int = 0, progress: CGFloat = 1) {
        // 索引值越界
        if idx > titleViewList.count - 1 || idx < 0 || titleViewList.count <= 0 { return }
        var fromView, toView: PageTitleView
        if currentSelectedView == nil {
            fromView = titleViewList.first!
            toView = fromView
        } else {
            fromView = currentSelectedView!
            toView = titleViewList[idx]
            // 同一个标题
            if fromView == toView { return }
        }
        if menuStyle.lineHeight != 0 {
            refreshBottomLineFrame(fromView.frame, toView.frame, progress)
        }
        if menuStyle.lineColorGradual {
            refreshTitleViewColor(fromView, toView, progress)
        }
        if progress == 1 {
            refreshTitleViewState(fromView, toView)
        }
    }
    // 设置指示条frame
    private func refreshBottomLineFrame(_ from: CGRect, _ to: CGRect, _ progress: CGFloat) {
        var from = from
        var to = to
        let lineHeight = menuStyle.lineHeight
        let lineWidth = menuStyle.lineWidth
        let y = frame.height - lineHeight
        let isFixedLineWidth = lineWidth != 0
        let fromWidth = isFixedLineWidth ? lineWidth : from.width
        let toWidth = isFixedLineWidth ? lineWidth : to.width
        let fromMinX = isFixedLineWidth ? from.midX - lineWidth * 0.5 : from.minX
        let fromMaxX = isFixedLineWidth ? fromMinX + lineWidth : from.maxX
        let toMinX = isFixedLineWidth ? to.midX - lineWidth * 0.5 : to.minX
        let toMaxX = isFixedLineWidth ? toMinX + lineWidth : to.maxX
        from = CGRect(x: fromMinX, y: y, width: fromWidth, height: lineHeight)
        to = CGRect(x: toMinX, y: y, width: toWidth, height: lineHeight)
        let isToLeft = toMinX < fromMinX // 向左
        if progress < 0.5 {
            if isToLeft { // 向左移动
                let offsetWidth = (fromMinX - toMinX) * 2 * progress
                lineView.frame = CGRect(x: fromMinX - offsetWidth, y: y, width:  fromMaxX - fromMinX + offsetWidth, height: lineHeight)
            } else {
                let offsetWidth = (toMaxX - fromMaxX) * 2 * progress
                lineView.frame = CGRect(x: fromMinX, y: y, width:from.width + offsetWidth, height: lineHeight)
            }
        } else {
            if isToLeft { // 向左移动
                let offsetWidth = (fromMaxX - to.maxX) * (1 - (progress - 0.5) * 2)
                lineView.frame = CGRect(x: toMinX, y: y, width:to.width + offsetWidth, height: lineHeight)
            } else {
                let offsetWidth = (toMinX - fromMinX) * (1 - (progress - 0.5) * 2)
                lineView.frame = CGRect(x: toMinX - offsetWidth, y: y, width:toMaxX - toMinX + offsetWidth, height: lineHeight)
            }
        }
    }
    // 刷新标题状态
    private func refreshTitleViewState(_ fromView: PageTitleView, _ toView: PageTitleView) {
        // 更新currentSelectedView
        currentSelectedView?.isSelected = false
        toView.isSelected = true
        currentSelectedView = toView
        
        // 设置标题居中
        let width = scrollView.bounds.width
        let contentWidth = scrollView.contentSize.width
        var offsetX = toView.center.x - width * 0.5
        offsetX = max(offsetX, 0)
        offsetX = min(contentWidth - width, offsetX)
        if contentWidth <= width { // 保持居中
            let viewWidth = CGFloat(titleViewList.last?.frame.maxX ?? 0) - CGFloat(titleViewList.first?.frame.minX ?? 0)
            offsetX = -(width - viewWidth) * 0.5 + menuStyle.margin
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        if delegate != nil {
            delegate?.pageTitleDidSelected(pageTitle: self, pageTitleView: toView)
        }
    }
    // 标题颜色渐变
    private func refreshTitleViewColor(_ fromView: PageTitleView, _ toView: PageTitleView, _ progress: CGFloat) {
        let toRGB = UIColor.rgbValue(menuStyle.selectedColor)
        let fromRGB = UIColor.rgbValue(menuStyle.defaultColor)
        let deltaRGB = (toRGB.0 - fromRGB.0, toRGB.1 - fromRGB.1, toRGB.2 - fromRGB.2)
        fromView.color = UIColor(r: toRGB.0 - deltaRGB.0 * progress, g: toRGB.1 - deltaRGB.1 * progress, b: toRGB.2 - deltaRGB.2 * progress)
        toView.color = UIColor(r: fromRGB.0 + deltaRGB.0 * progress, g: fromRGB.1 + deltaRGB.1 * progress, b: fromRGB.2 + deltaRGB.2 * progress)
    }
}



// MARK: PageContentDelegate
extension PageTitle : PageContentDelegate {
    func pageContentDidChange(pageContent: PageContent, targetIndex: Int, progress: CGFloat) {
        changeToSelectedIndex(idx: targetIndex, progress: progress)
    }
}
