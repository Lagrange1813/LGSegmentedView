//
//  SegmentedViewExtension.swift
//  SegmentedView
//
//  Created by 张维熙 on 2022/6/9.
//

import Foundation

public enum DisplayMode {
    case top
    case bottom
}

public enum CountingMode {
    case barFirst
    case viewFirst
    case max
}

enum MovingArea {
    case displayView
    case segmentedBar
    case undefined
}
