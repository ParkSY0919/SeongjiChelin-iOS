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
    
    // 요일 변환을 위한 메소드 추가 (UI 표시용)
    func weekdayString(from date: Date) -> String? {
        let weekday = Calendar.current.component(.weekday, from: date)
        let weekdayMap = [
            1: StringLiterals.shared.sunday,    // 1 = 일요일
            2: StringLiterals.shared.monday,    // 2 = 월요일  
            3: StringLiterals.shared.tuesday,   // 3 = 화요일
            4: StringLiterals.shared.wednesday, // 4 = 수요일
            5: StringLiterals.shared.thursday,  // 5 = 목요일
            6: StringLiterals.shared.friday,    // 6 = 금요일
            7: StringLiterals.shared.saturday   // 7 = 토요일
        ]
        return weekdayMap[weekday]
    }
    
    // businessHours 데이터 키를 위한 메소드 추가 (항상 한글)
    func weekdayDataKey(from date: Date) -> String? {
        let weekday = Calendar.current.component(.weekday, from: date)
        let weekdayMap = [
            1: "일",  // 1 = 일요일
            2: "월",  // 2 = 월요일
            3: "화",  // 3 = 화요일
            4: "수",  // 4 = 수요일
            5: "목",  // 5 = 목요일
            6: "금",  // 6 = 금요일
            7: "토"   // 7 = 토요일
        ]
        return weekdayMap[weekday]
    }
    
    func weekdayString(from dateString: String) -> Int? {
        let weekdayMap = [
            StringLiterals.shared.monday: 1,
            StringLiterals.shared.tuesday: 2,
            StringLiterals.shared.wednesday: 3,
            StringLiterals.shared.thursday: 4,
            StringLiterals.shared.friday: 5,
            StringLiterals.shared.saturday: 6,
            StringLiterals.shared.sunday: 7
        ]
        return weekdayMap[dateString]
    }
    
}
