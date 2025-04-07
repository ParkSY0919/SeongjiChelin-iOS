//
//  MenuViewModel.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/3/25.
//

import Foundation

import RxCocoa

final class MenuViewModel: ViewModelProtocol {

    let cellIdentifier = "MenuCell"
    var currentMenuItems: [String] {
        return menuItemsRelay.value
    }

    struct Input {
        let modelSelected: ControlEvent<String>
    }

    struct Output {
        let menuItems: Driver<[String]>
        let selectedItemAction: Driver<String>
    }

    private let menuItemsRelay = BehaviorRelay<[String]>(value: ["홈", "나만의 식당", "사용법"])

    func transform(input: Input) -> Output {
        let menuItemsDriver = menuItemsRelay.asDriver()
        let selectedItemDriver = input.modelSelected.asDriver()

        return Output(
            menuItems: menuItemsDriver,
            selectedItemAction: selectedItemDriver
        )
    }
    
}
