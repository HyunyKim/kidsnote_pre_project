//
//  EBooksResponseDTO+Mapping.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/1/24.
//

import Foundation

struct EBooksResponseDTO: Decodable {
    let kind: String
    let totalItems: Int
    let items: [EBookDTO]
}

extension EBooksResponseDTO {
    struct EBookDTO: Decodable {
        let kind: String?
        let id: String
        let etag: String?
        let selfLink: String?
        let volumeInfo: VolumeInfo?
        let saleInfo: SaleInfo?
        let accessInfo: AccessInfo?
        let searchInfo: SearchInfo?
    }
}

extension EBooksResponseDTO.EBookDTO {
    struct VolumeInfo: Decodable {
        
        let title: String?
        let authors: [String]?
        let publisher: String?
        let publishedDate: String?
        let description: String?
        let industryIdentifiers: [IndustryIdentifiers]?
//            "readingModes": {
//                "text": false,
//                "image": true
//            },
        let pageCount: Int?
        let printType: String?
        let categories: [String]?
        let maturityRating: String?
        let imageLinks: ImageLinks?
        let language: String
        let previewLink: String
        let infoLink: String
        let canonicalVolumeLink: String
        }
}

extension EBooksResponseDTO.EBookDTO.VolumeInfo {
    struct IndustryIdentifiers: Decodable {
        let type: String?
        let identifier: String?
    }
    
    struct ImageLinks: Decodable {
        let smallThumbnail: String?
        let thumbnail: String?
        let small: String?
        let medium: String?
        let large: String?
        let extraLarge: String?
    }
}

extension EBooksResponseDTO.EBookDTO {
    struct SaleInfo: Decodable{
            let country: String?
            let saleability: String?
            let isEbook: Bool?
            let listPrice: ListPrice?
            let buyLink: String?
    }
}
extension EBooksResponseDTO.EBookDTO.SaleInfo {
    struct ListPrice: Decodable {
        let amount: Int
        let currencyCode: String
    }
}

extension EBooksResponseDTO.EBookDTO {
    struct AccessInfo: Decodable {
        
        let country: String?
                let viewability: String?
                let embeddable: Bool?
                let publicDomain: Bool?
                let textToSpeechPermission: String?
                let epub: Equb?
                let pdf: EBookPDF?
                let webReaderLink: String?
                let accessViewStatus: String?
                let quoteSharingAllowed: Bool?
            }
}

extension EBooksResponseDTO.EBookDTO {
    struct SearchInfo: Decodable {
        let textSnippet: String?
    }
}


extension EBooksResponseDTO.EBookDTO.AccessInfo {
    struct Equb: Decodable {
        let isAvailable: Bool?
    }
}

extension EBooksResponseDTO.EBookDTO.AccessInfo {
    struct EBookPDF: Decodable {
        let isAvailable: Bool?
        let acsTokenLink: String?
    }
}


extension EBooksResponseDTO {
    func toDomain() -> EBooksContainer {
        return .init(totalItems: totalItems, kind: kind, items: items.map({$0.toDomain()}))
    }
}

extension EBooksResponseDTO.EBookDTO {
    func toDomain() -> EBook {
        return .init(id: EBook.Identifier(id),
                     title: volumeInfo?.title,
                     authors: volumeInfo?.authors,
                     thumbNail: volumeInfo?.imageLinks?.smallThumbnail,
                     isEBook: saleInfo?.isEbook)
    }
    func toDomain() -> BookDetailInfo {
        return .init(id: BookDetailInfo.Identifier(id),
                     thumbNail: volumeInfo?.imageLinks?.medium,
                     title: volumeInfo?.title,
                     authors: volumeInfo?.authors,
                     isEBook: saleInfo?.isEbook,
                     pageCount: volumeInfo?.pageCount,
                     pdfURL: accessInfo?.pdf?.acsTokenLink,
                     webReaderLink: accessInfo?.webReaderLink,
                     description: volumeInfo?.description,
                     publisher: volumeInfo?.publisher,
                     publishedDate: volumeInfo?.publishedDate,
                     selfLink: selfLink)
    }
}
