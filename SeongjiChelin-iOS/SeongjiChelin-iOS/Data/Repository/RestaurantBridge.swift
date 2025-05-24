//
//  RestaurantBridge.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 5/24/25.
//

import Foundation
import RealmSwift

final class RestaurantBridge: Object {
    @Persisted(primaryKey: true) var storeID: String
    @Persisted(indexed: true) var themePrefix: String = ""
    @Persisted(indexed: true) var category: String = ""
    
    // LinkingObjects: 이 식당에 대한 현재 사용자의 데이터
    @Persisted var userData: LinkingObjects<RestaurantTable> = LinkingObjects(fromType: RestaurantTable.self, property: "restaurantBridge")
    
    /// 현재 사용자의 데이터
    var currentUserData: RestaurantTable? {
        return userData.first
    }
    
    /// 현재 사용자가 이 식당을 방문했는지 여부
    var isVisitedByCurrentUser: Bool {
        return currentUserData?.isVisited ?? false
    }
    
    /// 현재 사용자가 이 식당을 즐겨찾기했는지 여부
    var isFavoriteByCurrentUser: Bool {
        return currentUserData?.isFavorite ?? false
    }
    
    /// 현재 사용자가 이 식당에 평점을 남겼는지 여부
    var hasRatingByCurrentUser: Bool {
        return currentUserData?.rating != nil
    }
    
    /// 현재 사용자의 평점
    var currentUserRating: Double? {
        return currentUserData?.rating
    }
    
    /// 현재 사용자의 리뷰
    var currentUserReview: String? {
        return currentUserData?.review
    }
    
    /// 실제 Restaurant 정보 가져오기
    var restaurantInfo: Restaurant? {
        return RestaurantLiterals.allRestaurantThemesData.first { $0.storeID == self.storeID }
    }
    
    /// 테마 타입 가져오기
    var themeType: RestaurantThemeType? {
        for theme in RestaurantLiterals.allRestaurantThemes {
            if theme.restaurants.contains(where: { $0.storeID == self.storeID }) {
                return theme.themeType
            }
        }
        return nil
    }
    
    convenience init(from restaurant: Restaurant) {
        self.init()
        self.storeID = restaurant.storeID
        self.themePrefix = restaurant.storeID.components(separatedBy: "_").first ?? ""
        self.category = restaurant.category
    }
    
}

