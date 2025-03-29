//
//  StringLiterals.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/28/25.
//


import Foundation

enum StringLiterals {}

extension StringLiterals {
    
    enum Common {
        static let wantToSee = "보고싶어요"
        static let watched = "봤어요"
        static let watching = "보는중"
        static let comment = "코멘트"
        static let rating = "별점"
        static let cancel = "취소"
    }
    
    enum Home {
        static let trendingDramas = "실시간 인기 드라마"
        static func similarContent(for title: String) -> String {
            let lastChar = title.last!
            let needsWa = hasFinalConsonant(lastChar) ? "과" : "와"
            return "\(title) \(needsWa) 비슷한 컨텐츠"
        }
        
        ///한글의 받침 유무 판별 함수
        private static func hasFinalConsonant(_ char: Character) -> Bool {
            let scalar = char.unicodeScalars.first!.value
            let hangulBase: UInt32 = 0xAC00
            let hangulCount: UInt32 = 11172
            let jongseongCount: UInt32 = 28
            
            if scalar < hangulBase || scalar >= hangulBase + hangulCount {
                return false // 한글이 아니면 받침 없음으로 처리
            }
            
            let index = scalar - hangulBase
            let jongseongIndex = index % jongseongCount
            return jongseongIndex != 0 // 종성이 존재하면 true
        }
    }
    
    enum Search {
        static let popular = "인기"
        static let castAndCrew = "배우 및 제작진"
        static let tvShows = "TV 프로그램"
        static let movies = "영화"
    }
    
    enum Drama {
        static let details = "작품정보"
    }
    
    enum Episode {
        static let episode = "에피소드"
    }
    
    enum Library {
        static let library = "보관함"
    }
    
    enum ImageSize {
        static let w154 = "w154"
        static let w300 = "w300"
    }
    
}
