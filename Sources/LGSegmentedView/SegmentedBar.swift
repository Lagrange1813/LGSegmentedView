//
//  SegmentedBar.swift
//  LGSegmentedView
//
//  Created by 张维熙 on 2022/6/6.
//

import UIKit

@objc protocol SegmentedBarDelegate {
    func sliderViewDidMove(_ segmentedBar: SegmentedBar)
    func segmentedBarWillStartScroll(_ segmentedBar: SegmentedBar)
    func segmentedBarDidEndScroll(_ segmentedBar: SegmentedBar)
}

private enum SegmentedBarState {
    case move
    case still
}

class SegmentedBar: UIControl {
    private var height: CGFloat
    var barStyle: LGSegmentedViewStyle

    var defaultTextColor: UIColor {
        SegmentedBarStyles[barStyle.rawValue]?.defaultTextColor ?? .clear
    }

    var highlightTextColor: UIColor {
        SegmentedBarStyles[barStyle.rawValue]?.highlightTextColor ?? .clear
    }

    var barBackgroundColor: UIColor {
        SegmentedBarStyles[barStyle.rawValue]?.barBackgroundColor ?? .clear
    }

    var sliderViewColor: UIColor {
        SegmentedBarStyles[barStyle.rawValue]?.sliderViewColor ?? .clear
    }

    override var bounds: CGRect {
        didSet {
            updateSliderView(with: bounds.width)
        }
    }

    private var barState: SegmentedBarState = .still {
        didSet {
            if oldValue == .still, barState == .move {
                delegate?.segmentedBarWillStartScroll(self)
                pursuing = true
            }

            if barState == .still {
                pursuing = false
            }
        }
    }

    var selectedIndex: Int {
        let location: CGFloat = sliderView.frame.midX
        let index: Int = index(at: location)
        return index
    }

    private var segmentTexts: [String] = []
    private var segmentImages: [UIImage] = []

    private var countOfSegments: Int {
        segmentImages.isEmpty && segmentTexts.isEmpty ?
            1 : max(segmentTexts.count, segmentImages.count)
    }

    private var segmentWidth: CGFloat {
        return bounds.width / CGFloat(countOfSegments)
    }

    private var correction: CGFloat = 0

    private lazy var containerView = UIView()
    private lazy var backgroundView = UIView()
    private lazy var selectedView = UIView()
    lazy var sliderView = SliderView()

    weak var delegate: SegmentedBarDelegate?

    var trigger: CADisplayLink?
    var pursuing: Bool = false

    init(frame: CGRect = .zero,
         barHeight: CGFloat,
         barStyle: LGSegmentedViewStyle = .modern)
    {
        height = barHeight
        self.barStyle = barStyle
        super.init(frame: frame)
        configureLayout()
        configureView()

        trigger = CADisplayLink(target: self, selector: #selector(listen))
        trigger?.add(to: RunLoop.current, forMode: RunLoop.Mode(rawValue: RunLoop.Mode.common.rawValue))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    var font: UIFont = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium) {
//        didSet {
//            updateLabelsFont(with: font)
//        }
//    }

//    var isSliderShadowHidden: Bool = false {
//        didSet {
//            updateShadow(with: sliderViewColor, hidden: isSliderShadowHidden)
//        }
//    }

    private func configureLayout() {
        addSubview(containerView)
        containerView.addSubview(backgroundView)
        containerView.addSubview(selectedView)
        containerView.addSubview(sliderView)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            selectedView.topAnchor.constraint(equalTo: containerView.topAnchor),
            selectedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            selectedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            selectedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }

    func updateSliderView(with width: CGFloat) {
        let sliderWidth = width / CGFloat(countOfSegments)
        sliderView.frame = CGRect(x: CGFloat(selectedIndex) * sliderWidth,
                                  y: 0, width: sliderWidth, height: height)
    }

    private func configureView() {
        backgroundColor = .clear
        backgroundView.backgroundColor = barBackgroundColor
        selectedView.backgroundColor = sliderViewColor
        
        selectedView.layer.mask = sliderView.sliderMaskView.layer
        
        switch barStyle {
        case .modern:

            let cornerRadius = height / 2
            backgroundView.layer.cornerRadius = cornerRadius
            selectedView.layer.cornerRadius = cornerRadius
            sliderView.cornerRadius = cornerRadius

//            if !isSliderShadowHidden {
//                selectedView.addShadow(with: UIColor(hexString: "#4781F7"))
//            }

        case .classical:

            let cornerRadius: CGFloat = 7
            backgroundView.layer.cornerRadius = cornerRadius
            selectedView.layer.cornerRadius = cornerRadius
            sliderView.cornerRadius = cornerRadius
            
            sliderView.borderWidth = 5
            sliderView.clipsToBounds = true
            sliderView.borderColor = barBackgroundColor

        case .imprint:

            break
        }

        addTapGesture()
        addDragGesture()
    }

    enum ItemType {
        case text
        case image
        case null
    }

    func setSegmentItems(withTexts segmentTexts: [String] = [],
                         withImages segmentImages: [UIImage] = [])
    {
        var type: ItemType = .null
        var count = 0

        if !segmentTexts.isEmpty {
            type = .text
            count = segmentTexts.count
            self.segmentTexts = segmentTexts
        } else if !segmentImages.isEmpty {
            type = .image
            count = segmentImages.count
            self.segmentImages = segmentImages
        } else { return }

        removeItems()

        var backgroundItems: [SegmentItem] = []
        var selectedItems: [SegmentItem] = []

        func getItem(at index: Int, selected: Bool) -> SegmentItem {
            var item: SegmentItem
            switch type {
            case .text:
                item = createItem(withText: segmentTexts[index], selected: selected)
            case .image:
                item = createItem(withImage: segmentImages[index], selected: selected)
            default:
                item = SegmentItem()
            }
            return item
        }

        let firstBackgroundItem = getItem(at: 0, selected: false)

        backgroundView.addSubview(firstBackgroundItem)

        firstBackgroundItem.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstBackgroundItem.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            firstBackgroundItem.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            firstBackgroundItem.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            firstBackgroundItem.widthAnchor.constraint(equalTo: backgroundView.widthAnchor,
                                                       multiplier: CGFloat(1) / CGFloat(count))
        ])

        let firstSelectedItem = getItem(at: 0, selected: true)
        selectedView.addSubview(firstSelectedItem)

        firstSelectedItem.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstSelectedItem.topAnchor.constraint(equalTo: selectedView.topAnchor),
            firstSelectedItem.leadingAnchor.constraint(equalTo: selectedView.leadingAnchor),
            firstSelectedItem.bottomAnchor.constraint(equalTo: selectedView.bottomAnchor),
            firstSelectedItem.widthAnchor.constraint(equalTo: selectedView.widthAnchor,
                                                     multiplier: CGFloat(1) / CGFloat(count))
        ])

        backgroundItems.append(firstBackgroundItem)
        selectedItems.append(firstSelectedItem)

        for index in 1 ..< count {
            let backgroundItem = getItem(at: index, selected: false)
            backgroundView.addSubview(backgroundItem)

            backgroundItem.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                backgroundItem.topAnchor.constraint(equalTo: backgroundView.topAnchor),
                backgroundItem.leadingAnchor.constraint(equalTo: backgroundItems[index - 1].trailingAnchor),
                backgroundItem.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
                backgroundItem.widthAnchor.constraint(equalTo: backgroundView.widthAnchor,
                                                      multiplier: CGFloat(1) / CGFloat(count))
            ])

            backgroundItems.append(backgroundItem)

            let selectedItem = getItem(at: index, selected: true)
            selectedView.addSubview(selectedItem)

            selectedItem.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                selectedItem.topAnchor.constraint(equalTo: selectedView.topAnchor),
                selectedItem.leadingAnchor.constraint(equalTo: selectedItems[index - 1].trailingAnchor),
                selectedItem.bottomAnchor.constraint(equalTo: selectedView.bottomAnchor),
                selectedItem.widthAnchor.constraint(equalTo: selectedView.widthAnchor,
                                                    multiplier: CGFloat(1) / CGFloat(count))
            ])

            selectedItems.append(selectedItem)
        }
    }

//    private func updateShadow(with color: UIColor, hidden: Bool) {
//        if hidden {
//            selectedView.removeShadow()
//            sliderView.sliderMaskView.removeShadow()
//        } else {
//            selectedView.addShadow(with: sliderViewColor)
//            sliderView.sliderMaskView.addShadow(with: .black)
//        }
//    }

    // MARK: Configure Items

    private func removeItems() {
        backgroundView.subviews.forEach { $0.removeFromSuperview() }
        selectedView.subviews.forEach { $0.removeFromSuperview() }
    }

    private func createItem(withText text: String = "",
                            withImage image: UIImage = UIImage(),
                            selected: Bool) -> SegmentItem
    {
        let item = SegmentItem()

        if text != "" {
            item.setText(text)
        } else if image != UIImage() {
            item.setImage(image, with: 22)
        } else {
            return .init()
        }

        item.tintColor = selected ? highlightTextColor : defaultTextColor

        return item
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
        moveToNearestSegment(on: tapGesture)
        switch tapGesture.state {
        case .ended, .cancelled, .failed:
            barState = .move
        default:
            break
        }
    }

    @objc private func didPan(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .cancelled, .ended, .failed:
            moveToNearestSegment(on: panGesture)
        case .began:
            barState = .move
            correction = panGesture.location(in: sliderView).x - sliderView.frame.width / 2
        case .changed:
            let location = panGesture.location(in: self)
            sliderView.center.x = location.x - correction
        default:
            break
        }
    }

    // MARK: Slider Position

    func setSliderView(at location: CGFloat) {
        sliderView.frame.origin.x = location
    }

    private func moveToNearestSegment(on gesture: UIGestureRecognizer) {
        let location = gesture.location(in: self).x
        let index = index(at: location)
        move(to: index)
    }

    open func move(to index: Int) {
        animate(to: index)
    }

    private func index(at location: CGFloat) -> Int {
        guard sliderView.frame.width != 0 else { return 0 }

        var index = Int(location / sliderView.frame.width)
        if index < 0 { index = 0 }
        else if index > countOfSegments - 1 { index = countOfSegments - 1 }
        return index
    }

    private func center(at index: Int) -> CGFloat {
        CGFloat(index) * sliderView.frame.width + sliderView.frame.width / 2
    }

    private func leftBoundary(at index: Int) -> CGFloat {
        CGFloat(index) * sliderView.frame.width
    }

    private func animate(to index: Int) {
        UIView.animate(withDuration: 0.2, animations: {
            self.sliderView.center.x = self.center(at: index)
        }, completion: { _ in
            self.delegate?.segmentedBarDidEndScroll(self)
            self.barState = .still
        })

//        let queue = DispatchQueue.main
//
//        let item = DispatchWorkItem {
//
//            UIView.animate(withDuration: 0.2, animations: {
//                self.sliderView.center.x = self.center(at: index)
//            }, completion: { _ in
//                self.delegate?.segmentedBarDidEndScroll()
//                self.barState = .still
//            })
//        }
//
//        queue.async(execute: item)
    }

    // MARK: Monitoring Method

    @objc func listen() {
        if pursuing {
            delegate?.sliderViewDidMove(self)
        }
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
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
