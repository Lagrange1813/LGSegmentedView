//
//  SegmentedView.swift
//  SegmentedView
//
//  Created by 张维熙 on 2022/6/6.
//

import SnapKit
import UIKit

enum DisplayMode {
    case top
    case bottom
}

public class SegmentedView: UIView {
    let displayView = UIScrollView()
    let segmentedController = SegmentedController()
    
    var pageCount: CGFloat = 3
    var controllerHeight: CGFloat = 35
    
    override public var bounds: CGRect {
        didSet {
            displayView.contentSize = CGSize(width: bounds.width * pageCount,
                                             height: bounds.height - controllerHeight)
        }
    }
    
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
        
        segmentedController.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(35)
        }
        
        displayView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(segmentedController.snp.top)
        }
    }
    
    func configureComponents() {
        print(displayView.frame.width)
        displayView.alwaysBounceVertical = false
        displayView.alwaysBounceHorizontal = true
        displayView.isPagingEnabled = true
        displayView.showsHorizontalScrollIndicator = false
        displayView.showsVerticalScrollIndicator = false
        
        let titles = ["First", "Second", "Third"]
        segmentedController.setSegmentItems(titles)
        
        let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        label1.text = "Label1"
        displayView.addSubview(label1)
        
        let label2 = UILabel(frame: CGRect(x: 350, y: 0, width: 50, height: 50))
        label2.text = "Label2"
        displayView.addSubview(label2)
        
        let label3 = UILabel(frame: CGRect(x: 700, y: 0, width: 50, height: 50))
        label3.text = "Label3"
        displayView.addSubview(label3)
    }
}
