//
//  OnboardingViewModel.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/13/25.
//

import Foundation

import RxCocoa

final class OnboardingViewModel: ViewModelProtocol {
    
    struct Input {
        let skipButtonTapped: ControlEvent<Void>
        let nextButtonTapped: ControlEvent<Void>
        let startButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let skipButtonTrigger: Driver<Void>
        let nextButtonTrigger: Driver<Void>
        let startButtonTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        return Output(
            skipButtonTrigger: input.skipButtonTapped.asDriver(),
            nextButtonTrigger: input.nextButtonTapped.asDriver(),
            startButtonTrigger: input.startButtonTapped.asDriver()
        )
    }
    
}
