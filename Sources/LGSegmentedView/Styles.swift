//
//  Styles.swift
//  LGSegmentedView
//
//  Created by 张维熙 on 2022/6/14.
//

import UIKit

struct ColorStyle: Hashable {
    var defaultItemColor: UIColor
    var highlightItemColor: UIColor
    var containerViewColor: UIColor
    var selectViewColor: UIColor
}

let SegmentedBarStyles: [String: ColorStyle] = [
    "modern": ColorStyle(
        defaultItemColor: .dynamicColor(UIColor(hexString: "#9EA3AC"),
                                        darkColor: UIColor(hexString: "#39393D")),
        highlightItemColor: .white,
        containerViewColor: .dynamicColor(UIColor(hexString: "#F4F6F9"),
                                          darkColor: UIColor(hexString: "#1D1C1F")),
        selectViewColor: .dynamicColor(UIColor(hexString: "#8F5558"),
                                       darkColor: UIColor(hexString: "#C1A78F"))),

    "classical": ColorStyle(
        defaultItemColor: .black,
        highlightItemColor: .black,
        containerViewColor: .dynamicColor(UIColor(hexString: "#EEEEEF"),
                                          darkColor: UIColor(hexString: "#1D1C1F")),
        selectViewColor: .clear),

    "imprint": ColorStyle(
        defaultItemColor: UIColor(hexString: "#9EA3AC"),
        highlightItemColor: .white,
        containerViewColor: UIColor(hexString: "#F4F6F9"),
        selectViewColor: UIColor(hexString: "#4781F7"))
]
