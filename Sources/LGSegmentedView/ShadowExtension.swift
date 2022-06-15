//
//  ShadowExtension.swift
//  LGSegmentedView
//
//  Created by 张维熙 on 2022/6/7.
//

import UIKit

extension UIView {
    func addShadow(_ color: UIColor, style: LGSegmentedBarStyle = .modern) {
        switch style {
        case .modern:
            
            layer.shadowColor = color.cgColor
            layer.shadowRadius = 8
            layer.shadowOpacity = 0.7
            layer.shadowOffset = CGSize(width: 0, height: 5)
            
        case .classical:
            
            layer.shadowColor = color.cgColor
            layer.shadowRadius = 0.5
            layer.shadowOpacity = 0.5
            layer.shadowOffset = CGSize(width: 0, height: 0)
            
        case .imprint:
            
            break
        }
    }

    func removeShadow() {
        layer.shadowOpacity = 0
    }
}
