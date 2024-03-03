//
//  LoadMoreCell.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/3/24.
//

import Foundation
import UIKit
import SnapKit

class LoadMoreCell: UICollectionViewCell {
    
    private let loadingActivity = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        contentView.addSubview(loadingActivity)
        loadingActivity.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.center.equalToSuperview()
        }
        loadingActivity.startAnimating()
    }
    
    override func prepareForReuse() {
        loadingActivity.startAnimating()
    }
}
