//
//  SearchResultItemCell.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/3/24.
//

import UIKit
import SnapKit

class EBookInfoCell: UICollectionViewCell {
    
    private var thumbNailImageView: UIImageView = {
       let imgViw = UIImageView()
        imgViw.contentMode = .scaleAspectFill
        return imgViw
    }()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14,weight: .medium)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private var authorInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12,weight: .medium)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    private var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12,weight: .medium)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    private var starRatingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12,weight: .medium)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        contentView.addSubview(thumbNailImageView)
        thumbNailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(80)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(80)
            
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(thumbNailImageView.snp.trailing).offset(4)
            make.top.equalTo(thumbNailImageView.snp_topMargin)
            make.trailing.equalToSuperview().offset(16)
            make.height.greaterThanOrEqualTo(20)
        }
        contentView.addSubview(authorInfoLabel)
        authorInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview().offset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.height.equalTo(13)
        }
        contentView.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.width.greaterThanOrEqualTo(40)
            make.top.equalTo(authorInfoLabel.snp.bottom).offset(2)
            make.height.equalTo(13)
        }
        contentView.addSubview(starRatingLabel)
        starRatingLabel.snp.makeConstraints { make in
            make.leading.equalTo(typeLabel.snp.trailing).offset(2)
            make.top.equalTo(typeLabel.snp.top)
            make.height.equalTo(13)
            make.width.greaterThanOrEqualTo(20)
            
        }
    }
    
    override func prepareForReuse() {
        thumbNailImageView.image = nil
        titleLabel.text = ""
        authorInfoLabel.text = ""
        typeLabel.text = ""
        starRatingLabel.text = ""
    }
    
    public func updateUI(ebook: EBook) {
        titleLabel.text = ebook.title
        authorInfoLabel.text = ebook.authors?.reduce("",+)
        typeLabel.text = (ebook.isEBook ?? false) ? "eBook" : ""
        typeLabel.text = "별"
    }
}
