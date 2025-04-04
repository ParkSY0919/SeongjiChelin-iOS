//
//  HomeViewModel.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/3/25.
//

import Foundation

import RxCocoa

final class HomeViewModel: ViewModelProtocol {

    struct Input {
        let menuTapped: ControlEvent<Void>
        let micTapped: ControlEvent<Void>
    }

    struct Output {
        let menuTrigger: Driver<Void>
        let micTrigger: Driver<Void>
    }

    func transform(input: Input) -> Output {
        
        return Output(
            menuTrigger: input.menuTapped.asDriver(),
            micTrigger: input.micTapped.asDriver()
        )
    }
    
}

