//
//  BookUserActionCell.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/4/24.
//

import UIKit
import SnapKit

protocol BookActiondelegate: AnyObject {
    func emptySampleURL()
    func addMylibrary()
    func removeMyLibrary()
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
    private var addButton: UIButton = {
        let button = RoundedButton(frame: .zero,bgColor: .clear)
        button.setTitle("내 라이브러리에 추가", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.eBlue, for: .normal)
        return button
    }()
    
    var sampleURLString: String?
    weak var delegate: BookActiondelegate?
    
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
        delegate = nil
        sampleURLString = nil
    }
    
    private func layoutUI() {
        backgroundColor = .background
        stackView.insertArrangedSubview(sampleButton, at: 0)
        stackView.insertArrangedSubview(addButton, at: 1)
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.height.equalTo(38).priority(.medium)
            make.edges.equalToSuperview().inset(20)
        }
        
        
        sampleButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
        sampleButton.addTarget(self, action: #selector(sampleButtonAction), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(buyButtonAction), for: .touchUpInside)
        
    }
    
    @objc func sampleButtonAction(sender: UIControl) {
        guard let urlString = sampleURLString, let url = URL(string: urlString) else {
            if let delegate = delegate {
                delegate.emptySampleURL()
            }
            return
        }
        UIApplication.shared.open(url)
    }
    
    @objc func buyButtonAction(sender: UIControl) {
        guard let delegate = delegate else {
            return
        }
        delegate.addMylibrary()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
