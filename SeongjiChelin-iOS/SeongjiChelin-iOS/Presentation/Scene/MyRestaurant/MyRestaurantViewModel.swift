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
        let tableCellTapped: ControlEvent<Restaurant>
        let backButtonTapped: ControlEvent<()>
    }
    
    struct Output {
        let restaurants: Driver<[Restaurant]>
        let isEmpty: Driver<Bool>
        let tableCellTrigger: Driver<Restaurant>
        let backButtonTrigger: Driver<()>
    }
    
    private let repo: RestaurantRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    private let restaurantsRelay = BehaviorRelay<[Restaurant]>(value: [])
    
    init(repo: RestaurantRepositoryProtocol) {
        self.repo = repo
    }
    
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
        let allStaticRestaurants = RestaurantLiterals.allRestaurantThemesData

        var filteredTableResults = [String]()
        switch filter {
        case .all:
            restaurantsRelay.accept(allStaticRestaurants)
            return
        case .visited:
            filteredTableResults = repo.fetchVisited().map { $0.storeID }
        case .favorite:
            filteredTableResults = repo.fetchFavorites().map { $0.storeID }
        case .rated:
            filteredTableResults = repo.fetchRated().map { $0.storeID }
    
        }

        let finalRestaurants = allStaticRestaurants.filter { staticRestaurant in
            filteredTableResults.contains(staticRestaurant.storeID)
        }

        restaurantsRelay.accept(finalRestaurants)
    }
    
}
