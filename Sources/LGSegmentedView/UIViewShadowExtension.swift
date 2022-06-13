//
//  UIViewShadowExtension.swift
//  LGSegmentedView
//
//  Created by 张维熙 on 2022/6/7.
//

import UIKit

extension UIView {
    func addShadow(with color: UIColor) {
        layer.shadowColor = color.cgColor
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }

    func removeShadow() {
        layer.shadowOpacity = 0
    }
}
