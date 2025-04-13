//
//  MyRestaurantViewModel.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/12/25.
//

import Foundation

import RealmSwift
import RxCocoa
import RxSwift

final class MyRestaurantViewModel: ViewModelProtocol {
    
    struct Input {
        let filterType: SJFilterType
    }
    
    struct Output {
        let restaurants: BehaviorRelay<[RestaurantTable]>
    }
    
    // MARK: - Properties
    
    private let repo: RestaurantRepositoryProtocol = RestaurantRepository()
    private let disposeBag = DisposeBag()
    
    let restaurantsRelay = BehaviorRelay<[RestaurantTable]>(value: [])
    
    // MARK: - Methods
    
    func transform(input: Input) -> Output {
        fetchRestaurants(filter: input.filterType)
        return Output(restaurants: restaurantsRelay)
    }
    
    func fetchRestaurants(filter: SJFilterType) {
        var restaurants: Results<RestaurantTable>
        
        switch filter {
        case .all:
            // 방문, 즐겨찾기, 평점 중 하나라도 설정된 레스토랑
            restaurants = repo.fetchAll().filter("isVisited == true OR isFavorite == true OR rating != nil")
        case .visited:
            restaurants = repo.fetchVisited()
        case .favorite:
            restaurants = repo.fetchFavorites()
        case .rated:
            restaurants = repo.fetchRated()
        }
        
        // Realm Results를 Array로 변환
        let restaurantArray = Array(restaurants)
        restaurantsRelay.accept(restaurantArray)
        
        // 불필요한 데이터 정리
        _ = repo.cleanupUnusedTables()
    }
} 
