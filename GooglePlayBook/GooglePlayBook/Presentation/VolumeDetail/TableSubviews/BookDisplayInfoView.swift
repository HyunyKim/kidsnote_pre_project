//
//  BookDisplayInfoView.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/4/24.
//

import Foundation
import UIKit
import SnapKit

final class BookDisplayInfoView: UIView {
    
    private var coverImageView: UIImageView = {
        let imageView = UIImageView()
        //        imageView.layer.cornerRadius = 2
        //        imageView.layer.masksToBounds = true
        imageView.layer.shadowColor = UIColor(resource: .eGray).cgColor
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        imageView.layer.shadowRadius = 5
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .textColor1
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private var authorInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private var addionalInfo: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        layoutUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        addSubview(coverImageView)
        coverImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(10)
            make.width.equalTo(80)
            make.height.equalTo(120)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.coverImageView.snp.top)
            make.leading.equalTo(self.coverImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(21)
        }
        
        addSubview(authorInfoLabel)
        authorInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(self.titleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(16)
        }
        
        addSubview(addionalInfo)
        addionalInfo.snp.makeConstraints { make in
            make.top.equalTo(self.authorInfoLabel.snp.bottom).offset(4)
            make.leading.equalTo(self.titleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(16)
        }
    }
    
    
    func updateUI(bookInfo: BookDetailInfo) {
        titleLabel.text = bookInfo.title ?? ""
        authorInfoLabel.text = bookInfo.authors?.reduce("", +)
        addionalInfo.text = "\((bookInfo.isEBook ?? false) ? "eBook" : "") - \(bookInfo.pageCount ?? 0)"
        if let urlString = bookInfo.thumbNail {
            coverImageView.setImage(urlString: urlString)
        }
    }
}
