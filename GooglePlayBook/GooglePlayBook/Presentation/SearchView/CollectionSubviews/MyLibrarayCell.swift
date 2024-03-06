//
//  MyLibrarayCell.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/6/24.
//

import Foundation
import UIKit
import SnapKit

final class MyLibrarayCell: UICollectionViewCell {
    
    private var titleLabel: UILabel = {
       let label = UILabel()
        label.listTitleUI()
        return label
    }()
    
    private var infoLabel: UILabel = {
       let label = UILabel()
        label.listDesrciptionUI()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10.0)
        }
        
        contentView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8.0)
            make.leading.trailing.equalTo(10.0)
            make.bottom.equalTo(8)
        }
    }
    
    func updateUI(libraryInfo: Bookshelf) {
        self.titleLabel.text = libraryInfo.title ?? "UnKnown"
        self.infoLabel.text = "\(libraryInfo.volumeCount ?? 0)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        infoLabel.text = ""
    }
    
}
