//
//  SearchResultViewController.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/2/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import LevelOSLog

final class SearchResultViewController: UIViewController {
// UIComponents
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionview
    }()
    private let segmentControll: UISegmentedControl = TopSegmentControl(items: ["Ebook","AudioBook"])
    
// Variable
    @Inject private var viewModel: SearchViewModel
    private var disposeBag = DisposeBag()
    private let loadMoreSubject = PublishSubject<Void>()
    private let sectionModelSubject = BehaviorSubject<[SearchResultSectionModel]>(value: [])
    let searchKeywordSubject = PublishSubject<String>()
    
    override func viewDidLoad() {
        setUI()
        setdConstraints()
        setCollectionView()
        bindViewModel()
    }
    
    private func setUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(segmentControll)
        self.view.addSubview(collectionView)
        segmentControll.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
        segmentControll.setTitleTextAttributes([.foregroundColor: UIColor.blue, .font: UIFont.systemFont(ofSize: 13,weight: .semibold)], for: .selected)
        segmentControll.selectedSegmentIndex = 0
    }
    
    private func setdConstraints() {
        
        segmentControll.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top).offset(self.navigationController?.navigationBar.safeAreaInsets.top ?? 100)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.segmentControll.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setCollectionView() {
  
        collectionView.register(SearchResultItemCell.self, forCellWithReuseIdentifier: SearchResultItemCell.identifier)
        
        sectionModelSubject
            .bind(to: collectionView.rx.items(dataSource: sectionReloadDataSource()))
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: .init(searchKeyword: searchKeywordSubject, loadMoreAction: loadMoreSubject))
        
        output.searchResult
            .drive(onNext: { [weak self] result in
                switch result {
                case .success(let container):
                    self?.emitDataSource(data: container.items)
                case .failure(let error):
                    Log.error("Error", error)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func emitDataSource(data: [EBook]) {
        let ebookItemSection = SearchResultSectionModel.EBookItemSection(items: data.map {
            SearchResultSectionItem.EBookItem(item: $0) })
        let loadMoreSection = SearchResultSectionModel.LoadMoreSection(item: [])
        
        sectionModelSubject.onNext([ebookItemSection,loadMoreSection])
    }
    
    private func sectionReloadDataSource() -> RxCollectionViewSectionedReloadDataSource<SearchResultSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<SearchResultSectionModel> { dataSource, collectionView, indexPath, item in
            switch item {
            case .EBookItem(item: let item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultItemCell.identifier, for: indexPath)
                return cell
            case .LoadMore:
                return UICollectionViewCell()
            }
        }
    }

}
