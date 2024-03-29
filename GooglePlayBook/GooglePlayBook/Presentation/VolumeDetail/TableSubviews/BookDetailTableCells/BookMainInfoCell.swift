//
//  BookMainInfoCell.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/5/24.
//

import UIKit

final class BookMainInfoCell: UITableViewCell {
    
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
        label.titleUI(lineNumber: 0)
        return label
    }()
    
    private var authorInfoLabel: UILabel = {
        let label = UILabel()
        label.descriptionUI(lineNumber: 0)
        return label
    }()
    
    private var addionalInfo: UILabel = {
        let label = UILabel()
        label.descriptionUI(font: UIFont.systemFont(ofSize: 12, weight: .medium))
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        titleLabel.text = ""
        authorInfoLabel.text = ""
        addionalInfo.text = ""
    }
    
    private func layoutUI() {
        selectionStyle = .none
        backgroundColor = .background
        contentView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16.0)
            make.leading.equalToSuperview().inset(20.0)
            make.width.equalTo(80.0)
            make.height.equalTo(120.0)
            make.bottomMargin.lessThanOrEqualToSuperview().inset(16.0)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.coverImageView.snp.top).priority(.high)
            make.leading.equalTo(self.coverImageView.snp.trailing).offset(16.0)
            make.trailing.equalToSuperview().inset(20.0)
            make.height.greaterThanOrEqualTo(21.0)
        }
        
        contentView.addSubview(authorInfoLabel)
        authorInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(4.0)
            make.leading.equalTo(self.titleLabel.snp.leading)
            make.trailing.equalTo(self.titleLabel.snp.trailing)
        }
        
        contentView.addSubview(addionalInfo)
        addionalInfo.snp.makeConstraints { make in
            make.top.equalTo(self.authorInfoLabel.snp.bottom).offset(4.0).priority(.high)
            make.leading.equalTo(self.titleLabel.snp.leading)
            make.trailing.equalTo(self.titleLabel.snp.trailing)
            make.bottom.lessThanOrEqualToSuperview().inset(16.0)
        }
        
        let line = UIView()
        line.backgroundColor = .line
        contentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.3)
        }
    }
    
    func updateUI(bookInfo: BookDetailInfo) {
        titleLabel.text = bookInfo.title ?? ""
        authorInfoLabel.text = bookInfo.authors?.reduce("", +)
        addionalInfo.text = "\((bookInfo.isEBook ?? false) ? "eBook" : "") - \(bookInfo.pageCount ?? 0)"
        if let urlString = bookInfo.thumbNail {
            coverImageView.setImage(urlString: urlString)
        } else {
            coverImageView.image = .emptyBook
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
