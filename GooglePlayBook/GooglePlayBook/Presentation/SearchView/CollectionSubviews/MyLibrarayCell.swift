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
        label.titleUI()
        return label
    }()
    
    private var infoLabel: UILabel = {
       let label = UILabel()
        label.descriptionUI(font: UIFont.systemFont(ofSize: 18))
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
            make.top.leading.equalToSuperview().inset(10.0)
            make.height.equalTo(50.0)
            make.bottom.equalToSuperview().inset(5.0)
        }
        
        contentView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.titleLabel.snp.trailing).offset(20.0)
            make.top.equalTo(self.titleLabel.snp.top)
            make.bottom.equalTo(self.titleLabel.snp.bottom)
            
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
