//
//  SearchResultResuableView.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/3/24.
//

import UIKit
import SnapKit
enum HeaderType {
    case sementControll
    case googlePlaySearchResult
    case myLibrarySearchResult
}

final class TopSegmentReuseableView: UICollectionReusableView {
    
    private let segmentControll: UISegmentedControl = TopSegmentControl(items: ["eBook","AudioBook"])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        addSubview(segmentControll)
        segmentControll.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        segmentControll.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
        segmentControll.setTitleTextAttributes([.foregroundColor: UIColor.blue, .font: UIFont.systemFont(ofSize: 13,weight: .semibold)], for: .selected)
        segmentControll.selectedSegmentIndex = 0
    }
}

final class SearchResultResuableView: UICollectionReusableView {

    static let reuseIdentifier = "MyHeaderView"
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
    }
    
    private func layoutUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16.0)
        }
    }
    
    func updateUI(type: HeaderType) {
        switch type {
            
        case .googlePlaySearchResult:
            titleLabel.text = "Google Play 검색결과"
        case .myLibrarySearchResult:
            titleLabel.text = "내 라이브러리 검색결과"
        default:
            titleLabel.text = ""
        }
    }
}


