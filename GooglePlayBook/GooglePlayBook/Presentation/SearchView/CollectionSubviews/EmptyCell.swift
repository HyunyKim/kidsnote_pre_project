//
//  EmptyCell.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/7/24.
//

import UIKit
import SnapKit

class EmptyCell: UICollectionViewCell {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.descriptionUI(alignment: .center)
        label.text = "검색 결과가 없습니다"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func layoutUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    func updateTitle(title: String) {
        titleLabel.text = title
    }
}
