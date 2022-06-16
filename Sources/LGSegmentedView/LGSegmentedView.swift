//
//  LGSegmentedView.swift
//  LGSegmentedView
//
//  Created by 张维熙 on 2022/6/6.
//

import UIKit

open class LGSegmentedView: UIView {
    public var barHeight: CGFloat
    public var displayMode: LGSegmentedViewDisplayMode
    public var countingMode: LGSegmentedViewCountingMode
    public var barStyle: LGSegmentedBarStyle
    
    public var currentIndex: Int {
        _currentIndex
    }
    
    public var backLayers: [UIView] = []
    
    private var _currentIndex: Int = 0
    
    private lazy var displayView = UIScrollView()
    private lazy var segmentedBar = SegmentedBar(barHeight: barHeight, barStyle: barStyle)
    
    private var area: MovingArea = .undefined
    
    private var segmentTexts: [String] {
        didSet {
            segmentedBar.setSegmentItems(segmentTexts)
        }
    }
    
    private var segmentImages: [UIImage] {
        didSet {
            segmentedBar.setSegmentItems(segmentImages)
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
            number = max(segmentTexts.count, segmentImages.count)
        case .viewFirst:
            number = views.count
        case .max:
            number = max(segmentTexts.count, views.count)
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
                config: LGSegmentedViewConfiguration = .init(),
                segmentTexts: [String] = [],
                segmentImages: [UIImage] = [],
                views: [UIView] = [])
    {
        self.barHeight = config.barHeight
        self.countingMode = config.countingMode
        self.displayMode = config.displayMode
        self.barStyle = config.barStyle
        
        self.segmentTexts = segmentTexts
        self.segmentImages = segmentImages
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
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        addSubview(displayView)
        addSubview(segmentedBar)
        
        switch displayMode {
        case .top:
            
            segmentedBar.translatesAutoresizingMaskIntoConstraints = false
            displayView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                segmentedBar.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                segmentedBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                segmentedBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                segmentedBar.heightAnchor.constraint(equalToConstant: barHeight)
            ])
            
            NSLayoutConstraint.activate([
                displayView.topAnchor.constraint(equalTo: segmentedBar.bottomAnchor, constant: 5),
                displayView.leadingAnchor.constraint(equalTo: leadingAnchor),
                displayView.bottomAnchor.constraint(equalTo: bottomAnchor),
                displayView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
            
        case .bottom:
            
            segmentedBar.translatesAutoresizingMaskIntoConstraints = false
            displayView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                segmentedBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
                segmentedBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                segmentedBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                segmentedBar.heightAnchor.constraint(equalToConstant: barHeight)
            ])
            
            NSLayoutConstraint.activate([
                displayView.topAnchor.constraint(equalTo: topAnchor),
                displayView.leadingAnchor.constraint(equalTo: leadingAnchor),
                displayView.bottomAnchor.constraint(equalTo: segmentedBar.topAnchor, constant: -5),
                displayView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
    }
    
    private func configureComponents() {
        segmentedBar.setSegmentItems(segmentTexts)
        segmentedBar.setSegmentItems(segmentImages)
        
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
        
        for (index, view) in views.enumerated().dropLast(max(views.count - count, 0)) {
            backLayers[index].addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: backLayers[index].topAnchor),
                view.leadingAnchor.constraint(equalTo: backLayers[index].leadingAnchor),
                view.bottomAnchor.constraint(equalTo: backLayers[index].bottomAnchor),
                view.trailingAnchor.constraint(equalTo: backLayers[index].trailingAnchor)
            ])
        }
    }
    
    open func setSegmentItems<T> (_ raws: [T]) {
        segmentedBar.setSegmentItems(raws)
    }
    
    open func setSegmentViews (_ views: [UIView]) {
        
    }
}

public extension LGSegmentedView {
    func addSubView(_ subview: UIView, at index: Int) {
        guard index >= 0, index < count else { fatalError("Out of index") }
        
        addSubview(subview)
        subview.frame.origin.x = xOffset(at: index)
    }
    
    private func xOffset(at index: Int) -> CGFloat {
        bounds.width * CGFloat(index)
    }
}

extension LGSegmentedView: SegmentedBarDelegate {
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

extension LGSegmentedView: UIScrollViewDelegate {
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
