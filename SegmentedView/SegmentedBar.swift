//
//  SegmentedBar.swift
//  SegmentedView
//
//  Created by 张维熙 on 2022/6/6.
//

import UIKit

@objc protocol SegmentedBarDelegate {
    func segmentedIndexDidChange()
}

class SegmentedBar: UIControl {
    private var height: CGFloat

    override var bounds: CGRect {
        didSet {
            updateViewLayout(with: bounds.width)
        }
    }

    init(frame: CGRect = .zero, barHeight: CGFloat) {
        self.height = barHeight
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open var defaultTextColor: UIColor = Palette.defaultTextColor {
        didSet {
            updateLabelsColor(with: defaultTextColor, selected: false)
        }
    }

    open var highlightTextColor: UIColor = Palette.highlightTextColor {
        didSet {
            updateLabelsColor(with: highlightTextColor, selected: true)
        }
    }

    open var segmentsBackgroundColor: UIColor = Palette.segmentedControlBackgroundColor {
        didSet {
            backgroundView.backgroundColor = segmentsBackgroundColor
        }
    }

    open var sliderBackgroundColor: UIColor = Palette.sliderColor {
        didSet {
            selectedView.backgroundColor = sliderBackgroundColor
            if !isSliderShadowHidden { selectedView.addShadow(with: sliderBackgroundColor) }
        }
    }

    open var font: UIFont = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium) {
        didSet {
            updateLabelsFont(with: font)
        }
    }

    open var isSliderShadowHidden: Bool = false {
        didSet {
            updateShadow(with: sliderBackgroundColor, hidden: isSliderShadowHidden)
        }
    }

    private var selectedSegmentIndex: Int = 0

    private var segments: [String] = []

    private var numberOfSegments: Int {
        return segments.count
    }

    private var segmentWidth: CGFloat {
        return backgroundView.frame.width / CGFloat(numberOfSegments)
    }

    private var correction: CGFloat = 0

    private lazy var containerView = UIView()
    private lazy var backgroundView = UIView()
    private lazy var selectedView = UIView()
    private lazy var sliderView = SliderView()
    
    weak var delegate: SegmentedBarDelegate?

    private func configure() {
        addSubview(containerView)
        containerView.addSubview(backgroundView)
        containerView.addSubview(selectedView)
        containerView.addSubview(sliderView)

        selectedView.layer.mask = sliderView.sliderMaskView.layer
        addTapGesture()
        addDragGesture()
    }

    func setSegmentItems(_ segments: [String]) {
        guard !segments.isEmpty else { fatalError("Segments array cannot be empty") }

        self.segments = segments
        configureViews()

        removeLabels()

        var backgroundLabels: [UILabel] = []
        var selectedLabels: [UILabel] = []

        let firstBackgroundLabel = createLabel(with: segments[0], selected: false)
        backgroundView.addSubview(firstBackgroundLabel)
        firstBackgroundLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        }

        let firstSelectedLabel = createLabel(with: segments[0], selected: true)
        selectedView.addSubview(firstSelectedLabel)
        firstSelectedLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        }

        backgroundLabels.append(firstBackgroundLabel)
        selectedLabels.append(firstSelectedLabel)

        for (index, title) in segments.enumerated().dropFirst() {
            print(index, title)

            let backgroundLabel = createLabel(with: title, selected: false)
            backgroundView.addSubview(backgroundLabel)
            backgroundLabel.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.leading.equalTo(backgroundLabels[index - 1].snp.trailing)
                make.width.equalToSuperview().dividedBy(3)
            }

            backgroundLabels.append(backgroundLabel)

            let selectedLabel = createLabel(with: title, selected: true)
            selectedView.addSubview(selectedLabel)
            selectedLabel.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.leading.equalTo(backgroundLabels[index - 1].snp.trailing)
                make.width.equalToSuperview().dividedBy(3)
            }

            selectedLabels.append(selectedLabel)
        }

//        backgroundView.addSubview(backgroundStackView)
//        selectedView.addSubview(selectedStackView)

//        setupAutoresizingMasks()
    }

    private func configureViews() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        backgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        selectedView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

//        sliderView.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.leading.equalToSuperview()
//            make.width.equalToSuperview().dividedBy(3)
//            make.bottom.equalToSuperview()
//        }

        let cornerRadius = height / 2
        [backgroundView, selectedView].forEach { $0.layer.cornerRadius = cornerRadius }
        sliderView.cornerRadius = cornerRadius

        backgroundColor = .clear
        backgroundView.backgroundColor = segmentsBackgroundColor
        selectedView.backgroundColor = sliderBackgroundColor

        if !isSliderShadowHidden {
            selectedView.addShadow(with: sliderBackgroundColor)
        }
    }

    func updateViewLayout(with width: CGFloat) {
        let sliderWidth = width / 3.0
        sliderView.frame = CGRect(x: CGFloat(selectedSegmentIndex) * sliderWidth,
                                  y: 0, width: sliderWidth, height: height)
    }

//    private func setupAutoresizingMasks() {
//        containerView.autoresizingMask = [.flexibleWidth]
//        backgroundView.autoresizingMask = [.flexibleWidth]
//        selectedView.autoresizingMask = [.flexibleWidth]
//        sliderView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth]
//    }

    private func updateShadow(with color: UIColor, hidden: Bool) {
        if hidden {
            selectedView.removeShadow()
            sliderView.sliderMaskView.removeShadow()
        } else {
            selectedView.addShadow(with: sliderBackgroundColor)
            sliderView.sliderMaskView.addShadow(with: .black)
        }
    }

    // MARK: Configure Labels

    private func removeLabels() {
        backgroundView.subviews.forEach { $0.removeFromSuperview() }
        selectedView.subviews.forEach { $0.removeFromSuperview() }
    }

    private func createLabel(with text: String, selected: Bool) -> UILabel {
        let label = UILabel()

        label.text = text
        label.textAlignment = .center
        label.textColor = selected ? highlightTextColor : defaultTextColor
        label.font = font

        return label
    }

    private func updateLabelsColor(with color: UIColor, selected: Bool) {
        let containerView = selected ? selectedView : backgroundView
        containerView.subviews.forEach { ($0 as? UILabel)?.textColor = color }
    }

    private func updateLabelsFont(with font: UIFont) {
        selectedView.subviews.forEach { ($0 as? UILabel)?.font = font }
        backgroundView.subviews.forEach { ($0 as? UILabel)?.font = font }
    }

    // MARK: Tap gestures

    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
    }

    private func addDragGesture() {
        let drag = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        sliderView.addGestureRecognizer(drag)
    }

    @objc private func didTap(tapGesture: UITapGestureRecognizer) {
        moveToNearestPoint(basedOn: tapGesture)
    }

    @objc private func didPan(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .cancelled, .ended, .failed:
            moveToNearestPoint(basedOn: panGesture, velocity: panGesture.velocity(in: sliderView))
        case .began:
            correction = panGesture.location(in: sliderView).x - sliderView.frame.width / 2
        case .changed:
            let location = panGesture.location(in: self)
            sliderView.center.x = location.x - correction
        case .possible: ()
        }
    }

    // MARK: Slider position

    private func moveToNearestPoint(basedOn gesture: UIGestureRecognizer, velocity: CGPoint? = nil) {
        var location = gesture.location(in: self)
        if let velocity = velocity {
            let offset = velocity.x / 12
            location.x += offset
        }
        let index = segmentIndex(for: location)
        move(to: index)
//        delegate?.didSelect(index)
    }

    open func move(to index: Int) {
        let correctOffset = center(at: index)
        animate(to: correctOffset)

        selectedSegmentIndex = index
    }

    private func segmentIndex(for point: CGPoint) -> Int {
        var index = Int(point.x / sliderView.frame.width)
        if index < 0 { index = 0 }
        if index > numberOfSegments - 1 { index = numberOfSegments - 1 }
        return index
    }

    private func center(at index: Int) -> CGFloat {
        let xOffset = CGFloat(index) * sliderView.frame.width + sliderView.frame.width / 2
        return xOffset
    }

    private func animate(to position: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.sliderView.center.x = position
        }
    }
}

enum Palette {
    static let defaultTextColor = Palette.colorFromRGB(9, green: 26, blue: 51, alpha: 0.4)
    static let highlightTextColor = UIColor.white
    static let segmentedControlBackgroundColor = Palette.colorFromRGB(237, green: 242, blue: 247, alpha: 0.7)
    static let sliderColor = Palette.colorFromRGB(44, green: 131, blue: 255)

    static func colorFromRGB(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        func amount(_ amount: CGFloat, with alpha: CGFloat) -> CGFloat {
            return (1 - alpha) * 255 + alpha * amount
        }

        let red = amount(red, with: alpha) / 255
        let green = amount(green, with: alpha) / 255
        let blue = amount(blue, with: alpha) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
