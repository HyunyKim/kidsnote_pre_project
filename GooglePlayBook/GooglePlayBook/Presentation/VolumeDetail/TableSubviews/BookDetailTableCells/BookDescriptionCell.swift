//
//  BookDescriptionCell.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/4/24.
//

import UIKit
import SnapKit

final class BookDescriptionCell: UITableViewCell {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.titleUI()
        label.text = "책 정보"
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.descriptionUI(lineNumber: 4)
        return label
    }()
    
    private var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(systemName: "chevron.right")?.withTintColor(.eBlue)
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        self.descriptionLabel.text = ""
    }
    
    private func layoutUI() {
        backgroundColor = .background
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        contentView.addSubview(chevronImageView)
        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20.0)
            make.size.equalTo(20)
            make.verticalEdges.equalTo(self.titleLabel)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(self.titleLabel.snp.leading)
            make.trailing.equalTo(self.titleLabel.snp.trailing)
            make.bottom.equalToSuperview().inset(16.0)
        }
    }
    
    func updateDescription(text: String) {
        self.descriptionLabel.htmlStringSet(text: text)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
