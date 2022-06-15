//
//  UIColor+Extension.swift
//  LGSegmentedView
//
//  Created by 张维熙 on 2022/6/15.
//

import UIKit

extension UIColor {

    static func dynamicColor(_ lightColor: UIColor, darkColor: UIColor = UIColor.white)  -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.init { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .light {
                    return lightColor
                }else{
                    return darkColor
                }
            }
        } else {
            return lightColor
        }
    }
}
