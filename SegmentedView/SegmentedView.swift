//
//  SegmentedView.swift
//  SegmentedView
//
//  Created by 张维熙 on 2022/6/6.
//

import UIKit

public class SegmentedView: UIView {
    let displayView = UIScrollView()
    let segmentedController = SegmentedController()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(displayView)
        addSubview(segmentedController)
        
        let segmentedControllerConstraints = [
            segmentedController.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            segmentedController.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            segmentedController.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            segmentedController.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        NSLayoutConstraint.activate(segmentedControllerConstraints)
        
        let displayViewConstraints = [
            displayView.topAnchor.constraint(equalTo: self.topAnchor),
            displayView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            displayView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            displayView.bottomAnchor.constraint(equalTo: segmentedController.topAnchor)
        ]
        
        NSLayoutConstraint.activate(displayViewConstraints)
        
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
    }
}
