//
//  BookDetailSectionItems.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/4/24.
//

import Foundation
import RxDataSources

enum BookDetailSectionItem {
    case userAction(link: String)
    case bookDescription(description: String)
    case ratingInfo(item: BookDetailInfo)
    case publishInfo(publishing: String)
}

enum BookDetailInfoSectionModel {
    case bookInformationSection(items: [BookDetailSectionItem])
}

extension BookDetailInfoSectionModel: SectionModelType {
    typealias Item = BookDetailSectionItem
    
    var items: [BookDetailSectionItem] {
        switch self {
        case .bookInformationSection(items: let items):
            return items.map({$0})
        }
    }
    
    init(original: BookDetailInfoSectionModel, items: [BookDetailSectionItem]) {
        switch original {
        case .bookInformationSection(items: let items):
            self = .bookInformationSection(items: items)
        }
    }
}
