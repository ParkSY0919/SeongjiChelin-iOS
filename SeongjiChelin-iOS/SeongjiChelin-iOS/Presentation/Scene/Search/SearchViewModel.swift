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
        let in_TapNavBackButton: ControlEvent<Void>
        let in_TapNavTextFieldReturnKey: ControlEvent<()>
        let in_NavTextFieldText: ControlProperty<String>
    }
    
    struct Output {
        let out_TapNavBackButton: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let out_TapNavBackButton = input.in_TapNavBackButton
            .asDriver()
        
        return Output(
            out_TapNavBackButton: out_TapNavBackButton
        )
    }
    
}

private extension SearchViewModel {
    
    
    func isValidSearchText(text: String) -> String? {
        if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return text
        } else {
            return nil
        }
    }
    
}
