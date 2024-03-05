//
//  SearchQuery.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/1/24.
//

import Foundation

///intitle: 이 키워드 뒤에 오는 텍스트가 제목에 있는 결과를 반환합니다.
///inauthor: 이 키워드 다음에 오는 텍스트가 저자에 있는 결과를 반환합니다.
///inpublisher: 이 키워드 뒤에 오는 텍스트가 게시자에 있는 결과를 반환합니다.
///subject: 이 키워드 다음에 오는 텍스트가 볼륨의 카테고리 목록에 나열된 결과를 반환합니다.
///isbn: 이 키워드 뒤에 오는 텍스트가 ISBN 번호인 결과를 반환합니다.
///lccn: 이 키워드 다음에 오는 텍스트가 미국 의회도서관 제어 번호인 결과를 반환합니다.
///oclc: 이 키워드 뒤에 있는 텍스트가 온라인 컴퓨터 라이브러리 센터 번호인 결과를 반환합니다.
enum SpecialKeyword: String {
    case intitle
    case inauthor
    case inpublisher
    case subject
    case isbn
    case lccn
    case oclc
}

/// 볼륨 유형 및 사용 가능 여부로 검색결과를 필터링합니다.
enum SearchFilter: String {
    case partial   /// 텍스트의 일부분을 미리 볼 수 있는 볼륨으로 결과를 제한합니다.
    case full      ///    모든 텍스트가 표시되는 볼륨으로 결과를 제한합니다.
    case freeEbooks = "free-ebooks"  ///    무료 Google eBook으로 검색결과를 제한합니다.
    case paidEbooks = "paid-ebooks"  ///    구매 가격이 표시된 Google eBook으로 검색결과를 제한합니다.
    case ebooks
    /// 검색결과를 Google eBook(유료 또는 무료)으로 제한합니다.eBook이 아닌 예로는 제한된 미리보기로 제공되고 판매용으로 제공되지 않는 출판사 콘텐츠 또는 잡지가 있습니다.
}

enum OrderBy: String {
    case relevance    /// 가장 관련성이 높은 순서대로 검색결과를 반환합니다 (기본값).
    case newest       /// 최근 게시된 날짜부터 가장 오래된 날짜 순으로 검색결과를 반환합니다.
}

enum PrintType: String {
   case all            ///모든 볼륨 콘텐츠 유형을 반환합니다 (제한 없음). 이는 기본값입니다.
   case books          ///도서만 반환합니다.
   case magazines      ///잡지만 반환합니다.
}

enum projection: String {
    case full   ///모든 볼륨 메타데이터를 포함합니다 (기본값).
    case lite   ///볼륨 및 액세스 메타데이터의 제목만 포함합니다.
}

/// API 별 쿼리 매개변수중 검색수행 항목만 적용
///  q: 전체 텍스트 쿼리 문자열입니다.
struct SearchQuery {
    var q: String
    var filter: SearchFilter?
    var langRestrict: String? ///지정된 언어로 태그가 지정된 볼륨으로 반환되는 볼륨을 제한합니다.
    var orderBy: OrderBy?
    var printType: PrintType?
    var projection: projection?
    var maxResults: Int?      ///이 요청으로 반환할 최대 요소 수입니다.
    var startIndex: Int?      ///컬렉션에서 결과 목록을 시작할 위치입니다.
    var specialKeyword: SpecialKeyword?
}
