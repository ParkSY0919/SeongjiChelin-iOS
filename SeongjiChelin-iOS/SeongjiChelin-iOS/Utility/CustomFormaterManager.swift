//
//  CustomFormaterManager.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/28/25.
//

import Foundation

final class CustomFormatterManager {
    
    static let shared = CustomFormatterManager()
    
    private init() {}
    
    func dateFormatter(date: Date?) -> String {
        guard let date else { return "실패" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd 방영" // 원하는 출력 형식
        formatter.timeZone = TimeZone(identifier: "UTC") // 입력이 UTC라면 UTC로 설정
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 로케일 사용 (선택적)
        return formatter.string(from: date)
    }
    
}

