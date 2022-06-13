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
        
        let image1 = UIImage(systemName: "suit.heart.fill") ?? UIImage()
        let image2 = UIImage(systemName: "suit.club.fill") ?? UIImage()
        let image3 = UIImage(systemName: "suit.diamond.fill") ?? UIImage()
        let image4 = UIImage(systemName: "suit.spade.fill") ?? UIImage()
        let image5 = UIImage(systemName: "applelogo") ?? UIImage()
        
        let segmentedView = LGSegmentedView(
//            segmentTexts: ["Test1", "Test2", "Test3"],
//            segmentTexts: ["Test1", "Test2", "Test3", "Test4"],
//            segmentTexts: ["Test1", "Test2", "Test3", "Test4", "Test5"],
//            segmentImages: [image1, image2, image3],
            segmentImages: [image1, image2, image3, image4],
//            segmentImages: [image1, image2, image3, image4, image5],
            views: [testView1, testView2, testView3, testView4])
        
        view.addSubview(segmentedView)
        
        segmentedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            segmentedView.widthAnchor.constraint(equalToConstant: 300),
            segmentedView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
