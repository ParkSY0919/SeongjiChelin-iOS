//
//  SJWeeklyScheduleView.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/10/25.
//

import UIKit

import SnapKit
import Then

final class SJWeeklyScheduleView: UIView {
    
    //헤더 (요일) 레이블
    private let weekdayLabels: [UILabel] = {
        let days = [
            StringLiterals.shared.monday,
            StringLiterals.shared.tuesday,
            StringLiterals.shared.wednesday,
            StringLiterals.shared.thursday,
            StringLiterals.shared.friday,
            StringLiterals.shared.saturday,
            StringLiterals.shared.sunday
        ]
        return days.map { day in
            return UILabel().then {
                $0.text = day
                $0.textAlignment = .center
                $0.font = .seongiFont(.body_bold_14)
                $0.textColor = .primary200
            }
        }
    }()
    
    //영업 시작 시간 레이블
    private let openTimeLabels: [UILabel] = {
        return (0..<7).map { index in
            return UILabel().then {
                $0.text = "11:50"
                $0.textAlignment = .center
                $0.font = .seongiFont(.body_regular_12)
                $0.textColor = .accentPink
            }
        }
    }()
    
    //영업 종료 시간 레이블
    private let closeTimeLabels: [UILabel] = {
        return (0..<7).map { _ in
            return UILabel().then {
                $0.text = "22:00"
                $0.textAlignment = .center
                $0.font = .seongiFont(.body_regular_12)
                $0.textColor = .accentPink
            }
        }
    }()
    
    // 정기 휴무일 레이블
    private let regularLabel = UILabel()
    // 휴무일 레이블
    private let sundayLabel = UILabel()
    private let dividerLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setHierarchy() {
        //구분선 추가
        addSubviews(dividerLine, regularLabel, sundayLabel)
        
        //요일 레이블 추가
        weekdayLabels.forEach { addSubview($0) }
        
        //영업 시작 시간 레이블 추가
        openTimeLabels.forEach { addSubview($0) }
        
        //영업 종료 시간 레이블 추가
        closeTimeLabels.forEach { addSubview($0) }
    }
    
    private func setLayout() {
        //요일 레이블 레이아웃
        for (index, label) in weekdayLabels.enumerated() {
            label.snp.makeConstraints {
                $0.top.equalToSuperview().offset(16)
                $0.width.equalToSuperview().dividedBy(7)
                $0.height.equalTo(20)
                
                if index == 0 {
                    $0.leading.equalToSuperview()
                } else {
                    $0.leading.equalTo(weekdayLabels[index-1].snp.trailing)
                }
            }
        }
        
        //구분선 레이아웃
        dividerLine.snp.makeConstraints {
            $0.top.equalTo(weekdayLabels[0].snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.height.equalTo(0.5)
        }
        
        //영업 시작 시간 레이블 레이아웃
        for (index, label) in openTimeLabels.enumerated() {
            label.snp.makeConstraints {
                $0.top.equalTo(dividerLine.snp.bottom).offset(12)
                $0.width.equalToSuperview().dividedBy(7)
                $0.height.equalTo(20)
                
                if index == 0 {
                    $0.leading.equalToSuperview()
                } else {
                    $0.leading.equalTo(openTimeLabels[index-1].snp.trailing)
                }
            }
        }
        
        //영업 종료 시간 레이블 레이아웃
        for (index, label) in closeTimeLabels.enumerated() {
            label.snp.makeConstraints {
                $0.top.equalTo(openTimeLabels[0].snp.bottom).offset(8)
                $0.width.equalToSuperview().dividedBy(7)
                $0.height.equalTo(20)
                
                if index == 0 {
                    $0.leading.equalToSuperview()
                } else {
                    $0.leading.equalTo(closeTimeLabels[index-1].snp.trailing)
                }
            }
        }
        
        regularLabel.snp.makeConstraints {
            $0.top.equalTo(dividerLine.snp.bottom).offset(12)
            $0.width.equalToSuperview().dividedBy(7)
            $0.height.equalTo(20)
            $0.leading.equalTo(openTimeLabels[6].snp.leading)
        }
        
        sundayLabel.snp.makeConstraints {
            $0.top.equalTo(regularLabel.snp.bottom).offset(8)
            $0.width.equalToSuperview().dividedBy(7)
            $0.height.equalTo(20)
            $0.leading.equalTo(regularLabel.snp.leading)
        }
    }
    
    private func setStyle() {
        self.do {
            $0.backgroundColor = .bg100
            $0.layer.cornerRadius = 12
            $0.layer.borderWidth = 0.8
            $0.layer.borderColor = UIColor.primary200.cgColor
        }
        
        regularLabel.do {
            $0.text = StringLiterals.shared.regularHours
            $0.font = .seongiFont(.body_bold_12)
            $0.textColor = .primary300
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.8
            $0.numberOfLines = 1
        }
        
        sundayLabel.do {
            $0.text = StringLiterals.shared.closed
            $0.font = .seongiFont(.body_bold_12)
            $0.textColor = .primary300
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.8
            $0.numberOfLines = 1
        }
        
        dividerLine.backgroundColor = .primary200
    }
    
    
    //영업시간 정보 업데이트 메서드
    func updateSchedule(businessHours: [String: String], holidayIndex: Int) {
        // 휴무일이 없는 경우(holidayIndex가 음수) regularLabel과 sundayLabel 숨기기
        if holidayIndex < 0 {
            regularLabel.isHidden = true
            sundayLabel.isHidden = true
            
            // 모든 레이블 보이게 초기화
            for i in 0..<openTimeLabels.count {
                openTimeLabels[i].isHidden = false
                closeTimeLabels[i].isHidden = false
            }
        } else {
            regularLabel.isHidden = false
            sundayLabel.isHidden = false
            
            // 기존 레이아웃 제약조건 제거
            regularLabel.snp.removeConstraints()
            
            // 새로운 위치에 정기 휴무일 레이블 배치
            regularLabel.snp.makeConstraints {
                $0.top.equalTo(dividerLine.snp.bottom).offset(12)
                $0.width.equalToSuperview().dividedBy(7)
                $0.height.equalTo(20)
                $0.leading.equalTo(openTimeLabels[holidayIndex].snp.leading)
            }
            
            // 일요일 레이블 위치도 업데이트
            sundayLabel.snp.removeConstraints()
            sundayLabel.snp.makeConstraints {
                $0.top.equalTo(regularLabel.snp.bottom).offset(8)
                $0.width.equalToSuperview().dividedBy(7)
                $0.height.equalTo(20)
                $0.leading.equalTo(regularLabel.snp.leading)
            }
            
            // 모든 레이블 보이게 초기화
            for i in 0..<openTimeLabels.count {
                openTimeLabels[i].isHidden = false
                closeTimeLabels[i].isHidden = false
            }
            
            // 휴무일에 해당하는 openTimeLabels과 closeTimeLabels 숨기기
            openTimeLabels[holidayIndex].isHidden = true
            closeTimeLabels[holidayIndex].isHidden = true
        }
        
        // 요일 매핑 - UI 표시용과 데이터 키 매핑
        let uiWeekdays = [
            StringLiterals.shared.monday,
            StringLiterals.shared.tuesday,
            StringLiterals.shared.wednesday,
            StringLiterals.shared.thursday,
            StringLiterals.shared.friday,
            StringLiterals.shared.saturday,
            StringLiterals.shared.sunday
        ]  // ["월", "화", ...]
        let dataKeys = ["월", "화", "수", "목", "금", "토", "일"]  // 데이터 키는 항상 한글
        
        // 영업 시간 업데이트
        for index in 0..<min(uiWeekdays.count, dataKeys.count) {
            let dataKey = dataKeys[index]
            
            // 휴무일인 경우 건너뛰기 (regularLabel과 sundayLabel이 표시됨)
            if holidayIndex >= 0 && index == holidayIndex {
                continue
            }
            
            if let businessHour = businessHours[dataKey] {
                if businessHour == StringLiterals.shared.closed {
                    // 일반 휴무일 - openTimeLabels와 closeTimeLabels에 표시
                    openTimeLabels[index].isHidden = false
                    closeTimeLabels[index].isHidden = false
                    
                    // openTimeLabels에는 "정기" 표시
                    openTimeLabels[index].text = StringLiterals.shared.regularHours
                    openTimeLabels[index].font = .seongiFont(.body_bold_12)
                    openTimeLabels[index].textColor = .primary300
                    
                    // closeTimeLabels에는 "휴무" 표시
                    closeTimeLabels[index].text = StringLiterals.shared.closed
                    closeTimeLabels[index].font = .seongiFont(.body_bold_12)
                    closeTimeLabels[index].textColor = .primary300
                } else {
                    // 영업일 - 시간 표시
                    openTimeLabels[index].isHidden = false
                    closeTimeLabels[index].isHidden = false
                    openTimeLabels[index].textColor = .accentPink  // 원래 색상으로 복원
                    openTimeLabels[index].font = .seongiFont(.body_regular_12)  // 원래 폰트로 복원
                    closeTimeLabels[index].textColor = .accentPink
                    closeTimeLabels[index].font = .seongiFont(.body_regular_12)
                    
                    // "시작시간 - 종료시간" 형식에서 분리
                    let times = businessHour.components(separatedBy: " - ")
                    if times.count == 2 {
                        openTimeLabels[index].text = times[0].trimmingCharacters(in: .whitespacesAndNewlines)
                        closeTimeLabels[index].text = times[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                }
            } else {
                // 해당 요일 정보가 없는 경우 - 휴무로 처리
                openTimeLabels[index].isHidden = false
                closeTimeLabels[index].isHidden = false
                
                // openTimeLabels에는 "정기" 표시
                openTimeLabels[index].text = StringLiterals.shared.regularHours
                openTimeLabels[index].font = .seongiFont(.body_bold_12)
                openTimeLabels[index].textColor = .primary300
                
                // closeTimeLabels에는 "휴무" 표시
                closeTimeLabels[index].text = StringLiterals.shared.closed
                closeTimeLabels[index].font = .seongiFont(.body_bold_12)
                closeTimeLabels[index].textColor = .primary300
            }
        }
        
        // 레이아웃 즉시 업데이트
        self.layoutIfNeeded()
    }
}
