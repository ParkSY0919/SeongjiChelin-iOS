//
//  MenuViewModel.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/3/25.
//

import UIKit

import RxCocoa

final class MenuViewModel: ViewModelProtocol {

    var currentMenuItems: [String] {
        return menuItemsRelay.value
    }

    struct Input {
        let modelSelected: ControlEvent<String>
        let infoLabelTapped: ControlEvent<UITapGestureRecognizer>
    }

    struct Output {
        let menuItems: Driver<[String]>
        let selectedItemAction: Driver<String>
        let infoLabelTrigger: Driver<UITapGestureRecognizer>
    }

    private let menuItemsRelay = BehaviorRelay<[String]>(value: ["홈", "나만의 식당", "사용법"])

    func transform(input: Input) -> Output {
        let menuItemsDriver = menuItemsRelay.asDriver()
        let selectedItemDriver = input.modelSelected.asDriver()

        return Output(
            menuItems: menuItemsDriver,
            selectedItemAction: selectedItemDriver,
            infoLabelTrigger: input.infoLabelTapped.asDriver()
        )
    }
    
}
