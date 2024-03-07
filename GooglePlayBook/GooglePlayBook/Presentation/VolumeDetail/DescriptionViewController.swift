//
//  DescriptionViewController.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/5/24.
//

import UIKit
import SnapKit

class DescriptionViewController: UIViewController {
    private var scrollView: UIScrollView = UIScrollView()
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.descriptionUI(lineNumber: 0)
        return label
    }()
    private let contentView = UIView()
    
    private var bookDescription: String?
    private var titleString: String?
    
    init(description: String, title: String) {
        self.bookDescription = description
        self.titleString = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
    }
    
    private func layoutUI() {
        self.navigationItem.title = titleString
        view.backgroundColor = .background
        
        let barbuttonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backAction))
        barbuttonItem.tintColor = .textColor1
        navigationItem.leftBarButtonItem = barbuttonItem
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(self.scrollView)
        }
        contentView.addSubview(descriptionLabel)
        descriptionLabel.htmlStringSet(text: bookDescription ?? "")
        descriptionLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    @objc private func backAction(sender: UIControl) {
        self.navigationController?.popViewController(animated: true)
    }
}
