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

protocol TopSegmentSegmentDelegate: AnyObject {
    var selectedIndex: Int { get }
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
        segmentControll.addTarget(self, action: #selector(semenetDidChange), for: .valueChanged)
    }
    
    @objc func semenetDidChange(_ sender: UISegmentedControl) {
        guard let delegate = delegate else { return }
        delegate.stateChange(index: sender.selectedSegmentIndex)
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
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
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


