//
//  ViewModelProtocol.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/29/25.
//

import Foundation

protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
