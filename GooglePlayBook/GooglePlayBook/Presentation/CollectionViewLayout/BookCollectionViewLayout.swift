//
//  BookCollectionViewLayout.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/6/24.
//

import Foundation
import UIKit

protocol BookCollectionViewLayout {
    func createListLayout() -> UICollectionViewLayout
    func emitDataEBookSource(items: [EBook], hasMore: Bool) -> [SearchResultSectionModel]
    func emitDataMylibrary(items:[Bookshelf]) -> [SearchResultSectionModel]
}

extension BookCollectionViewLayout {
    
    func createListLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(90))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 0
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
    
    func emitDataEBookSource(items: [EBook], hasMore: Bool) -> [SearchResultSectionModel] {
        let segmentSection = SearchResultSectionModel.segmentSection
        let ebookItemSection = SearchResultSectionModel.eBookItemSection(items: items.isEmpty ? [SearchResultSectionItem.emptyView] :
                                                                            items.map {
                                                                                SearchResultSectionItem.eBookItem(item: $0) })
        let loadMoreSection = SearchResultSectionModel.loadMoreSection(item: hasMore ? [SearchResultSectionItem.loadMore] : [])
        return [segmentSection,ebookItemSection,loadMoreSection]
    }
    
    func emitDataMylibrary(items:[Bookshelf]) -> [SearchResultSectionModel] {
        let segmentSection = SearchResultSectionModel.segmentSection
        let myLibrarySection = SearchResultSectionModel.myLibrarySection(item: items.map {
            SearchResultSectionItem.bookshelf(item: $0) })
        return [segmentSection,myLibrarySection]
    }
    
    func emitDataBookShelf(items:[EBook]) -> [SearchResultSectionModel] {
        let ebookItemSection = SearchResultSectionModel.eBookItemSection(items: items.map {
            SearchResultSectionItem.eBookItem(item: $0) })
        return [ebookItemSection]
    }
}
