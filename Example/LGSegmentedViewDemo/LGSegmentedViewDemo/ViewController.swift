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
        view.backgroundColor = .systemGray5
    
        let testView1 = UIView()
        testView1.backgroundColor = UIColor(hexString: "#D4C9BB")
        let testView2 = UIView()
        testView2.backgroundColor = UIColor(hexString: "#D3C89C")
        let testView3 = UIView()
        testView3.backgroundColor = UIColor(hexString: "#C6A68C")
        let testView4 = UIView()
        testView4.backgroundColor = UIColor(hexString: "#777581")
        
        let image1 = UIImage(systemName: "suit.heart.fill") ?? UIImage()
        let image2 = UIImage(systemName: "suit.club.fill") ?? UIImage()
        let image3 = UIImage(systemName: "suit.diamond.fill") ?? UIImage()
        let image4 = UIImage(systemName: "suit.spade.fill") ?? UIImage()
        
        let config = LGSegmentedViewConfiguration(barHeight: 35,
                                                  displayMode: .bottom,
                                                  countingMode: .barFirst,
                                                  barStyle: .classical)
        
        let segmentedView = LGSegmentedView(
            config: config,
//            segmentTexts: ["Test1", "Test2", "Test3", "Test4"],
            segmentImages: [image1, image2, image3, image4],
            views: [testView1, testView2, testView3, testView4])
        
        segmentedView.backgroundColor = .systemBackground
        
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

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
    }
}
