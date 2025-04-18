//
//  HomeViewModel.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/3/25.
//

import Foundation

import RxCocoa
import RxSwift

final class HomeViewModel: ViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    private let currentFilterRelay = BehaviorRelay<RestaurantThemeType?>(value: nil)

    struct Input {
        let menuTapped: ControlEvent<Void>
        let micTapped: ControlEvent<Void>
        let selectedFilterTheme: Observable<RestaurantThemeType?>
    }

    struct Output {
        let menuTrigger: Driver<Void>
        let micTrigger: Driver<Void>
        let filteredList: Driver<[RestaurantTheme]>
    }

    func transform(input: Input) -> Output {
        // 입력된 필터 테마를 내부 상태(currentFilterRelay)에 바인딩
        input.selectedFilterTheme
            .bind(to: currentFilterRelay)
            .disposed(by: disposeBag)
        
        // 현재 필터 상태(currentFilterRelay)가 변경될 때마다 리스트 필터링
        let filteredListDriver = currentFilterRelay
            .map { [weak self] selectedThemeType -> [RestaurantTheme] in
                return self?.filterListOfType(selectedThemeType: selectedThemeType) ?? RestaurantLiterals.allRestaurantThemes
            }
            .asDriver(onErrorJustReturn: RestaurantLiterals.allRestaurantThemes)
        
        return Output(
            menuTrigger: input.menuTapped.asDriver(),
            micTrigger: input.micTapped.asDriver(),
            filteredList: filteredListDriver
        )
    }
    
}

// MARK: - Private Methods

private extension HomeViewModel {

    // 필터링 함수: 선택된 ThemeType에 따라 데이터 필터링
    func filterListOfType(selectedThemeType: RestaurantThemeType?) -> [RestaurantTheme] {
        let allData = RestaurantLiterals.allRestaurantThemes

        guard let themeType = selectedThemeType else {
            return allData
        }

        return allData.filter { $0.themeType == themeType }
    }
    
}
