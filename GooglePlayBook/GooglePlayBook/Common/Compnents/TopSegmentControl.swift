//
//  TopSegmentControl.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/2/24.
//

import Foundation
import UIKit

class TopSegmentControl: UISegmentedControl {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.removeBasicUI()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        self.removeBasicUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func removeBasicUI() {
        let image = UIImage()
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setBackgroundImage(image, for: .selected, barMetrics: .default)
        self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        
        self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
    
    private lazy var underLineView: UIView = {
        let width = self.bounds.width / CGFloat(self.numberOfSegments)
        let height = 2.0
        let xPosition = CGFloat(self.selectedSegmentIndex * Int(width))
        let yPosition = self.bounds.size.height - 1.0
        let frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        let view = UIView(frame: frame)
        view .backgroundColor = .blue
        self.addSubview(view)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let underLineFinalXPostion = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(self.selectedSegmentIndex)
        UIView.animate(withDuration: 0.3) {
            self.underLineView.frame.origin.x = underLineFinalXPostion
        }
        
    }
    
}
