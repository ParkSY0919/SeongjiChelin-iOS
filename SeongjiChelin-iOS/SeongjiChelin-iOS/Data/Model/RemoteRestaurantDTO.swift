//
//  RemoteRestaurantDTO.swift
//  SeongjiChelin-iOS
//
//  Created by Claude on 12/27/25.
//

import Foundation

/// Firebase에서 받아오는 전체 데이터 구조
struct RemoteRestaurantData: Codable {
    let version: String
    let lastUpdated: String
    let themes: [RemoteRestaurantTheme]

    /// Date 타입으로 변환된 lastUpdated
    var lastUpdatedDate: Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: lastUpdated) ?? ISO8601DateFormatter().date(from: lastUpdated)
    }
}

/// 테마 DTO
struct RemoteRestaurantTheme: Codable {
    let themeType: String
    let displayName: String
    let restaurants: [RemoteRestaurant]

    /// RestaurantThemeType으로 변환
    var themeTypeEnum: RestaurantThemeType? {
        return RestaurantThemeType.allCases.first { $0.idPrefix == themeType }
    }

    /// RestaurantTheme으로 변환
    func toRestaurantTheme() -> RestaurantTheme? {
        guard let themeType = themeTypeEnum else { return nil }
        let restaurants = self.restaurants.map { $0.toRestaurant() }
        return RestaurantTheme(themeType: themeType, restaurants: restaurants)
    }
}

/// 식당 DTO
struct RemoteRestaurant: Codable {
    let storeID: String
    let name: String
    let category: String
    let number: String
    let address: String
    let menus: [String]
    let closedDays: String
    let breakTime: String?
    let businessHours: [String: String]
    let amenities: String
    let latitude: Double
    let longitude: Double
    let youtubeId: String?
    let psyReview: String?

    // 새로 추가되는 필드 (선택적)
    let externalLinks: ExternalLinks?
    let aggregatedRating: AggregatedRating?
    let lastVerified: String?
    let verificationStatus: String?

    /// Restaurant로 변환
    func toRestaurant() -> Restaurant {
        return Restaurant(
            storeID: storeID,
            name: name,
            category: category,
            number: number,
            address: address,
            menus: menus,
            closedDays: closedDays,
            breakTime: breakTime,
            businessHours: businessHours,
            amenities: amenities,
            latitude: latitude,
            longitude: longitude,
            youtubeId: youtubeId,
            psyReview: psyReview,
            externalLinks: externalLinks,
            aggregatedRating: aggregatedRating
        )
    }
}

/// 버전 정보 DTO
struct RemoteVersionInfo: Codable {
    let version: String
    let lastUpdated: String
    let downloadUrl: String?

    /// Date 타입으로 변환된 lastUpdated
    var lastUpdatedDate: Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: lastUpdated)
    }
}
