//
//  AggregatedRating.swift
//  SeongjiChelin-iOS
//
//  Created by Claude on 12/27/25.
//

import Foundation

/// 통합 평점 정보 (3사 API에서 수집)
struct AggregatedRating: Codable, Equatable {
    let kakaoRating: Double?
    let kakaoReviewCount: Int?
    let naverRating: Double?
    let naverReviewCount: Int?
    let googleRating: Double?
    let googleReviewCount: Int?

    init(
        kakaoRating: Double? = nil,
        kakaoReviewCount: Int? = nil,
        naverRating: Double? = nil,
        naverReviewCount: Int? = nil,
        googleRating: Double? = nil,
        googleReviewCount: Int? = nil
    ) {
        self.kakaoRating = kakaoRating
        self.kakaoReviewCount = kakaoReviewCount
        self.naverRating = naverRating
        self.naverReviewCount = naverReviewCount
        self.googleRating = googleRating
        self.googleReviewCount = googleReviewCount
    }

    /// 평균 평점 계산
    var averageRating: Double? {
        let ratings = [kakaoRating, naverRating, googleRating].compactMap { $0 }
        guard !ratings.isEmpty else { return nil }
        return ratings.reduce(0, +) / Double(ratings.count)
    }

    /// 총 리뷰 수
    var totalReviewCount: Int {
        return [kakaoReviewCount, naverReviewCount, googleReviewCount]
            .compactMap { $0 }
            .reduce(0, +)
    }

    /// 가장 높은 평점
    var highestRating: Double? {
        return [kakaoRating, naverRating, googleRating].compactMap { $0 }.max()
    }

    /// 평점 정보가 하나라도 있는지 확인
    var hasAnyRating: Bool {
        return kakaoRating != nil || naverRating != nil || googleRating != nil
    }
}
