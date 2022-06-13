//
//  ViewController.swift
//  LGSegmentedViewDemo
//
//  Created by 张维熙 on 2022/6/13.
//

import LGSegmentedView
import UIKit

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
        
        let segmentedView = LGSegmentedView(barItems: ["Test1", "Test2", "Test3", "Test4"],
                                          views: [testView1, testView2, testView3, testView4])
        
//        let segmentedView = UIView()
//        segmentedView.backgroundColor = .blue
        
        view.addSubview(segmentedView)
        
//        segmentedView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
//            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//        }
        
        segmentedView.translatesAutoresizingMaskIntoConstraints = false
        segmentedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        segmentedView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        segmentedView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        segmentedView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
//        segmentedView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        segmentedView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        segmentedView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        segmentedView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
