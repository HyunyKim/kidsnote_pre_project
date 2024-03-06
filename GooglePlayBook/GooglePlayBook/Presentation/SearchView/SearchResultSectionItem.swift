//
//  SearchResultSectionItem.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/3/24.
//

import Foundation
import RxDataSources

enum SearchResultSectionItem {
    case segment
    case eBookItem(item: EBook)
    case loadMore
    case bookshelf(item: Bookshelf)
}

enum SearchResultSectionModel {
    case segmentSection
    case eBookItemSection(items: [SearchResultSectionItem])
    case loadMoreSection(item: [SearchResultSectionItem])
    case myLibrarySection(item:[SearchResultSectionItem])
    
    static func sectionItem(index: Int) -> SearchResultSectionModel {
        switch index {
        case 0:
            return SearchResultSectionModel.segmentSection
        case 1:
            return SearchResultSectionModel.eBookItemSection(items: [])
        case 2:
            return SearchResultSectionModel.loadMoreSection(item: [])
        case 3:
            return SearchResultSectionModel.myLibrarySection(item: [])
        default:
            return SearchResultSectionModel.segmentSection
        }
    }
}

extension SearchResultSectionModel: SectionModelType {
    typealias Item = SearchResultSectionItem
    
    var items: [SearchResultSectionItem] {
        switch self {
        case .segmentSection:
            return []
        case .eBookItemSection(items: let items):
            return items.map({$0})
        case .loadMoreSection(item: let items):
            return items.map({$0})
        case .myLibrarySection(item: let items):
            return items.map({$0})

        }
    }
    
    init(original: SearchResultSectionModel, items:[SearchResultSectionItem]) {
        switch original {
        case .segmentSection:
            self = .segmentSection
        case .eBookItemSection(items: let items):
            self = .eBookItemSection(items: items)
        case .loadMoreSection(item: let items):
            self = .loadMoreSection(item: items)
        case .myLibrarySection(item: let items):
            self = .myLibrarySection(item: items)
        }
    }
}
