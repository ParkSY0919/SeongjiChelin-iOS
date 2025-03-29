//
//  NetworkService.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/28/25.
//

import Alamofire

import RxSwift

final class NetworkService: NetworkServiceProvider {
    
    static let shared = NetworkService()
    
    private init() { }
    
    func callRequest<T: TargetTypeProtocol, R: Decodable>(
        router: T,
        responseType: R.Type
    ) -> Observable<Result<R, T.ErrorType>> {
        return Observable<Result<R, T.ErrorType>>.create { observer in
            AF.request(router)
                .validate(statusCode: 200...299)
                .responseDecodable(of: R.self) { response in
                    switch response.result {
                    case .success(let value):
                        observer.onNext(.success(value))
                        observer.onCompleted()
                    case .failure(let error):
                        let error = router.throwError(error)
                        observer.onNext(.failure(error))
                        observer.onCompleted()
                    }
                }
            return Disposables.create()
        }
    }
}
