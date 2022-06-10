//
//  SegmentedViewExtension.swift
//  SegmentedView
//
//  Created by 张维熙 on 2022/6/9.
//

import Foundation

public enum SegmentedViewDisplayMode {
    case top
    case bottom
}

public enum SegmentedViewCountingMode {
    case barFirst
    case viewFirst
    case max
}

public enum SegmentedViewStyle {
    case modern
    case calm
}

enum MovingArea {
    case displayView
    case segmentedBar
    case undefined
}
