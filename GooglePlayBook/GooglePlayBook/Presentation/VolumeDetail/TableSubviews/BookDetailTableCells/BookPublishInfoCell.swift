//
//  BookPublishInfoCell.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/4/24.
//

import UIKit

final class BookPublishInfoCell: UITableViewCell {
    
    private var titleLabel = {
        let label = UILabel()
        label.titleUI()
        label.text = "게시일"
        return label
    }()
    
    private var publishInfoLabel = {
        let label = UILabel()
        label.descriptionUI()
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
        self.publishInfoLabel.text = ""
    }
    
    private func layoutUI() {
        selectionStyle = .none
        backgroundColor = .background
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
        }
        contentView.addSubview(publishInfoLabel)
        publishInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5.0)
            make.leading.equalTo(self.titleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(16.0)
            make.bottom.equalToSuperview().inset(10.0)
        }
    }
    
    func updatePublishInfo(info: String) {
        self.publishInfoLabel.text = info
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
