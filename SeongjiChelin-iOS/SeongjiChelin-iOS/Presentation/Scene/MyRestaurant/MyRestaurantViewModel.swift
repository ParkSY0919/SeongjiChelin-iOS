//
//  MyRestaurantViewModel.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/12/25.
//

import Foundation

import RxCocoa
import RxSwift

final class MyRestaurantViewModel: ViewModelProtocol {
    
    struct Input {
        let filterType: PublishSubject<SJFilterType>
        let tableCellTapped: ControlEvent<RestaurantTable>
        let backButtonTapped: ControlEvent<()>
    }
    
    struct Output {
        let restaurants: Driver<[RestaurantTable]>
        let isEmpty: Driver<Bool>
        let tableCellTrigger: Driver<RestaurantTable>
        let backButtonTrigger: Driver<()>
    }
    
    // MARK: - Properties
    
    private let repo: RestaurantRepositoryProtocol = RestaurantRepository()
    private let disposeBag = DisposeBag()
    
    private let restaurantsRelay = BehaviorRelay<[RestaurantTable]>(value: [])
    
    // MARK: - Methods
    
    func transform(input: Input) -> Output {
        input.filterType
            .subscribe(with: self, onNext: { owner, type in
                owner.fetchRestaurants(filter: type)
            })
            .disposed(by: disposeBag)
        
        let isEmpty = restaurantsRelay
                    .map { $0.isEmpty }
                    .asDriver(onErrorJustReturn: true)
        
        return Output(
            restaurants: restaurantsRelay.asDriver(),
            isEmpty: isEmpty,
            tableCellTrigger: input.tableCellTapped.asDriver(),
            backButtonTrigger: input.backButtonTapped.asDriver()
        )
    }
    
    func fetchRestaurants(filter: SJFilterType) {
        // 불필요한 데이터 정리 이후 전체 레스토랑 호출
        _ = repo.cleanupUnusedTables()
        var restaurants = repo.fetchAll()
        
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
    }
    
}
