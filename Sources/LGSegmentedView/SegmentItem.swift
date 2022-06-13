//
//  SegmentItem.swift
//
//
//  Created by 张维熙 on 2022/6/13.
//

import UIKit

class SegmentItem: UIView {
    private var label: UILabel? {
        didSet {
            label?.textColor = tintColor
        }
    }
    
    private var icon: UIImageView? {
        didSet {
            icon?.tintColor = tintColor
        }
    }
    
    override var tintColor: UIColor? {
        didSet {
            label?.textColor = tintColor
            icon?.tintColor = tintColor
        }
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String) {
        label = UILabel()
        
        guard let label = label else { return }
        
        label.text = text
        label.textAlignment = .center
        
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setImage(_ image: UIImage, with length: CGFloat) {
        icon = UIImageView()
        
        guard let icon = icon else { return }
        
        icon.image = image
        icon.contentMode = .scaleAspectFit
        addSubview(icon)
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: length),
            icon.heightAnchor.constraint(equalToConstant: length)
        ])
    }
}
