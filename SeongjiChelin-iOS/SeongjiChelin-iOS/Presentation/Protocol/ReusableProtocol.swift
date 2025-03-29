//
//  ReusableProtocol.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/29/25.
//

protocol ReusableViewProtocol {
    static var identifier: String { get }
}

extension ReusableViewProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
