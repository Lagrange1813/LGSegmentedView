//
//  ViewController.swift
//  SegmentedViewDemo
//
//  Created by 张维熙 on 2022/6/6.
//

import UIKit
import SegmentedView

class ViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .gray
    
        let segmentedView = SegmentedView(frame: CGRect(x: 100,
                                                        y: 100,
                                                        width: 200,
                                                        height: 200))
        view.addSubview(segmentedView)
    }
}
