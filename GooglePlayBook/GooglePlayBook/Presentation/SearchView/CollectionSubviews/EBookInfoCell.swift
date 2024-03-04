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
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
//        imageView.layer.shadowColor = UIColor.eGray.cgColor
//        imageView.layer.shadowOpacity = 0.3
//        imageView.layer.shadowOffset = CGSize(width: 2, height: 2)
//        imageView.layer.shadowRadius = 5
//      TODO: - 쉐도우를 위해서 컨테이너뷰 필요
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12,weight: .medium)
        label.textColor = .textColor1
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        return label
    }()
    
    private var authorInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11,weight: .light)
        label.textColor = .gray
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        return label
    }()
    private var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11,weight: .light)
        label.textColor = .gray
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        return label
    }()
    private var starRatingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12,weight: .medium)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        contentView.addSubview(thumbNailImageView)
        thumbNailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(60)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(50)
            
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(thumbNailImageView.snp.trailing).offset(16)
            make.top.equalTo(thumbNailImageView.snp.top)
            make.trailing.equalToSuperview().offset(16)
            make.height.greaterThanOrEqualTo(20)
        }
        contentView.addSubview(authorInfoLabel)
        authorInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(16)
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
        thumbNailImageView.cancelImageDownload()
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
        if let urlString = ebook.thumbNail {
            thumbNailImageView.setImage(urlString: urlString)
        } else {
            thumbNailImageView.image = .emptyBook
        }
    }
}
