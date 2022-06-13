//
//  SliderView.swift
//  SegmentedView
//
//  Created by 张维熙 on 2022/6/8.
//

import UIKit

class SliderView: UIView {
    let sliderMaskView = UIView()

    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            sliderMaskView.layer.cornerRadius = cornerRadius
        }
    }

    override var frame: CGRect {
        didSet {
            sliderMaskView.frame = frame
        }
    }

    override var center: CGPoint {
        didSet {
            sliderMaskView.center = center
        }
    }

    init() {
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        layer.masksToBounds = true
        sliderMaskView.backgroundColor = .black
        sliderMaskView.addShadow(with: .black)
    }
}

