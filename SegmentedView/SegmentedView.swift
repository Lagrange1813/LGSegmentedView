//
//  SegmentedView.swift
//  SegmentedView
//
//  Created by 张维熙 on 2022/6/6.
//

import SnapKit
import UIKit

public class SegmentedView: UIView {
    public var barHeight: CGFloat = 35
    public var displayMode: SegmentedViewDisplayMode = .bottom
    public var countingMode: SegmentedViewCountingMode = .barFirst
    
    public var currentIndex: Int = 0 {
        didSet {
            print(currentIndex)
        }
    }
    
    private lazy var displayView = UIScrollView()
    private lazy var segmentedBar = SegmentedBar(barHeight: barHeight)
    
    private var area: MovingArea = .undefined
    
    private var barItems: [String] {
        didSet {
            segmentedBar.setSegmentItems(barItems)
        }
    }
    
    private var views: [UIView] {
        didSet {
            placeViews(with: bounds)
        }
    }
    
    private var count: Int {
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
                                             height: bounds.height - barHeight - 10)
            placeViews(with: bounds)
            displayView.contentOffset = CGPoint(x: bounds.width * CGFloat(currentIndex), y: 0)
//            print(currentIndex)
//            print(segmentedBar.selectedIndex)
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
    
    private func configureLayout() {
        addSubview(displayView)
        addSubview(segmentedBar)
        
        switch displayMode {
        case .top:
            
            segmentedBar.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().inset(20)
                make.top.equalToSuperview().offset(10)
                make.height.equalTo(barHeight)
            }
            
            displayView.snp.makeConstraints { make in
                make.top.equalTo(segmentedBar.snp.bottom)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
        case .bottom:
            
            segmentedBar.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().inset(20)
                make.bottom.equalToSuperview().inset(5)
                make.height.equalTo(barHeight)
            }
            
            displayView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalTo(segmentedBar.snp.top).offset(-5)
            }
        }
    }
    
    private func configureComponents() {
        segmentedBar.setSegmentItems(barItems)
        
        segmentedBar.delegate = self
        
        displayView.alwaysBounceHorizontal = true
        displayView.alwaysBounceVertical = false
        displayView.isPagingEnabled = true
        displayView.showsHorizontalScrollIndicator = false
        displayView.showsVerticalScrollIndicator = false
        
        placeViews(with: bounds)
        
        displayView.delegate = self
        
//        let label1 = UILabel(frame: CGRect(x: 0, y: 10, width: 80, height: 50))
//        label1.text = "Label1"
//        displayView.addSubview(label1)
//
//        let label2 = UILabel(frame: CGRect(x: 350, y: 10, width: 80, height: 50))
//        label2.text = "Label2"
//        displayView.addSubview(label2)
//
//        let label3 = UILabel(frame: CGRect(x: 700, y: 10, width: 80, height: 50))
//        label3.text = "Label3"
//        displayView.addSubview(label3)
    }
    
    private func placeViews(with bounds: CGRect) {
        guard !views.isEmpty else { return }
        
        let size = CGSize(width: bounds.width,
                          height: bounds.height - barHeight - 10)
        
        views[0].frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        displayView.addSubview(views[0])
        
        for (index, view) in views.enumerated().dropFirst().dropLast(views.count - count) {
            let rect = CGRect(x: bounds.width * CGFloat(index),
                              y: 0,
                              width: size.width,
                              height: size.height)
            view.frame = rect
            displayView.addSubview(view)
        }
    }
}

public extension SegmentedView {
    func addSubView(_ subview: UIView, at index: Int) {
        guard index >= 0, index < count else { fatalError("Out of index") }
        
        addSubview(subview)
        subview.frame.origin.x = xOffset(at: index)
    }
    
    private func xOffset(at index: Int) -> CGFloat {
        bounds.width * CGFloat(index)
    }
}

extension SegmentedView: SegmentedBarDelegate {
    func segmentedBarWillStartScroll(_ segmentedBar: SegmentedBar) {
        displayView.isUserInteractionEnabled = false
        segmentedBar.isUserInteractionEnabled = false
        area = .segmentedBar
    }
    
    func segmentedBarDidEndScroll(_ segmentedBar: SegmentedBar) {
        displayView.isUserInteractionEnabled = true
        segmentedBar.isUserInteractionEnabled = true
        area = .undefined
        currentIndex = segmentedBar.selectedIndex
    }
    
    func sliderViewDidMove(_ segmentedBar: SegmentedBar) {
        guard area == .segmentedBar else { return }
        
        let width = displayView.contentSize.width
        let proportion = (segmentedBar.sliderView.layer.presentation()?.frame.origin.x ?? 0) / segmentedBar.bounds.width
        let position = width * proportion
        displayView.contentOffset = CGPoint(x: position, y: 0)
    }
}

extension SegmentedView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard area == .displayView else { return }
        
        let width = segmentedBar.bounds.width
        let proportion = scrollView.contentOffset.x / scrollView.contentSize.width
        let position = width * proportion
        segmentedBar.setSliderView(at: position)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        segmentedBar.isUserInteractionEnabled = false
        area = .displayView
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        segmentedBar.isUserInteractionEnabled = true
        area = .undefined
        currentIndex = segmentedBar.selectedIndex
    }
}
