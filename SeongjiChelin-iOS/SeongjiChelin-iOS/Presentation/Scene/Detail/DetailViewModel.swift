//
//  DetailViewModel.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/6/25.
//

import Foundation
import YouTubePlayerKit

final class DetailViewModel: ViewModelProtocol {
    
    let restaurantInfo: Restaurant
    let videoSource: YouTubePlayer.Source
    
    init(restaurantInfo: Restaurant) {
        self.restaurantInfo = restaurantInfo
        self.videoSource = .video(id: restaurantInfo.youtubeId ?? "")
    }
    
    struct Input {}
    
    struct Output {}
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
}
