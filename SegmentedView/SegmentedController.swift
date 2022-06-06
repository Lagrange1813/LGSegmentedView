//
//  SegmentedController.swift
//  SegmentedView
//
//  Created by 张维熙 on 2022/6/6.
//

import UIKit

class SegmentedController: UIControl {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
