//
//  RestaurantTable.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/11/25.
//

import Foundation

import RealmSwift

final class RestaurantTable: Object, Identifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId // PK
    @Persisted var storeID: String
    @Persisted var youtubeId: String?
    @Persisted var name: String
    @Persisted var category: String
    @Persisted var number: String
    @Persisted var openingHours: String
    @Persisted var address: String
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    @Persisted var menus: List<String>
    @Persisted var closedDays: String
    @Persisted var amenities: String
    @Persisted var isVisited: Bool = false //방문 여부
    @Persisted var isFavorite: Bool = false //즐겨찾기 여부
    @Persisted var rating: Double? //평점 (5점 만점)
    @Persisted var review: String? //리뷰 내용

    convenience init(storeID: String, youtubeId: String? = nil, name: String, category: String, number: String, openingHours: String, address: String, latitude: Double, longitude: Double, menus: List<String>, closedDays: String, amenities: String, isVisited: Bool = false, isFavorite: Bool = false, rating: Double? = nil, review: String? = nil) {
        self.init()
        self.storeID = storeID
        self.youtubeId = youtubeId
        self.name = name
        self.category = category
        self.number = number
        self.openingHours = openingHours
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.menus = menus
        self.closedDays = closedDays
        self.amenities = amenities
        self.isVisited = isVisited
        self.isFavorite = isFavorite
        self.rating = rating
        self.review = review
    }
    
}
