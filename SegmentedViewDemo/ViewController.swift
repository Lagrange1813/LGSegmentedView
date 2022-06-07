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
    
        let segmentedView = SegmentedView()
        view.addSubview(segmentedView)
        
        segmentedView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(500)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
