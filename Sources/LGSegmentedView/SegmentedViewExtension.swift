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

public enum LGSegmentedBarStyle: String {
    case modern
    case classical
    case imprint
}

enum MovingArea {
    case displayView
    case segmentedBar
    case undefined
}

public struct LGSegmentedViewConfiguration {
    public var barHeight: CGFloat
    public var displayMode: LGSegmentedViewDisplayMode = .top
    public var countingMode: LGSegmentedViewCountingMode = .barFirst
    public var barStyle: LGSegmentedBarStyle = .modern
    
    public init(
        barHeight: CGFloat = 35,
        displayMode: LGSegmentedViewDisplayMode = .bottom,
        countingMode: LGSegmentedViewCountingMode = .barFirst,
        barStyle: LGSegmentedBarStyle = .modern
    ) {
        self.barHeight = barHeight
        self.displayMode = displayMode
        self.countingMode = countingMode
        self.barStyle = barStyle
    }
}
