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
}

enum SearchResultSectionModel {
    case segmentSection
    case eBookItemSection(items: [SearchResultSectionItem])
    case loadMoreSection(item: [SearchResultSectionItem])
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

        }
    }
    
    init(original orignal: SearchResultSectionModel, items:[SearchResultSectionItem]) {
        switch orignal {
        case .segmentSection:
            self = .segmentSection
        case .eBookItemSection(items: let items):
            self = .eBookItemSection(items: items)
        case .loadMoreSection(item: let items):
            self = .loadMoreSection(item: items)
        }
    }
}
