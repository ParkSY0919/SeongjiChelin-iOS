//
//  RestaurantRepository.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/11/25.
//

import Foundation

import RealmSwift

protocol RestaurantRepositoryProtocol {
    func getFileURL()
    func getTableByStoreID(storeID: String) -> RestaurantTable?
    func fetchAll() -> Results<RestaurantTable>
    func fetchVisited() -> Results<RestaurantTable>
    func fetchFavorites() -> Results<RestaurantTable>
    func fetchRated() -> Results<RestaurantTable>
    
    // LinkingObjects를 활용한 새로운 메서드들
    func initializeRestaurantBridges()
    func fetchBridgesByComplexFilter(themeType: RestaurantThemeType?, category: String?, isVisited: Bool?, isFavorite: Bool?, hasRating: Bool?) -> Results<RestaurantBridge>
    func fetchMyRestaurantData() -> [(restaurant: Restaurant, userData: RestaurantTable?)]
    func getRestaurantBridge(storeID: String) -> RestaurantBridge?
    
    func upsertRestaurant(storeID: String, isVisited: Bool?, isFavorite: Bool?, rating: Double?, review: String?, handler: @escaping (Bool) -> Void)
    func createItem(storeID: String, isVisited: Bool?, isFavorite: Bool?, rating: Double?, review: String?, handler: @escaping (Bool) -> Void)
    func updateItem(data: RestaurantTable, isVisited: Bool?, isFavorite: Bool?, rating: Double?, review: String?, handler: @escaping (Bool) -> Void)
}


final class RestaurantRepository: RestaurantRepositoryProtocol {
    
    private let realm = try! Realm()
    
    /// 앱 시작 시 브릿지 데이터 초기화
    func initializeRestaurantBridges() {
        let existingBridges = Set(realm.objects(RestaurantBridge.self).map { $0.storeID })
        let allRestaurants = RestaurantLiterals.allRestaurantThemesData
        
        performRealmWrite(handler: { success in
            if success {
                print("브릿지 초기화 성공")
            } else {
                print("브릿지 초기화 실패")
            }
        }) { realm in
            for restaurant in allRestaurants {
                if !existingBridges.contains(restaurant.storeID) {
                    let bridge = RestaurantBridge(from: restaurant)
                    realm.add(bridge)
                }
            }
        }
    }
    
    /// 현재 사용자 기준 복합 조건 필터링 (LinkingObjects 활용)
    func fetchBridgesByComplexFilter(
        themeType: RestaurantThemeType? = nil,
        category: String? = nil,
        isVisited: Bool? = nil,
        isFavorite: Bool? = nil,
        hasRating: Bool? = nil
    ) -> Results<RestaurantBridge> {
        
        var query = realm.objects(RestaurantBridge.self)
        
        // 테마별 필터링 (인덱스 활용)
        if let themeType = themeType {
            query = query.filter("themePrefix == %@", themeType.idPrefix)
        }
        
        // 카테고리 필터링 (인덱스 활용)
        if let category = category {
            query = query.filter("category == %@", category)
        }
        
        // 현재 사용자의 방문 여부
        if let isVisited = isVisited {
            if isVisited {
                query = query.filter("ANY userData.isVisited == true")
            } else {
                query = query.filter("NONE userData.isVisited == true OR userData.@count == 0")
            }
        }
        
        // 현재 사용자의 즐겨찾기 여부
        if let isFavorite = isFavorite {
            if isFavorite {
                query = query.filter("ANY userData.isFavorite == true")
            } else {
                query = query.filter("NONE userData.isFavorite == true OR userData.@count == 0")
            }
        }
        
        // 현재 사용자의 평점 존재 여부
        if let hasRating = hasRating {
            if hasRating {
                query = query.filter("ANY userData.hasRating == true")
            } else {
                query = query.filter("NONE userData.hasRating == true OR userData.@count == 0")
            }
        }
        
        return query
    }
    
    /// 모든 식당과 현재 사용자 데이터를 함께 가져오기
    func fetchMyRestaurantData() -> [(restaurant: Restaurant, userData: RestaurantTable?)] {
        let bridges = realm.objects(RestaurantBridge.self)
        
        return bridges.compactMap { bridge in
            guard let restaurant = bridge.restaurantInfo else { return nil }
            return (restaurant: restaurant, userData: bridge.currentUserData)
        }
    }
    
    /// 특정 식당의 브릿지 가져오기
    func getRestaurantBridge(storeID: String) -> RestaurantBridge? {
        return realm.objects(RestaurantBridge.self).filter("storeID == %@", storeID).first
    }
    
    func getTableByStoreID(storeID: String) -> RestaurantTable? {
        let result = realm.objects(RestaurantTable.self).filter("storeID == %@", storeID).first
        print("Search result: \(result != nil ? "Found" : "Not found")")
        return result
    }

    func getFileURL() {
        print(realm.configuration.fileURL ?? "getFileURL Error", "getFileURL")
    }

    func fetchAll() -> Results<RestaurantTable> {
        return realm.objects(RestaurantTable.self)
    }

    func fetchVisited() -> Results<RestaurantTable> {
        return realm.objects(RestaurantTable.self).filter("isVisited == true")
    }

    func fetchFavorites() -> Results<RestaurantTable> {
        return realm.objects(RestaurantTable.self).filter("isFavorite == true")
    }

    func fetchRated() -> Results<RestaurantTable> {
        return realm.objects(RestaurantTable.self).filter("hasRating == true")  // hasRating 사용
    }
    
    func upsertRestaurant(storeID: String,
                          isVisited: Bool? = nil,
                          isFavorite: Bool? = nil,
                          rating: Double? = nil,
                          review: String? = nil,
                          handler: @escaping (Bool) -> Void) {
        // 업데이트할 데이터가 전혀 없으면 즉시 종료
        guard isVisited != nil || isFavorite != nil || rating != nil || review != nil else {
            handler(false)
            return
        }
        
        if let data = getTableByStoreID(storeID: storeID) {
            // 기존 데이터가 있으면 업데이트
            updateItem(data: data, isVisited: isVisited, isFavorite: isFavorite, rating: rating, review: review, handler: handler)
        } else {
            // 없으면 새로 생성
            createItem(storeID: storeID, isVisited: isVisited, isFavorite: isFavorite, rating: rating, review: review, handler: handler)
        }
    }
    
    func createItem(
        storeID: String,
        isVisited: Bool?,
        isFavorite: Bool?,
        rating: Double?,
        review: String?,
        handler: @escaping (Bool) -> Void
    ) {
        performRealmWrite(handler: handler) { realm in
            let data = RestaurantTable(
                storeID: storeID,
                isVisited: isVisited ?? false,
                isFavorite: isFavorite ?? false,
                rating: rating,
                review: review
            )
            
            // 브릿지와 관계 설정 (LinkingObjects 활용을 위해 중요!)
            if let bridge = realm.objects(RestaurantBridge.self).filter("storeID == %@", storeID).first {
                data.restaurantBridge = bridge
            } else {
                // 브릿지가 없으면 생성 (혹시나 하는 방어 코드)
                if let restaurant = RestaurantLiterals.allRestaurantThemesData.first(where: { $0.storeID == storeID }) {
                    let bridge = RestaurantBridge(from: restaurant)
                    realm.add(bridge)
                    data.restaurantBridge = bridge
                }
            }
            
            realm.add(data)
        }
    }

    func updateItem(
        data: RestaurantTable,
        isVisited: Bool?,
        isFavorite: Bool?,
        rating: Double?,
        review: String?,
        handler: @escaping (Bool) -> Void
    ) {
        performRealmWrite(handler: handler) { realm in
            if let isVisited = isVisited {
                data.isVisited = isVisited
            }
            if let isFavorite = isFavorite {
                data.isFavorite = isFavorite
            }
            if let rating = rating {
                data.setRating(rating)
            }
            if let review = review {
                data.review = review
            }
            // 업데이트 시간 갱신
            data.updateTimestamp()
        }
    }
    
    // Realm 쓰기 작업을 수행하는 헬퍼 메서드
    private func performRealmWrite(handler: @escaping (Bool) -> Void, _ writeBlock: (Realm) -> Void) {
        do {
            try realm.write {
                writeBlock(realm)
            }
            print("realm 업데이트 성공")
            handler(true)
        } catch {
            print("realm 업데이트 실패: \(error)")
            handler(false)
        }
    }
}

extension RestaurantRepository {
    
    /// 내 통계 데이터 가져오기
    func getMyStatistics() -> (visited: Int, favorites: Int, rated: Int, totalRestaurants: Int) {
        let visited = fetchVisited().count
        let favorites = fetchFavorites().count
        let rated = fetchRated().count
        let total = RestaurantLiterals.allRestaurantThemesData.count
        
        return (visited: visited, favorites: favorites, rated: rated, totalRestaurants: total)
    }
    
    /// 테마별 내 활동 통계
    func getMyThemeStatistics(themeType: RestaurantThemeType) -> (visited: Int, favorites: Int, rated: Int, total: Int) {
        let bridges = fetchBridgesByComplexFilter(themeType: themeType, category: nil, isVisited: nil, isFavorite: nil, hasRating: nil)
        
        let visited = bridges.filter("ANY userData.isVisited == true").count
        let favorites = bridges.filter("ANY userData.isFavorite == true").count
        let rated = bridges.filter("ANY userData.hasRating == true").count  // hasRating 사용
        let total = bridges.count
        
        return (visited: visited, favorites: favorites, rated: rated, total: total)
    }
    
    //TODO: 추후 추천기능에 적용
    /// 내가 아직 가지 않은 즐겨찾기 식당들
    func getMyWishlist() -> Results<RestaurantBridge> {
        return fetchBridgesByComplexFilter(
            themeType: nil,
            category: nil,
            isVisited: false,
            isFavorite: true,
            hasRating: nil
        )
    }
    
}
