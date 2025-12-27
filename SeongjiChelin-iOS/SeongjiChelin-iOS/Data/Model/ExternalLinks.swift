//
//  ExternalLinks.swift
//  SeongjiChelin-iOS
//
//  Created by Claude on 12/27/25.
//

import Foundation

/// 외부 플랫폼 링크 정보
struct ExternalLinks: Codable, Equatable {
    let kakaoPlaceUrl: String?
    let kakaoReviewUrl: String?
    let naverPlaceUrl: String?
    let naverReviewUrl: String?
    let googlePlaceUrl: String?
    let googleReviewUrl: String?

    init(
        kakaoPlaceUrl: String? = nil,
        kakaoReviewUrl: String? = nil,
        naverPlaceUrl: String? = nil,
        naverReviewUrl: String? = nil,
        googlePlaceUrl: String? = nil,
        googleReviewUrl: String? = nil
    ) {
        self.kakaoPlaceUrl = kakaoPlaceUrl
        self.kakaoReviewUrl = kakaoReviewUrl
        self.naverPlaceUrl = naverPlaceUrl
        self.naverReviewUrl = naverReviewUrl
        self.googlePlaceUrl = googlePlaceUrl
        self.googleReviewUrl = googleReviewUrl
    }

    /// 리뷰를 볼 수 있는 URL이 하나라도 있는지 확인
    var hasAnyReviewUrl: Bool {
        return kakaoReviewUrl != nil || naverReviewUrl != nil || googleReviewUrl != nil
    }

    /// 사용 가능한 리뷰 URL 목록
    var availableReviewUrls: [(platform: String, url: String)] {
        var urls: [(String, String)] = []
        if let url = kakaoReviewUrl { urls.append(("카카오맵", url)) }
        if let url = naverReviewUrl { urls.append(("네이버", url)) }
        if let url = googleReviewUrl { urls.append(("구글", url)) }
        return urls
    }
}
