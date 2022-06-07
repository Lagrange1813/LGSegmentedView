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
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        configureLayout()
        configureComponents()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        addSubview(displayView)
        addSubview(segmentedController)
        
        segmentedController.translatesAutoresizingMaskIntoConstraints = false
        
        let segmentedControllerConstraints = [
            segmentedController.bottomAnchor.constraint(equalTo: bottomAnchor),
            segmentedController.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedController.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedController.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        segmentedControllerConstraints[3].priority = UILayoutPriority(900)
        
        NSLayoutConstraint.activate(segmentedControllerConstraints)
        
        let displayViewConstraints = [
            displayView.topAnchor.constraint(equalTo: topAnchor),
            displayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            displayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            displayView.bottomAnchor.constraint(equalTo: segmentedController.topAnchor)
        ]
        
        NSLayoutConstraint.activate(displayViewConstraints)
        
        
    }
    
    func configureComponents() {
        print(displayView.frame.width)
        displayView.contentSize = CGSize(width: 1050, height: 260)
        displayView.alwaysBounceVertical = false
        displayView.alwaysBounceHorizontal = true
        displayView.isPagingEnabled = true
        displayView.showsHorizontalScrollIndicator = false
    }
}
