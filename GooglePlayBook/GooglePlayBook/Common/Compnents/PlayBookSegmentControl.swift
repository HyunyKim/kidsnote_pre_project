//
//  TopSegmentControl.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/2/24.
//

import Foundation
import UIKit

class PlayBookSegmentControl: UISegmentedControl {
    
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
        
        let underLineView = UIView()
        self.addSubview(underLineView)
        underLineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        underLineView.backgroundColor = .eLightGray
    }
    
    private func getSelectedTitleXPostion(titleWidth: CGFloat? = nil) -> CGFloat {
        let segmentSize = self.bounds.width / CGFloat(self.numberOfSegments)
        let width = titleWidth ?? getTitleStringSize().width
        return CGFloat(self.selectedSegmentIndex * Int(segmentSize)) + ((segmentSize / 2) - (width / 2))
    }
    
    private lazy var underLineView: UIView = {
        
        let width: CGFloat = getTitleStringSize().width
        let height: CGFloat = 6.0
        let xPosition: CGFloat = getSelectedTitleXPostion(titleWidth: width)
        let yPosition: CGFloat = self.bounds.size.height - 3.0
        let frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        let view = UIView(frame: frame)
        view .backgroundColor = .eBlue
        self.addSubview(view)
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        return view
    }()
    
    private func getTitleStringSize() -> CGSize {
        guard let title = self.titleForSegment(at: self.selectedSegmentIndex) else {
            return .zero
        }
        let attributed = self.titleTextAttributes(for: .selected)
        return title.sizeInPixels(attributes: attributed ?? [:])
        
    }
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = self.underLineView.frame
        frame.origin.x = getSelectedTitleXPostion()
        frame.size.width = self.getTitleStringSize().width
        UIView.animate(withDuration: 0.3) {
            
            self.underLineView.frame = frame
            
        }
    }
}
