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
    func getTableByStoreID(storeID: String) -> RestaurantTable? //일치하는 테이블
    func fetchAll() -> Results<RestaurantTable> //전체
    func fetchVisited() -> Results<RestaurantTable> //방문한 곳
    func fetchFavorites() -> Results<RestaurantTable> //저장한 곳
    func fetchRated() -> Results<RestaurantTable> //리뷰있는 곳
    func upsertRestaurant(storeID: String, isVisited: Bool?, isFavorite: Bool?, rating: Double?, review: String?, handler: @escaping (Bool) -> Void)
    //추가
    func createItem(storeID: String, isVisited: Bool?, isFavorite: Bool?, rating: Double?,
                    review: String?, handler: @escaping (Bool) -> Void)
    //수정
    func updateItem(data: RestaurantTable, isVisited: Bool?, isFavorite: Bool?, rating: Double?,
                    review: String?, handler: @escaping (Bool) -> Void)
}


final class RestaurantRepository: RestaurantRepositoryProtocol {
    
    private let realm = try! Realm()
    
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
        return realm.objects(RestaurantTable.self).filter("rating != nil")
    }
    
    func upsertRestaurant(storeID: String,
                          isVisited: Bool? = nil,
                          isFavorite: Bool? = nil,
                          rating: Double? = nil,
                          review: String? = nil,
                          handler: @escaping (Bool) -> Void) {
        //해당 식당에 대한 테이블 데이터가 있다면,,
        if let data = getTableByStoreID(storeID: storeID) {
            updateItem(data: data, isVisited: isVisited, isFavorite: isFavorite, rating: rating, review: review) { isSuccess in
                switch isSuccess {
                case true:
                    print("updateItem 성공")
                    handler(true)
                case false:
                    print("updateItem 실패")
                    handler(false)
                }
            }
        } else { //없다면,,
            createItem(storeID: storeID, isVisited: isVisited, isFavorite: isFavorite, rating: rating, review: review) { isSuccess in
                switch isSuccess {
                case true:
                    print("createItem 성공")
                    handler(true)
                case false:
                    print("createItem 실패")
                    handler(false)
                }
            }
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
        //테이블 데이터
        guard isVisited != nil || isFavorite != nil || rating != nil || review != nil else {
            handler(false)
            return
        }

        do {
            try realm.write {
                let data = RestaurantTable(
                    storeID: storeID,
                    isVisited: isVisited ?? false,
                    isFavorite: isFavorite ?? false,
                    rating: rating,
                    review: review
                )
                realm.add(data)
                print("realm 업데이트 성공")
                handler(true)
            }
        } catch {
            print("realm 업데이트 실패")
            handler(false)
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
        //테이블 데이터
        guard isVisited != nil || isFavorite != nil || rating != nil || review != nil else {
            handler(false)
            return
        }

        do {
            try realm.write {
                var updateData: [String: Any] = ["storeID": data.storeID]
                if let isVisited = isVisited {
                    updateData["isVisited"] = isVisited
                }
                if let isFavorite = isFavorite {
                    updateData["isFavorite"] = isFavorite
                }
                if let rating = rating {
                    updateData["rating"] = rating
                }
                if let review = review {
                    updateData["review"] = review
                }
                realm.create(RestaurantTable.self, value: updateData, update: .modified)
                print("realm 업데이트 성공")
                handler(true)
            }
        } catch {
            print("realm 업데이트 실패")
            handler(false)
        }
    }
    
}
