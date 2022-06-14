//
//  SegmentedViewExtension.swift
//  LGSegmentedView
//
//  Created by 张维熙 on 2022/6/9.
//

import CoreGraphics

public enum LGSegmentedViewDisplayMode {
    case top
    case bottom
}

public enum LGSegmentedViewCountingMode {
    case barFirst
    case viewFirst
    case max
}

public enum LGSegmentedViewStyle: String {
    case modern = "modern"
    case classical = "classical"
    case imprint = "imprint"
}

enum MovingArea {
    case displayView
    case segmentedBar
    case undefined
}

public struct LGSegmentedViewConfiguration {
    var barHeight: CGFloat = 35
    var displayMode: LGSegmentedViewDisplayMode = .top
    var countingMode: LGSegmentedViewCountingMode = .barFirst
}
