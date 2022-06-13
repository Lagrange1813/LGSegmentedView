//
//  SegmentedView.swift
//  SegmentedView
//
//  Created by 张维熙 on 2022/6/6.
//

import UIKit
import SnapKit

public class SegmentedView: UIView {
    public var barHeight: CGFloat = 35
    public var displayMode: SegmentedViewDisplayMode = .top
    public var countingMode: SegmentedViewCountingMode = .barFirst
    
    public var currentIndex: Int {
        _currentIndex
    }
    
    public var backLayers: [UIView] = []
    
    private var _currentIndex: Int = 0
    
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
            layoutViews()
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
            placeBackLayer(with: bounds)
            displayView.contentOffset = CGPoint(x: bounds.width * CGFloat(_currentIndex), y: 0)
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
        
        for _ in 0..<count {
            let layer = UIView()
            backLayers.append(layer)
            displayView.addSubview(layer)
        }
        
        layoutViews()
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
            
//            NSLayoutConstraint.activate([
//                segmentedBar.topAnchor.constraint(equalTo: topAnchor, constant: 5),
//                segmentedBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//                segmentedBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//                segmentedBar.heightAnchor.constraint(equalToConstant: barHeight)
//            ])
            
            segmentedBar.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().inset(20)
                make.top.equalToSuperview().offset(5)
                make.height.equalTo(barHeight)
            }
            
//            NSLayoutConstraint.activate([
//                displayView.topAnchor.constraint(equalTo: segmentedBar.bottomAnchor, constant: 5),
//                displayView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//                displayView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//                displayView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
//            ])
            
            displayView.snp.makeConstraints { make in
                make.top.equalTo(segmentedBar.snp.bottom).offset(5)
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
        
        displayView.delegate = self
    }
    
    private func placeBackLayer(with currentBounds: CGRect) {
        guard count != 0 else { return }
        
        let size = CGSize(width: currentBounds.width,
                          height: currentBounds.height - barHeight - 10)
        
        backLayers[0].frame = CGRect(x: 0, y: 0,
                                     width: size.width,
                                     height: size.height)
        
        for index in 1..<count {
            let rect = CGRect(x: bounds.width * CGFloat(index),
                              y: 0,
                              width: size.width,
                              height: size.height)
            backLayers[index].frame = rect
        }
    }
    
    private func layoutViews() {
        guard !views.isEmpty else { return }
        
        for (index, view) in views.enumerated().dropLast(views.count - count) {
            backLayers[index].addSubview(view)
            
            view.snp.makeConstraints { make in
                make.top.leading.trailing.bottom.equalToSuperview()
            }
            
//            NSLayoutConstraint.activate([
//                view.topAnchor.constraint(equalTo: backLayers[index].topAnchor),
//                view.leadingAnchor.constraint(equalTo: backLayers[index].leadingAnchor),
//                view.bottomAnchor.constraint(equalTo: backLayers[index].bottomAnchor),
//                view.trailingAnchor.constraint(equalTo: backLayers[index].trailingAnchor)
//            ])
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
        _currentIndex = segmentedBar.selectedIndex
    }
    
    func sliderViewDidMove(_ segmentedBar: SegmentedBar) {
        guard area != .displayView else { return }
        
        let width = displayView.contentSize.width
        let proportion = (segmentedBar.sliderView.layer.presentation()?.frame.origin.x ?? 0) / segmentedBar.bounds.width
        let position = width * proportion
        displayView.contentOffset = CGPoint(x: position, y: 0)
    }
}

extension SegmentedView: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        segmentedBar.isUserInteractionEnabled = false
        area = .displayView
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        segmentedBar.isUserInteractionEnabled = true
        area = .undefined
        _currentIndex = segmentedBar.selectedIndex
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard area != .segmentedBar else { return }
        
        let width = segmentedBar.bounds.width
        let proportion = scrollView.contentOffset.x / scrollView.contentSize.width
        let position = width * proportion
        segmentedBar.setSliderView(at: position)
    }
}
