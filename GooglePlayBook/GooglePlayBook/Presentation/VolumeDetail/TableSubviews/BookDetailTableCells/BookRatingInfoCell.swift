//
//  BookRatingInfoCell.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/4/24.
//

import UIKit
import SnapKit

final class BookRatingInfoCell: UITableViewCell {

    private var ratingScoreLabel: UILabel = {
        let label = UILabel()
        label.titleU()
        return label
    }()
    
    private var ratingLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()

    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.descriptionUI()
        label.text = "Google Play 평점 14개"
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
        ratingScoreLabel.text = ""
        descriptionLabel.text = ""
        ratingLabel.text = ""
    }
    
    private func layoutUI() {
        backgroundColor = .background
        selectionStyle = .none
        contentView.addSubview(ratingScoreLabel)
        ratingScoreLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16.0)
        }
        contentView.addSubview(ratingLabel)
        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.ratingScoreLabel.snp.trailing).offset(8.0)
            make.centerY.equalTo(self.ratingScoreLabel)
            make.width.equalTo(150.0)
            make.height.equalTo(24.0)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.ratingScoreLabel.snp.bottom).offset(2.0)
            make.leading.equalTo(self.ratingScoreLabel.snp.leading)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10.0)
        }
    }
    
    func updateRatingInfo(info: BookDetailInfo) {
        ratingScoreLabel.text = String(format: "%0.1f", info.bookRating ?? 0.0)
        ratingLabel.text = String.ratingValue(rating: info.bookRating ?? 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
