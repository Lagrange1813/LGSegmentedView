//
//  Styles.swift
//  LGSegmentedView
//
//  Created by 张维熙 on 2022/6/14.
//

import UIKit

struct ColorStyle: Hashable {
    var defaultTextColor: UIColor
    var highlightTextColor: UIColor
    var barBackgroundColor: UIColor
    var sliderViewColor: UIColor
}

let SegmentedBarStyles: [String: ColorStyle] = [
    "modern": ColorStyle(defaultTextColor: UIColor(hexString: "#9EA3AC"),
                         highlightTextColor: .white,
                         barBackgroundColor: UIColor(hexString: "#F4F6F9"),
                         sliderViewColor: UIColor(hexString: "#8F5558")),
    
    "classical": ColorStyle(defaultTextColor: .black,
                            highlightTextColor: .black,
                            barBackgroundColor: UIColor(hexString: "#EEEEEF"),
                            sliderViewColor: .clear),
    
    "imprint": ColorStyle(defaultTextColor: UIColor(hexString: "#9EA3AC"),
                          highlightTextColor: .white,
                          barBackgroundColor: UIColor(hexString: "#F4F6F9"),
                          sliderViewColor: UIColor(hexString: "#4781F7"))
]


