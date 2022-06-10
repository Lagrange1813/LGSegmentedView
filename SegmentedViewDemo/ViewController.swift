//
//  ViewController.swift
//  SegmentedViewDemo
//
//  Created by 张维熙 on 2022/6/6.
//

import UIKit
import SegmentedView
import SnapKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .gray
    
        let testView1 = UIView()
        testView1.backgroundColor = .red
        let testView2 = UIView()
        testView2.backgroundColor = .yellow
        let testView3 = UIView()
        testView3.backgroundColor = .blue
        
        let segmentedView = SegmentedView(barItems: ["Test1", "Test2", "Test3"], views: [testView1, testView2, testView3])
        view.addSubview(segmentedView)
        
        segmentedView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(500)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
