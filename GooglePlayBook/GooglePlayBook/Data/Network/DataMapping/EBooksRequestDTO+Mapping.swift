//
//  EBookRequestDTO+Mapping.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/2/24.
//

import Foundation

struct EbookItemsRequestDTO: ParameterEncodable {
    var q: String

    var filter: String?
    var langRestrict: String?
    var maxResults: Int?
    var orderBy: String?
    var printType: String?
    var projection: String?
    var startIndex: Int?
    
    init(q: String,
         filter: String? = nil,
         langRestrict: String? = nil,
         maxResults: Int? = nil,
         orderBy: String? = nil,
         printType: String? = nil,
         projection: String? = nil,
         startIndex: Int? = nil,
         specialKeyword: String? = nil )
    {
        self.q = specialKeyword != nil ? "\(q)+\(specialKeyword!)" : q
        self.filter = filter
        self.langRestrict = langRestrict
        self.maxResults = maxResults
        self.orderBy = orderBy
        self.printType = printType
        self.projection = projection
        self.startIndex = startIndex
    }
}
