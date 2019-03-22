//
//  UIColor+RGB.swift
//  PageMenu
//
//  Created by Chen,Yalun on 2019/3/19.
//  Copyright © 2019 Chen,Yalun. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    class func rgbValue(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        guard let components = color.cgColor.components else {
            fatalError("颜色按照RGB设置")
        }
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
}
