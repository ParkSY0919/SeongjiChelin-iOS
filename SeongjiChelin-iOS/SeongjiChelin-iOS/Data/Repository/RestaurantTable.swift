//
//  RestaurantTable.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/11/25.
//

import Foundation

import RealmSwift

final class RestaurantTable: Object {
    
//    @Persisted(primaryKey: true) var id: ObjectId // PK
    @Persisted(primaryKey: true) var storeID: String // PK: 스토어 이름
    @Persisted var isVisited: Bool = false // 방문 여부
    @Persisted var isFavorite: Bool = false // 즐겨찾기 여부
    @Persisted var rating: Double? // 평점 (5점 만점)
    @Persisted var review: String? // 리뷰 내용
    
    convenience init(
        storeID: String,
        isVisited: Bool,
        isFavorite: Bool,
        rating: Double?,
        review: String?
    ) {
        self.init()
        self.storeID = storeID
        self.isVisited = isVisited
        self.isFavorite = isFavorite
        self.rating = rating
        self.review = review
    }
    
}
