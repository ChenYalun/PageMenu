//
//  PageMenu.swift
//  PageMenu
//
//  Created by Chen,Yalun on 2019/3/19.
//  Copyright © 2019 Chen,Yalun. All rights reserved.
//

import Foundation
import UIKit

class PageMenu : UIViewController {
    var pageTitle: PageTitle
    var pageContent: PageContent
    var menuStyle: MenuStyle
    private var controllerList: [UIViewController]
    init(_ menuStyle: MenuStyle, _ controllerList: [UIViewController]) {
        var titleList = [String]()
        for controller in controllerList {
            titleList.append(controller.title ?? "null")
        }
        self.pageTitle = PageTitle(frame: menuStyle.pageTitleFrame, menuStyle: menuStyle, titleList: titleList)
        self.pageContent = PageContent(frame: CGRect(x: pageTitle.frame.minX, y: pageTitle.frame.maxY + menuStyle.titleContentMargin, width: pageTitle.frame.width, height: UIScreen.main.bounds.height - pageTitle.frame.height), controllerList: controllerList)
        self.menuStyle = menuStyle
        self.controllerList = controllerList
        super.init(nibName: nil, bundle: nil)
        configureComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureComponent() {
        view.addSubview(pageTitle)
        view.addSubview(pageContent)
        for controller in controllerList {
            addChild(controller)
        }
        pageTitle.delegate = pageContent
        pageContent.delegate = pageTitle
    }
}
