//
//  DetailViewModel.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/6/25.
//

import Foundation
import YouTubePlayerKit

final class DetailViewModel: ViewModelProtocol {
    
    private let restaurantInfo: Restaurant
    let videoSource: YouTubePlayer.Source
    
    init(restaurantInfo: Restaurant, videoId: String = "B4QWdVBGd9k") {
        self.restaurantInfo = restaurantInfo
        self.videoSource = .video(id: videoId)
    }
    
    struct Input {}
    
    struct Output {}
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
}
