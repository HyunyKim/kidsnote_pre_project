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
    case myShelfResult
}

protocol TopSegmentSegmentDelegate: AnyObject {
    var segmentSelectedIndex: Int { get }
    func stateChange(index: Int)
}

final class TopSegmentReuseableView: UICollectionReusableView {
    enum SegmentIndex: Int {
        case eBook = 0
        case myLibrary
        
        var title: String {
            switch self {
            case .eBook:
                return "eBook"
            case .myLibrary:
                return "MyLibrary"
            }
        }
    }
    private let segmentControll: UISegmentedControl = PlayBookSegmentControl(items: [SegmentIndex.eBook.title,SegmentIndex.myLibrary.title])
    weak var delegate: TopSegmentSegmentDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
    }
    
    private func layoutUI() {
        backgroundColor = .background
        addSubview(segmentControll)
        segmentControll.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        segmentControll.setTitleTextAttributes([.foregroundColor: UIColor(resource: .eLightGray)], for: .normal)
        segmentControll.setTitleTextAttributes([.foregroundColor: UIColor(resource: .eBlue), .font: UIFont.systemFont(ofSize: 13,weight: .semibold)], for: .selected)
        segmentControll.selectedSegmentIndex = 0
        segmentControll.addTarget(self, action: #selector(segmentDidChange), for: .valueChanged)
    }
    
    @objc func segmentDidChange(_ sender: UISegmentedControl) {
        guard let delegate = delegate else { return }
        delegate.stateChange(index: sender.selectedSegmentIndex)
    }
    
    func segmentChangeAction(index: Int) {
        segmentControll.selectedSegmentIndex = (SegmentIndex(rawValue: index) ?? .eBook).rawValue
    }
}

final class SearchResultResuableView: UICollectionReusableView {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        label.textAlignment = .left
        label.textColor = .textColor1
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
        backgroundColor = .background
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(16.0)
            make.trailing.equalToSuperview().inset(16.0)
            make.height.equalTo(44.0)
        }
    }
    
    func updateUI(type: HeaderType) {
        switch type {
            
        case .googlePlaySearchResult:
            titleLabel.text = "Google Play 검색결과"
        case .myLibrarySearchResult:
            titleLabel.text = "내 라이브러리 검색결과"
        case .myShelfResult:
            titleLabel.text = "나의 서가"
        default:
            titleLabel.text = ""
        }
    }
}


