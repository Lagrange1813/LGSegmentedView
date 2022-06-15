//
//  SliderView.swift
//  LGSegmentedView
//
//  Created by 张维熙 on 2022/6/8.
//

import UIKit

class SliderView: UIView {
    let sliderMaskView = UIView()
    
    var style: LGSegmentedBarStyle
    var border: CGFloat = 2

    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            
            switch style {
            case .modern:
                sliderMaskView.layer.cornerRadius = cornerRadius
            case .classical:
                sliderMaskView.layer.cornerRadius = cornerRadius
            case .imprint:
                break
            }
        }
    }
    
    override var frame: CGRect {
        didSet {
            switch style {
            case .modern:
                sliderMaskView.frame = frame
            case .classical:
                sliderMaskView.frame = CGRect(x: frame.origin.x + border,
                                              y: frame.origin.y + border,
                                              width: frame.width - 2*border,
                                              height: frame.height - 2*border)
            case .imprint:
                break
            }
        }
    }

    override var center: CGPoint {
        didSet {
            sliderMaskView.center = center
        }
    }

    init(_ style: LGSegmentedBarStyle = .modern) {
        self.style = style
        super.init(frame: .zero)
        
        sliderMaskView.backgroundColor = .dynamicColor(.white, darkColor: UIColor(hexString: "#E2E2E6"))
        
        switch style {
        case .modern:
            sliderMaskView.addShadow(.black)
        case .classical:
            sliderMaskView.addShadow(.black, style: .classical)
        case .imprint:
            break
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
