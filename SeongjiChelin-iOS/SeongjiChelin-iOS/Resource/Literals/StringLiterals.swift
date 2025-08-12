//
//  StringLiterals.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/28/25.
//

import Foundation
import SwiftUI

struct StringLiterals {
    
    // MARK: - Common
    let cancel = String(localized: "취소")
    let confirm = String(localized: "확인")
    let save = String(localized: "저장하기")
    let later = String(localized: "나중에")
    let update = String(localized: "업데이트")
    let next = String(localized: "다음")
    let skip = String(localized: "건너뛰기")
    let start = String(localized: "출발하기")
    let add = String(localized: "추가")
    let remove = String(localized: "해제")
    let success = String(localized: "성공")
    let failed = String(localized: "실패")
    let app = String(localized: "앱")
    
    // MARK: - Onboarding
    let welcomeTitle = String(localized: "성지슐랭에 오신 것을 환영합니다!")
    let welcomeDescription = String(localized: "유명인과 주인장이 추천하는\n 숨겨진 맛집을 찾아 떠나볼까요? 🔎")
    let mapExploreTitle = String(localized: "지도로 쉽게 맛집 탐색")
    let mapExploreDescription = String(localized: "유명인 추천 맛집을 지도에서\n 한눈에 확인하고 방문해보세요! 🚗")
    let collectionTitle = String(localized: "나만의 맛집 컬렉션")
    let collectionDescription = String(localized: "방문한 곳과 마음에 드는 맛집을 저장하고,\n언제든 다시 찾아가세요! 📌")
    
    // MARK: - Filter
    let all = String(localized: "전체")
    let visited = String(localized: "방문한 곳")
    let saved = String(localized: "저장한 곳")
    let reviewed = String(localized: "리뷰남긴 곳")
    
    // MARK: - Restaurant
    let address = String(localized: "주소")
    let contact = String(localized: "연락처")
    let businessStatus = String(localized: "영업 여부")
    let menuInVideo = String(localized: "영상 속 메뉴")
    let amenities = String(localized: "편의시설")
    let noContactInfo = String(localized: "등록된 연락처가 없습니다.")
//    let businessClosed = String(localized: "휴무")
    let recommendedMenu = String(localized: "추천 메뉴")
    
    // MARK: - Phone
    let callFailedTitle = String(localized: "통화 연결 실패")
    let noContactMessage = String(localized: "연락처 정보가 없습니다.")
    let invalidFormatMessage = String(localized: "올바른 전화번호 형식이 아닙니다.")
    let formatErrorMessage = String(localized: "전화번호 형식을 처리할 수 없습니다.")
    let deviceNotSupportedMessage = String(localized: "이 기기에서는 전화 기능을 사용할 수 없습니다.")
    
    // MARK: - Review
    let howWasRestaurant = String(localized: "이 식당은 어떠셨나요?")
    let writeReviewPlaceholder = String(localized: "리뷰를 작성해주세요 (선택사항)")
    
    // MARK: - Menu
    let home = String(localized: "홈")
    let myRestaurants = String(localized: "나만의 식당")
    let howToUse = String(localized: "사용법")
    let reportCorrection = String(localized: "정보 수정 신고")
    
    // MARK: - UI
    let listView = String(localized: "리스트")
    let mapView = String(localized: "지도")
    let searchPlaceholder = String(localized: "식당, 주소 등을 입력해주세요.")
    
    // MARK: - Empty State
    let noSavedRestaurants = String(localized: "저장된 식당이 없습니다")
    let addRestaurantsSuggestion = String(localized: "식당을 방문하거나 즐겨찾기에 추가해보세요")
    
    // MARK: - Days
    let monday = String(localized: "월")
    let tuesday = String(localized: "화")
    let wednesday = String(localized: "수")
    let thursday = String(localized: "목")
    let friday = String(localized: "금")
    let saturday = String(localized: "토")
    let sunday = String(localized: "일")
    
    // MARK: - Business Status
    let regularHours = String(localized: "정기")
    let closed = String(localized: "휴무")
    let holidayClosedStatus = String(localized: "휴무일")
    let allTimeOpen = String(localized: "24시간 영업")
    
    // MARK: - Favorites
    let favAddSuccess = String(localized: "즐겨찾기 추가 성공")
    let favRemoveSuccess = String(localized: "즐겨찾기 해제 성공")
    let favAddFailed = String(localized: "즐겨찾기 추가 실패")
    let favRemoveFailed = String(localized: "즐겨찾기 해제 실패")
    
    // MARK: - Debug
    let ownerTheme = String(localized: "주인장 테마")
    let bridgeInitSuccess = String(localized: "브릿지 초기화 성공")
    let bridgeInitFailed = String(localized: "브릿지 초기화 실패")
    let appDataInitComplete = String(localized: "앱 데이터 초기화 완료")
    let formatParsingFailed = String(localized: "실패")
    
    // MARK: - Singleton
    static let shared = StringLiterals()
    
    private init() {}
}
