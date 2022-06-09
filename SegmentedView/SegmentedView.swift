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

enum CountingMode {
    case barFirst
    case viewFirst
    case max
}

public class SegmentedView: UIView {
    var barHeight: CGFloat = 35
    var displayMode: DisplayMode = .bottom
    var countingMode: CountingMode = .barFirst
    
    lazy var displayView = UIScrollView()
    lazy var segmentedBar = SegmentedBar(barHeight: barHeight)
    
    var barItems: [String] {
        didSet {
            segmentedBar.setSegmentItems(barItems)
        }
    }
    
    var views: [UIView] {
        didSet {
            displayView.contentSize = CGSize(width: bounds.width * CGFloat(count),
                                             height: bounds.height - barHeight)
        }
    }
    
    var count: Int {
        var number = 0
        switch countingMode {
        case .barFirst:
            number = barItems.count
        case .viewFirst:
            number = views.count
        case .max:
            number = max(barItems.count, views.count)
        }
        return number
    }
    
    override public var bounds: CGRect {
        didSet {
            displayView.contentSize = CGSize(width: bounds.width * CGFloat(count),
                                             height: bounds.height - barHeight)
        }
    }
    
    public init(frame: CGRect = .zero,
                barItems: [String] = [],
                views: [UIView] = [])
    {
        self.barItems = barItems
        self.views = views
        
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
        addSubview(segmentedBar)
        
        switch displayMode {
        case .top:
            break
        case .bottom:
            segmentedBar.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().inset(20)
                make.bottom.equalToSuperview().inset(10)
                make.height.equalTo(barHeight)
            }
            
            displayView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalTo(segmentedBar.snp.top)
            }
        }
    }
    
    func configureComponents() {
        segmentedBar.setSegmentItems(barItems)
        
        segmentedBar.delegate = self
        
        displayView.alwaysBounceVertical = false
        displayView.alwaysBounceHorizontal = true
        displayView.isPagingEnabled = true
        displayView.showsHorizontalScrollIndicator = false
        displayView.showsVerticalScrollIndicator = false
        
        displayView.delegate = self
        
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

extension SegmentedView: SegmentedBarDelegate {
    func segmentedBarWillStartScroll(_ segmentedBar: SegmentedBar) {
        displayView.isUserInteractionEnabled = false
    }
    
    func segmentedBarDidEndScroll(_ segmentedBar: SegmentedBar) {
        displayView.isUserInteractionEnabled = true
    }
    
    func sliderViewDidMove(_ segmentedBar: SegmentedBar) {
        let width = displayView.contentSize.width
        let proportion = segmentedBar.sliderView.frame.origin.x / segmentedBar.bounds.width
//        print(proportion)
        print(segmentedBar.sliderView.layer.presentation()?.frame.origin.x)
        let position = width * proportion
        displayView.contentOffset = CGPoint(x: position, y: 0)
    }
}

extension SegmentedView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = segmentedBar.bounds.width
        let proportion = scrollView.contentOffset.x / scrollView.contentSize.width
        let position = width * proportion
        segmentedBar.setSliderView(at: position)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        segmentedBar.isUserInteractionEnabled = false
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        segmentedBar.isUserInteractionEnabled = true
    }
}
