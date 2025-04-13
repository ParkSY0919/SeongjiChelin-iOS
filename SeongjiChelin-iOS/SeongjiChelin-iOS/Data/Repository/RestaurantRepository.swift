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
    func fetchAll() -> Results<RestaurantTable>
    func fetchVisited() -> Results<RestaurantTable>
    func fetchFavorites() -> Results<RestaurantTable>
    func fetchRated() -> Results<RestaurantTable>
    func fetchByRating(minRating: Double) -> Results<RestaurantTable>
    func createAndEditItem(checkTable: Bool, data: RestaurantTable, isVisited: Bool?, isFavorite: Bool?, rating: Double?, review: String?, handler: @escaping (Bool) -> Void)
    func deleteItem(data: RestaurantTable, handler: @escaping (Bool) -> Void)
    func getItemById(id: ObjectId) -> RestaurantTable?
    func cleanupUnusedTables() -> Int
    func deleteItemInUpdate(data: RestaurantTable)
}


final class RestaurantRepository: RestaurantRepositoryProtocol {
    
    private let realm = try! Realm()

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
    
    func fetchByRating(minRating: Double) -> Results<RestaurantTable> {
        return realm.objects(RestaurantTable.self).filter("rating >= %@", minRating)
    }

    func createAndEditItem(checkTable: Bool, data: RestaurantTable, isVisited: Bool? = nil, isFavorite: Bool? = nil, rating: Double? = nil, review: String? = nil, handler: @escaping (Bool) -> Void) {
        guard isVisited != nil || isFavorite != nil || rating != nil || review != nil else {
            handler(false)
            return
        }

        //식당 테이블 있는지 확인
        switch checkTable {
        case true: //있다면 업데이트
            do {
                try realm.write {
                    var updateData: [String: Any] = ["id": data.id]
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
        case false: //없다면 생성
            do {
                try realm.write {
                    realm.add(data)
                    print("realm 저장 성공한 경우")
                }
            } catch {
                print("realm 저장이 실패한 경우")
                handler(false)
            }
        }
    }
    
    func deleteItemInUpdate(data: RestaurantTable) {
        realm.delete(data)
    }

    func deleteItem(data: RestaurantTable, handler: @escaping (Bool) -> Void) {
        do {
            try realm.write {
                realm.delete(data)
                print("realm 데이터 삭제 성공")
                handler(true)
            }
        } catch {
            print("realm 데이터 삭제 실패")
            handler(false)
        }
    }

    func getItemById(id: ObjectId) -> RestaurantTable? {
        return realm.object(ofType: RestaurantTable.self, forPrimaryKey: id)
    }
    
    func cleanupUnusedTables() -> Int {
        let unusedTables = realm.objects(RestaurantTable.self)
            .filter("isVisited == false AND isFavorite == false AND rating == nil AND review == nil")
        
        let count = unusedTables.count
        
        do {
            try realm.write {
                realm.delete(unusedTables)
                print("미사용 테이블 \(count)개 삭제 성공")
            }
            return count
        } catch {
            print("미사용 테이블 삭제 실패: \(error.localizedDescription)")
            return 0
        }
    }
}
