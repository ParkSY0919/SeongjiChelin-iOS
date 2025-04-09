//
//  DetailViewModel.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/6/25.
//

import Foundation

import RxCocoa
import RxSwift
import YouTubePlayerKit

final class DetailViewModel: ViewModelProtocol {
    
    let youtubePlayer: YouTubePlayer
    let restaurantInfo: Restaurant
    private lazy var restaurantInfoSubject = BehaviorRelay<Restaurant>(value: self.restaurantInfo)
    private lazy var youtubeInfoSubject = BehaviorRelay<String?>(value: self.restaurantInfo.youtubeId)
    
    init(restaurantInfo: Restaurant) {
        self.restaurantInfo = restaurantInfo
        self.youtubePlayer = YouTubePlayer(source: .video(id: restaurantInfo.youtubeId ?? ""), configuration: .init(fullscreenMode: .system))
    }
    
    struct Input {
        let dismissTapped: ControlEvent<Void>
    }
    
    struct Output {
        let dismissTrigger: Driver<Void>
        let restaurantInfo: Driver<Restaurant>
        let youtubeInfo: Driver<String?>
    }
    
    func transform(input: Input) -> Output {
        let restaurantInfo = restaurantInfoSubject.asDriver(onErrorDriveWith: .empty())
        let youtubeInfo = youtubeInfoSubject.asDriver()
        
        return Output(
            dismissTrigger: input.dismissTapped.asDriver(),
            restaurantInfo: restaurantInfo,
            youtubeInfo: youtubeInfo
        )
    }
    
    func updateRestaurantInfo(_ restaurant: Restaurant) {
        self.restaurantInfoSubject.accept(restaurant)
        self.youtubeInfoSubject.accept(restaurant.youtubeId)
    }
    
}
