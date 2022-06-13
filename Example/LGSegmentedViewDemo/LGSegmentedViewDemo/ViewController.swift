//
//  ViewController.swift
//  LGSegmentedViewDemo
//
//  Created by 张维熙 on 2022/6/13.
//

import UIKit
import SnapKit
import LGSegmentedView

class ViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .gray
    
        let testView1 = UIView()
        testView1.backgroundColor = .red
        let testView2 = UIView()
        testView2.backgroundColor = .yellow
        let testView3 = UIView()
        testView3.backgroundColor = .blue
        let testView4 = UIView()
        testView4.backgroundColor = .green
        
        let segmentedView = SegmentedView(barItems: ["Test1", "Test2", "Test3", "Test4"],
                                          views: [testView1, testView2, testView3, testView4])
        view.addSubview(segmentedView)
        
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
//        NSLayoutConstraint.activate([
//            segmentedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            segmentedView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            segmentedView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            segmentedView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
//        ])
    }
}
