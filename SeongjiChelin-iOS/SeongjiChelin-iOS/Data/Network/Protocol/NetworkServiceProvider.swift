//
//  NetworkServiceProvider.swift
//  EutCha-iOS
//
//  Created by BAE on 3/22/25.
//

import Foundation

import RxSwift

/// 네트워크 서비스 프로토콜입니다.
protocol NetworkServiceProvider {
    func callRequest<T: TargetTypeProtocol, R: Decodable>(
        router: T,
        responseType: R.Type
    ) -> Observable<Result<R, T.ErrorType>>
}
