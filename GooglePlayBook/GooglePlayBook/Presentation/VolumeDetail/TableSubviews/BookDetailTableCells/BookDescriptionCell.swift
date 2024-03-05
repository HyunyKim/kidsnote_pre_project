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
        label.titleU()
        label.text = "책 정보"
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.descriptionUI(lineNumber: 4)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .blue
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        backgroundColor = .background
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20.0)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20.0)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(6.0)
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
