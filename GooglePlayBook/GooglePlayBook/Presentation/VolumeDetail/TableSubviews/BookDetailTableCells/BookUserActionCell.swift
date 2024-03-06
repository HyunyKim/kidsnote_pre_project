//
//  BookUserActionCell.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/4/24.
//

import UIKit
import SnapKit

protocol BookActiondelegate: AnyObject {
    func sampleBookOpen(urlString: String)
    func addWishList()
    func removeWishList()
}

final class BookUserActionCell: UITableViewCell {

    private var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        
        return stackView
    }()
    
    private var sampleButton: RoundedButton = {
        let button = RoundedButton(frame: .zero,bgColor: .eBlue)
        button.setTitle("무료 샘플", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    private var buyButton: UIButton = {
        let button = RoundedButton(frame: .zero,bgColor: .clear)
        button.setTitle("전체 도서 구매하기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.eBlue, for: .normal)
        return button
    }()
    
    var sampleURLString: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layoutUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func layoutUI() {
        backgroundColor = .background
        stackView.insertArrangedSubview(sampleButton, at: 0)
        stackView.insertArrangedSubview(buyButton, at: 1)
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.height.equalTo(38).priority(.medium)
            make.edges.equalToSuperview().inset(20)
        }
        
        
        sampleButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
        buyButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
        sampleButton.addTarget(self, action: #selector(sampleButtonAction), for: .touchUpInside)
        buyButton.addTarget(self, action: #selector(buyButtonAction), for: .touchUpInside)
        
    }
    
    @objc func sampleButtonAction(sender: UIControl) {
        guard let urlString = sampleURLString, let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func buyButtonAction(sender: UIControl) {
//    TODO: - 이부분 정의 해야함.
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
