//
//  SearchViewModel.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/20/25.
//

import Foundation

import RealmSwift
import RxCocoa
import RxSwift

final class SearchViewModel: ViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let navBackButtonTapped: ControlEvent<Void>
        let returnKeyTapped: ControlEvent<()>
        let searchTextFieldText: ControlProperty<String>
    }
    
    struct Output {
        let navBackButtonTrigger: Driver<Void>
        let returnKeyTrigger: Driver<Void>
        let filterRestaurantList: Driver<[Restaurant]>
        let scrollTopTrigger: PublishRelay<Void>
    }
    
    private let allRestaurants: [Restaurant] = RestaurantLiterals.allRestaurantThemesData
    
    func transform(input: Input) -> Output {
        let scrollTop = PublishRelay<Void>()
        
        let filteredListDriver = input.searchTextFieldText
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .compactMap { [weak self] searchText -> [Restaurant] in
                guard let self else { return [] }
                let result =  self.filterRestaurant(text: searchText)
                scrollTop.accept(())
                return result
            }
            .asDriver(onErrorJustReturn: [])
        
        return Output(
            navBackButtonTrigger: input.navBackButtonTapped.asDriver(),
            returnKeyTrigger: input.returnKeyTapped.asDriver(),
            filterRestaurantList: filteredListDriver,
            scrollTopTrigger: scrollTop
        )
    }
    
}

private extension SearchViewModel {
    
    func filterRestaurant(text: String?) -> [Restaurant] {
        guard let searchText = text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !searchText.isEmpty else {
            return allRestaurants
        }
        
        //전체 레스토랑 목록 필터링
        let filtered = allRestaurants.filter { restaurant in
            //이름(name)에 검색어가 포함되는지 (대소문자 무시)
            let nameMatch = restaurant.name.localizedCaseInsensitiveContains(searchText)
            //카테고리(category)에 검색어가 포함되는지 (대소문자 무시)
            let categoryMatch = restaurant.category.localizedCaseInsensitiveContains(searchText)
            //주소(address)에 검색어가 포함되는지 (대소문자 무시)
            let addressMatch = restaurant.address.localizedCaseInsensitiveContains(searchText)
            
            //이름, 카테고리, 주소 중 하나라도 포함되면 true 반환
            return nameMatch || categoryMatch || addressMatch
        }
        
        return filtered
    }
    
}
