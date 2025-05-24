//
//  RestaurantTable.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/11/25.
//

import Foundation

import RealmSwift

final class RestaurantTable: Object {
    
    @Persisted(primaryKey: true) var storeID: String
    @Persisted(indexed: true) var isVisited: Bool = false
    @Persisted(indexed: true) var isFavorite: Bool = false
    @Persisted var rating: Double?
    @Persisted(indexed: true) var hasRating: Bool = false
    @Persisted var review: String?
    @Persisted var createdAt: Date = Date()
    @Persisted var updatedAt: Date = Date()
    
    // RestaurantBridge와의 관계 설정
    @Persisted var restaurantBridge: RestaurantBridge?
    
    /// 연결된 Restaurant 정보
    var restaurantInfo: Restaurant? {
        return restaurantBridge?.restaurantInfo
    }
    
    /// 테마 타입 가져오기
    var themeType: RestaurantThemeType? {
        return restaurantBridge?.themeType
    }
    
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
        self.hasRating = (rating != nil)
        self.review = review
    }
    
    /// 업데이트 시간 갱신
    func updateTimestamp() {
        self.updatedAt = Date()
    }
    
    /// 평점 설정 시 hasRating도 함께 업데이트
    func setRating(_ newRating: Double?) {
        self.rating = newRating
        self.hasRating = (newRating != nil)
        updateTimestamp()
    }
    
}

// MARK: - Restaurant Extension (테마 타입 가져오기)
extension Restaurant {
    /// 이 식당의 테마 타입 찾기
    var themeType: RestaurantThemeType? {
        for theme in RestaurantLiterals.allRestaurantThemes {
            if theme.restaurants.contains(where: { $0.storeID == self.storeID }) {
                return theme.themeType
            }
        }
        return nil
    }
    
    /// 해당 식당의 사용자 데이터 가져오기
    func getUserData(from realm: Realm) -> RestaurantTable? {
        return realm.objects(RestaurantTable.self).filter("storeID == %@", self.storeID).first
    }
    
}
