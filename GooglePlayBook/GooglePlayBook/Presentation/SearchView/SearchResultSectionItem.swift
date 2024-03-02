//
//  SearchResultSectionItem.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/3/24.
//

import Foundation
import RxDataSources

enum SearchResultSectionItem {
    case EBookItem(item: EBook)
    case LoadMore
}

enum SearchResultSectionModel {
    case EBookItemSection(items: [SearchResultSectionItem])
    case LoadMoreSection(item: [SearchResultSectionItem])
}

extension SearchResultSectionModel: SectionModelType {
    typealias Item = SearchResultSectionItem
    
    var items: [SearchResultSectionItem] {
        switch self {
        case .EBookItemSection(items: let items):
            return items.map({$0})
        case .LoadMoreSection(item: let items):
            return items.map({$0})
        }
    }
    
    init(original orignal: SearchResultSectionModel, items:[SearchResultSectionItem]) {
        switch orignal {
        case .EBookItemSection(items: let items):
            self = .EBookItemSection(items: items)
        case .LoadMoreSection(item: let items):
            self = .LoadMoreSection(item: items)
        }
    }
}
