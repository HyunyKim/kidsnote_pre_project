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
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: createBasicLayout())
        return collectionview
    }()
    
    
    // Variable
    @Inject private var viewModel: SearchViewModel
    private var disposeBag = DisposeBag()
    private let loadMoreSubject = PublishSubject<Void>()
    private let sectionModelSubject = BehaviorSubject<[SearchResultSectionModel]>(value: [])
    let searchKeywordSubject = PublishSubject<String>()
    
    override func viewDidLoad() {
        layoutUI()
        setCollectionView()
        bindViewModel()
    }
    
    private func createBasicLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 2
            switch sectionIndex {
            case 0,1:
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [header]
            default:
                break
            }
            return section
        }
        return layout
        
    }
    
    private func layoutUI() {
        self.view.backgroundColor = .systemBackground
        
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(self.view.safeAreaInsets.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setCollectionView() {
        collectionView.register(EBookInfoCell.self, forCellWithReuseIdentifier: EBookInfoCell.identifier)
        collectionView.register(LoadMoreCell.self, forCellWithReuseIdentifier: LoadMoreCell.identifier)
        collectionView.register(SearchResultResuableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchResultResuableView.identifier)
        collectionView.register(TopSegmentReuseableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TopSegmentReuseableView.identifier)
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        sectionModelSubject
            .bind(to: collectionView.rx.items(dataSource: sectionReloadDataSource()))
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: .init(searchKeyword: searchKeywordSubject, loadMoreAction: loadMoreSubject))
        
        output.searchResult
            .drive(onNext: { [weak self] result in
                switch result {
                case .success(let result):
                    self?.emitDataSource(items: result.items, hasMore: result.hasMore)
                case .failure(let error):
                    Log.error("Error", error)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func emitDataSource(items: [EBook], hasMore: Bool) {
        let segmentSection = SearchResultSectionModel.segmentSection
        let ebookItemSection = SearchResultSectionModel.eBookItemSection(items: items.map {
            SearchResultSectionItem.eBookItem(item: $0) })
        let loadMoreSection = SearchResultSectionModel.loadMoreSection(item: hasMore ? [SearchResultSectionItem.loadMore] : [])
        sectionModelSubject.onNext([segmentSection,ebookItemSection,loadMoreSection])
    }
    
    private func sectionReloadDataSource() -> RxCollectionViewSectionedReloadDataSource<SearchResultSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<SearchResultSectionModel>(
            configureCell: { dataSource, collectionView, indexPath, item in
                switch item {
                case .segment:
                    return UICollectionViewCell()
                case .eBookItem(item: let item):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EBookInfoCell.identifier, for: indexPath) as! EBookInfoCell
                    cell.updateUI(ebook: item)
                    
                    return cell
                case .loadMore:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadMoreCell.identifier, for: indexPath) as! LoadMoreCell
                    
                    return cell
                }
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                switch indexPath.section {
                case 0:
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TopSegmentReuseableView.identifier, for: indexPath) as! TopSegmentReuseableView
                    return header
                case 1:
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchResultResuableView.identifier, for: indexPath) as! SearchResultResuableView
                    header.updateUI(type: .googlePlaySearchResult )
                    return header
                default:
                    return UICollectionReusableView()
                }
            })
    }
}
extension SearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 2 , indexPath.row == 0 {
            loadMoreSubject.onNext(())
        }
    }
}
