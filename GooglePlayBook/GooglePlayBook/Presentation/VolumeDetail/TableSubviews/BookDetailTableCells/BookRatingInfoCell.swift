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
        label.text = "4.7"
        return label
    }()
    
    private var starView: UIView = {
       let view = UIView()
        view.backgroundColor = .eRed
        return view
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
    
    private func layoutUI() {
        backgroundColor = .background
        contentView.addSubview(ratingScoreLabel)
        ratingScoreLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16.0)
            make.leading.equalToSuperview().inset(16.0)
        }
        contentView.addSubview(starView)
        starView.snp.makeConstraints { make in
            make.leading.equalTo(self.ratingScoreLabel.snp.trailing).offset(5.0)
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
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
