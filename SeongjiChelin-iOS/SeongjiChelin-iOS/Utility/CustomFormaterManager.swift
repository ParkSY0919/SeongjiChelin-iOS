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
    
    // 시간 포맷을 위한 메소드 추가
    func timeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current // 현재 시간대 사용
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }
    
    // 요일 변환을 위한 메소드 추가
    func weekdayString(from date: Date) -> String? {
        let weekday = Calendar.current.component(.weekday, from: date) // 1(일) ~ 7(토)
        let weekdayMap = [1: "일", 2: "월", 3: "화", 4: "수", 5: "목", 6: "금", 7: "토"]
        return weekdayMap[weekday]
    }
    
    func weekdayString(from dateString: String) -> Int? {
        let weekdayMap = ["월": 1, "화": 2, "수": 3, "목": 4, "금": 5, "토": 6, "토일": 7]
        return weekdayMap[dateString]
    }
    
}
