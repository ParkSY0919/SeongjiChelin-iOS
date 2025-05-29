//
//  RestaurantLiterals.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/4/25.
//

import UIKit

import RealmSwift

// 개별 가게 정보를 담는 구조체
// UUID를 쓸 이유가 없음. 이는 앱을 재시작할 때마다 새로 만들기에 realm 데이터 조회 시 사용 불가
struct Restaurant {
    let storeID: String
    let name: String
    let category: String // 한식, 양식 등
    let number: String // 가게 번호 등
    let address: String
    let menus: [String] // 추천 or 영상 속 메뉴
    let closedDays: String
    let breakTime: String? // 브레이크 타임 (예: "15:00 - 17:00")
    let businessHours: [String: String]
    let amenities: String
    let latitude: Double // 위도
    let longitude: Double // 경도
    let youtubeId: String?
    let psyReview: String?
}

// 테마별 가게 목록을 담는 구조체
struct RestaurantTheme: Identifiable {
    let id = UUID() // 고유 ID (선택사항)
    let themeType: RestaurantThemeType
    let restaurants: [Restaurant] // 해당 테마의 가게 목록
}

enum RestaurantThemeType: String, CaseIterable {
    case psyTheme = "주인장 Pick"
    case sungSiKyungTheme = "성시경의 먹을텐데"
    case ttoGanJibTheme = "풍자의 또간집"
    case choizaLoadTheme = "최자의 최자로드"
    case hongSeokCheonTheme = "홍석천과 이원일"
    case baekJongWonTheme = "백종원의 님아 그 시장을 가오"
    
    var idPrefix: String {
        switch self {
        case .psyTheme:
            "psyTheme"
        case .sungSiKyungTheme:
            "sungSiKyungTheme"
        case .ttoGanJibTheme:
            "ttoGanJibTheme"
        case .choizaLoadTheme:
            "choizaLoadTheme"
        case .hongSeokCheonTheme:
            "hongSeokCheonTheme"
        case .baekJongWonTheme:
            "baekJongWonTheme"
        }
    }
    
    var madeImage: UIImage {
        switch self {
        case .psyTheme: .riceImage()
        case .sungSiKyungTheme: .eyeglassesImage()
        case .ttoGanJibTheme: .walkImage()
        case .choizaLoadTheme: .roadImage()
        case .hongSeokCheonTheme: .person2Image()
        case .baekJongWonTheme: .cartImage()
        }
    }
    
    var image: UIImage? {
        switch self {
        case .psyTheme: ImageLiterals.riceBowl.withRenderingMode(.alwaysTemplate)
        case .sungSiKyungTheme: ImageLiterals.eyeglasses
        case .ttoGanJibTheme: ImageLiterals.figureWalk
        case .choizaLoadTheme: ImageLiterals.roadLanes
        case .hongSeokCheonTheme: ImageLiterals.person2Fill
        case .baekJongWonTheme: ImageLiterals.cart
        }
    }
    
    var color: UIColor {
        switch self {
        case .psyTheme: .marker0
        case .sungSiKyungTheme: .marker1
        case .ttoGanJibTheme: .marker2
        case .choizaLoadTheme: .marker3
        case .hongSeokCheonTheme: .marker4
        case .baekJongWonTheme: .marker5
        }
    }
}

struct RestaurantLiterals {
    
    static let allRestaurantThemesData = RestaurantLiterals.allRestaurantThemes.flatMap { $0.restaurants }
    
    static let allRestaurantThemes: [RestaurantTheme] = [
        psyTheme,
        sungSiKyungTheme,
        ttoGanJibTheme,
        choizaLoadTheme,
        hongSeokCheonTheme,
        baekJongWonTheme
    ]
    
    // MARK: - psy
    
    static let psyTheme = RestaurantTheme(
        themeType: .psyTheme,
        restaurants: [
            Restaurant(
                storeID: "psyTheme_우정초밥",
                name: "우정초밥",
                category: "일식",
                number: "050-71347-2333",
                address: "서울 성북구 종암로3길 31 1층",
                menus: ["런치 오마카세", "디너 오마카세"],
                closedDays: "일",
                breakTime: nil,
                businessHours: [
                    "월": "11:30 - 20:35",
                    "화": "11:30 - 20:35",
                    "수": "11:30 - 20:35",
                    "목": "11:30 - 20:35",
                    "금": "11:30 - 20:35",
                    "토": "11:30 - 20:35",
                    "일": "휴무"
                ],
                amenities: "주차 X / 화장실 O",
                latitude: 37.5929970946678,
                longitude: 127.034297992637,
                youtubeId: nil,
                psyReview: "최강 가성비 오마카세"
            ),
            Restaurant(
                storeID: "psyTheme_대청 치마오",
                name: "대청 치마오",
                category: "일식",
                number: "02-3413-7708",
                address: "서울 강남구 개포로 623 지하 1층 106호",
                menus: ["본격 가라아게동"],
                closedDays: "",
                breakTime: nil,
                businessHours: [
                    "월": "10:00 - 20:00",
                    "화": "10:00 - 20:00",
                    "수": "10:00 - 20:00",
                    "목": "10:00 - 20:00",
                    "금": "10:00 - 20:00",
                    "토": "10:00 - 19:30",
                    "일": "10:00 - 15:00"
                ],
                amenities: "주차 X / 화장실 O",
                latitude: 37.494341198165,
                longitude: 127.079647753194,
                youtubeId: nil,
                psyReview: nil
            ),
            Restaurant(
                storeID: "psyTheme_훗카이도 부타동 스미레",
                name: "훗카이도 부타동 스미레",
                category: "일식",
                number: "등록된 연락처가 없습니다.",
                address: "서울특별시 서대문구 연세로4길 61",
                menus: ["삼겹 부타동"],
                closedDays: "월",
                breakTime: "14:30 - 17:00",
                businessHours: [
                    "월": "휴무",
                    "화": "11:30 - 20:00",
                    "수": "11:30 - 20:00",
                    "목": "11:30 - 20:00",
                    "금": "11:30 - 20:00",
                    "토": "11:30 - 20:00",
                    "일": "11:30 - 20:00"
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 37.5585661705571,
                longitude: 126.939533144555,
                youtubeId: nil,
                psyReview: nil
            ),
            Restaurant(
                storeID: "psyTheme_크레이지카츠",
                name: "크레이지카츠",
                category: "일식",
                number: "070-8621-7219",
                address: "서울 마포구 포은로2나길 44 2층",
                menus: ["특로스"],
                closedDays: "",
                breakTime: "15:00 - 17:00",
                businessHours: [
                    "월": "11:30 - 21:00",
                    "화": "11:30 - 21:00",
                    "수": "11:30 - 21:00",
                    "목": "11:30 - 21:00",
                    "금": "11:30 - 21:00",
                    "토": "11:30 - 21:00",
                    "일": "11:30 - 21:00"
                ],
                amenities: "주차 X / 화장실 O",
                latitude: 37.5504517603956,
                longitude: 126.909712822276,
                youtubeId: nil,
                psyReview: nil
            ),
            Restaurant(
                storeID: "psyTheme_추억닭발 본점",
                name: "추억닭발 본점",
                category: "한식",
                number: "032-511-2881",
                address: "인천 부평구 부평문화로 47 2층 201호",
                menus: ["추억닭발(국물 닭발)"],
                closedDays: "월",
                breakTime: nil,
                businessHours: [
                    "월": "휴무",
                    "화": "16:00 - 00:00",
                    "수": "16:00 - 00:00",
                    "목": "16:00 - 00:00",
                    "금": "16:00 - 00:00",
                    "토": "16:00 - 00:00",
                    "일": "16:00 - 00:00"
                ],
                amenities: "주차 X / 화장실 O",
                latitude: 37.4941372513679,
                longitude: 126.721454845328,
                youtubeId: nil,
                psyReview: nil
            ),
            Restaurant(
                storeID: "psyTheme_작은정원 가좌점",
                name: "작은정원 가좌점",
                category: "한식",
                number: "032-573-8889",
                address: "인천 서구 건지로 363 1층",
                menus: ["쭈꾸미볶음정식(매운맛)"],
                closedDays: "",
                breakTime: nil,
                businessHours: [
                    "월": "11:00 - 22:00",
                    "화": "11:00 - 22:00",
                    "수": "11:00 - 22:00",
                    "목": "11:00 - 22:00",
                    "금": "11:00 - 22:00",
                    "토": "11:00 - 22:00",
                    "일": "11:00 - 22:00"
                ],
                amenities: "주차 O / 화장실 O",
                latitude: 37.4973235910899,
                longitude: 126.682366877646,
                youtubeId: nil,
                psyReview: nil
            ),
            Restaurant(
                storeID: "psyTheme_고려왕족발 가정점",
                name: "고려왕족발 가정점",
                category: "한식",
                number: "032-579-6790",
                address: "인천 서구 가정로380번길 7 2층",
                menus: ["왕족발(앞다리)"],
                closedDays: "",
                breakTime: nil,
                businessHours: [
                    "월": "10:00 - 22:00",
                    "화": "10:00 - 22:00",
                    "수": "10:00 - 22:00",
                    "목": "10:00 - 22:00",
                    "금": "10:00 - 22:00",
                    "토": "10:00 - 22:00",
                    "일": "10:00 - 22:00"
                ],
                amenities: "주차 X / 화장실 O",
                latitude: 37.5188394173766,
                longitude: 126.673872306107,
                youtubeId: nil,
                psyReview: nil
            )
        ]
    )
    
    // MARK: - 성시경
    
    static let sungSiKyungTheme = RestaurantTheme(
        themeType: .sungSiKyungTheme,
        restaurants: [
            Restaurant(
                storeID: "sungSiKyungTheme_화진호이선장네해물",
                name: "화진호이선장네해물",
                category: "한식",
                number: "033-631-0750",
                address: "강원특별자치도 속초시 먹거리4길 18-1 1층",
                menus: ["가자미튀김", "가자미조림", "대구탕", "회덮밥"],
                closedDays: "일",
                breakTime: nil,
                businessHours: [
                    "월": "11:00 - 15:30",
                    "화": "11:00 - 15:30",
                    "수": "11:00 - 15:30",
                    "목": "11:00 - 15:30",
                    "금": "11:00 - 15:30",
                    "토": "11:00 - 15:30",
                    "일": "휴무"
                ],
                amenities: "주차 X / 화장실 O",
                latitude: 38.1953880677414,
                longitude: 128.573234420923,
                youtubeId: "Khjn-JspNkQ",
                psyReview: nil
            ),
            Restaurant(
                storeID: "sungSiKyungTheme_먹거리집",
                name: "먹거리집",
                category: "한식",
                number: "등록된 연락처가 없습니다.",
                address: "서울 중랑구 면목로91길 8 1층",
                menus: ["수육", "내장", "제육볶음", "순대국"],
                closedDays: "",
                breakTime: nil,
                businessHours: [
                    "월": "00:00 - 24:00",
                    "화": "00:00 - 24:00",
                    "수": "00:00 - 24:00",
                    "목": "00:00 - 24:00",
                    "금": "00:00 - 24:00",
                    "토": "00:00 - 24:00",
                    "일": "00:00 - 24:00"
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 37.594576216919,
                longitude: 127.085389481171,
                youtubeId: "vDVTYhm-2uU",
                psyReview: nil
            ),
            Restaurant(
                storeID: "sungSiKyungTheme_풍성감자탕",
                name: "풍성감자탕",
                category: "한식",
                number: "02-446-0354",
                address: "서울 광진구 자양로18길 5",
                menus: ["감자탕"],
                closedDays: "",
                breakTime: nil,
                businessHours: [
                    "월": "00:00 - 24:00",
                    "화": "00:00 - 24:00",
                    "수": "00:00 - 24:00",
                    "목": "00:00 - 24:00",
                    "금": "00:00 - 24:00",
                    "토": "00:00 - 24:00",
                    "일": "00:00 - 24:00"
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 37.5375769086631,
                longitude: 127.083844149774,
                youtubeId: "wKNO7zfr8JQ",
                psyReview: nil
            ),
            Restaurant(
                storeID: "sungSiKyungTheme_전원식당",
                name: "전원식당",
                category: "한식",
                number: "033-633-0282",
                address: "강원특별자치도 속초시 영금정로 15 1층",
                menus: ["두루치기"],
                closedDays: "목",
                breakTime: "15:00 - 17:00",
                businessHours: [
                    "월": "09:00 - 20:00",
                    "화": "09:00 - 20:00",
                    "수": "09:00 - 20:00",
                    "목": "휴무",
                    "금": "09:00 - 20:00",
                    "토": "09:00 - 20:00",
                    "일": "09:00 - 20:00"
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 38.2129588244246,
                longitude: 128.598068148553,
                youtubeId: "IJwIJZ3G-pw",
                psyReview: nil
            ),
            Restaurant(
                storeID: "sungSiKyungTheme_충북 원조 순대국밥",
                name: "충북 원조 순대국밥",
                category: "한식",
                number: "등록된 연락처가 없습니다.",
                address: "서울 동작구 서달로14길 16 1층",
                menus: ["막창전골", "순대"],
                closedDays: "",
                breakTime: nil,
                businessHours: [
                    "월": "10:00 - 22:00",
                    "화": "10:00 - 22:00",
                    "수": "10:00 - 22:00",
                    "목": "10:00 - 22:00",
                    "금": "10:00 - 22:00",
                    "토": "10:00 - 21:00",
                    "일": "10:00 - 14:00"
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 37.5078713792896,
                longitude: 126.963822451667,
                youtubeId: "TUbvswTagLg",
                psyReview: nil
            ),
            Restaurant(
                storeID: "sungSiKyungTheme_옛날 칼국수",
                name: "옛날 칼국수",
                category: "한식",
                number: "02-939-6169",
                address: "서울 노원구 동일로 1417 1층",
                menus: ["칼국수", "얼큰수제비", "청양", "부추전", "왕만두"],
                closedDays: "",
                breakTime: "15:00 - 16:00",
                businessHours: [
                    "월": "10:30 - 22:00",
                    "화": "10:30 - 22:00",
                    "수": "10:30 - 22:00",
                    "목": "10:30 - 22:00",
                    "금": "10:30 - 22:00",
                    "토": "10:30 - 22:00",
                    "일": "10:30 - 22:00"
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 37.6550688080345,
                longitude: 127.059980216361,
                youtubeId: "oCVgwsJbFpk",
                psyReview: nil
            )
        ]
    )
    
    // MARK: - 또간집 (풍자)
    
    static let ttoGanJibTheme = RestaurantTheme(
        themeType: .ttoGanJibTheme,
        restaurants: [
            Restaurant(
                storeID: "ttoGanJibTheme_복돈이 부추삼겹살",
                name: "복돈이 부추삼겹살",
                category: "한식",
                number: "0507-1310-5124",
                address: "서울 관악구 남현1길 68-14 남현빌딩",
                menus: ["삼겹살"],
                closedDays: "",
                breakTime: nil,
                businessHours: [
                    "월": "12:00 - 23:00",
                    "화": "12:00 - 23:00",
                    "수": "12:00 - 23:00",
                    "목": "12:00 - 23:00",
                    "금": "12:00 - 23:00",
                    "토": "12:00 - 23:00",
                    "일": "12:00 - 23:00"
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 37.4751687521468,
                longitude: 126.981124579443,
                youtubeId: "vr3kD181iP4",
                psyReview: nil
            ),
            Restaurant(
                storeID: "ttoGanJibTheme_걸리버막창",
                name: "걸리버막창",
                category: "한식",
                number: "053-356-6824",
                address: "대구 북구 옥산로 53",
                menus: ["막창, 된장찌개"],
                closedDays: "일",
                breakTime: nil,
                businessHours: [
                    "월": "15:30 - 24:00",
                    "화": "15:30 - 24:00",
                    "수": "15:30 - 24:00",
                    "목": "15:30 - 24:00",
                    "금": "15:30 - 24:00",
                    "토": "15:30 - 24:00",
                    "일": "휴무"
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 35.885531706055,
                longitude: 128.581455376842,
                youtubeId: "gAg30SNDBbY",
                psyReview: nil
            ),
            Restaurant(
                storeID: "ttoGanJibTheme_오뚜기분식",
                name: "오뚜기분식",
                category: "분식",
                number: "043-844-3461",
                address: "충북 충주시 자유시장길 31 1층",
                menus: ["쫄면", "김밥"],
                closedDays: "일",
                breakTime: nil,
                businessHours: [
                    "월": "10:30 - 20:00",
                    "화": "10:30 - 20:00",
                    "수": "10:30 - 20:00",
                    "목": "10:30 - 20:00",
                    "금": "10:30 - 20:00",
                    "토": "10:30 - 20:00",
                    "일": "휴무"
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 36.9734239530015,
                longitude: 127.932641315938,
                youtubeId: "nOImQVpgYl4",
                psyReview: nil
            ),
            Restaurant(
                storeID: "ttoGanJibTheme_진중 우육면관 본점",
                name: "진중 우육면관 본점",
                category: "아시안",
                number: "0507-1376-2257",
                address: "서울 종로구 청계천로 75-2 진중 우육면관 본점 (Niroumianguan)",
                menus: ["우육면(특)", "오이소채"],
                closedDays: "",
                breakTime: nil,
                businessHours: [
                    "월": "11:00 - 22:00",
                    "화": "11:00 - 22:00",
                    "수": "11:00 - 22:00",
                    "목": "11:00 - 22:00",
                    "금": "11:00 - 22:00",
                    "토": "11:00 - 22:00",
                    "일": "11:00 - 22:00",
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 37.5685890877443,
                longitude: 126.985964604292,
                youtubeId: "ReGp1WJE6VY",
                psyReview: nil
            ),
            Restaurant(
                storeID: "ttoGanJibTheme_담택",
                name: "담택",
                category: "일식",
                number: "0507-1347-4561",
                address: "서울 마포구 동교로12안길 51 1층",
                menus: ["시오라멘"],
                closedDays: "일",
                breakTime: "15:00 - 17:00",
                businessHours: [
                    "월": "11:30 - 21:00",
                    "화": "11:30 - 21:00",
                    "수": "11:30 - 21:00",
                    "목": "11:30 - 21:00",
                    "금": "11:30 - 21:00",
                    "토": "11:30 - 21:30",
                    "일": "휴무"
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 37.5544519990868,
                longitude: 126.915164802094,
                youtubeId: "2b8JtDgSckQ",
                psyReview: nil
            )
        ]
    )
    
    // MARK: - 최자로드
    
    static let choizaLoadTheme = RestaurantTheme(
        themeType: .choizaLoadTheme,
        restaurants: [
            Restaurant(
                storeID: "choizaLoadTheme_남영탉",
                name: "남영탉",
                category: "한식",
                number: "070-8733-5949",
                address: "서울 용산구 한강대로80길 12 1층",
                menus: ["동양탉", "마크탉", "탉무릎연골", "완탉면", "탉개장"],
                closedDays: "일",
                breakTime: nil,
                businessHours: [
                    "월": "17:00 - 01:00",
                    "화": "17:00 - 01:00",
                    "수": "17:00 - 01:00",
                    "목": "17:00 - 01:00",
                    "금": "17:00 - 01:00",
                    "토": "17:00 - 01:00",
                    "일": "휴무"
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 37.5425431587763,
                longitude: 126.973487034748,
                youtubeId: "b8haUWdjYUM",
                psyReview: nil
            ),
            Restaurant(
                storeID: "choizaLoadTheme_사랑방 참숯화로구이",
                name: "사랑방 참숯화로구이",
                category: "한식",
                number: "02-774-5950",
                address: "서울 용산구 신흥로36길 4",
                menus: ["삼겹살", "돼지갈비"],
                closedDays: "화",
                breakTime: nil,
                businessHours: [
                    "월": "16:00 - 22:00",
                    "화": "휴무",
                    "수": "16:00 - 22:00",
                    "목": "16:00 - 22:00",
                    "금": "16:00 - 22:00",
                    "토": "16:00 - 22:00",
                    "일": "16:00 - 22:00",
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 37.5464262359766,
                longitude: 126.981789206434,
                youtubeId: "UxMXbgceWKs",
                psyReview: nil
            ),
            Restaurant(
                storeID: "choizaLoadTheme_은주정",
                name: "은주정",
                category: "한식",
                number: "0507-1406-4669",
                address: "서울 중구 창경궁로8길 32",
                menus: ["김치찌개", "고기추가", "라면사리"],
                closedDays: "일",
                breakTime: nil,
                businessHours: [
                    "월": "10:00 - 22:00",
                    "화": "10:00 - 22:00",
                    "수": "10:00 - 22:00",
                    "목": "10:00 - 22:00",
                    "금": "10:00 - 22:00",
                    "토": "10:00 - 22:00",
                    "일": "휴무"
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 37.5686824540468,
                longitude: 126.999757313391,
                youtubeId: "r3haobf1qkQ",
                psyReview: nil
            ),
            Restaurant(
                storeID: "choizaLoadTheme_맛이차이나",
                name: "맛이차이나",
                category: "중식",
                number: "010-9822-2653",
                address: "서울 마포구 독막로 68",
                menus: ["양장피", "팔보채", "어향가지", "청증 우럭", "탕수육", "흑후추 소스 소고기", "짜장면", "공부탕면(백짬뽕)", "볶음밥"],
                closedDays: "",
                breakTime: "16:00 - 17:00",
                businessHours: [
                    "월": "11:30 - 22:00",
                    "화": "11:30 - 22:00",
                    "수": "11:30 - 22:00",
                    "목": "11:30 - 22:00",
                    "금": "11:30 - 22:00",
                    "토": "11:30 - 22:00",
                    "일": "11:30 - 22:00"
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 37.5475998077326,
                longitude: 126.920858592344,
                youtubeId: "TwlzZI0jZw0",
                psyReview: nil
            )
        ]
    )
    
    // MARK: - 홍석천 이원일
    
    static let hongSeokCheonTheme = RestaurantTheme(
        themeType: .hongSeokCheonTheme,
        restaurants: [
            Restaurant(
                storeID: "hongSeokCheonTheme_당산옛날곱창",
                name: "당산옛날곱창",
                category: "한식",
                number: "02-3667-2315",
                address: "서울 영등포구 당산로47길 14 1층",
                menus: ["모듬곱창"],
                closedDays: "일",
                breakTime: nil,
                businessHours: [
                    "월": "11:30 - 24:00",
                    "화": "11:30 - 24:00",
                    "수": "11:30 - 24:00",
                    "목": "11:30 - 24:00",
                    "금": "11:30 - 24:00",
                    "토": "11:30 - 24:00",
                    "일": "휴무"
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 37.5353741059467,
                longitude: 126.902277256782,
                youtubeId: "ec-6uhaWqho",
                psyReview: nil
            ),
            Restaurant(
                storeID: "hongSeokCheonTheme_진주집",
                name: "진주집",
                category: "한식",
                number: "02-780-6108",
                address: "서울 영등포구 국제금융로6길 33 지하 1층",
                menus: ["콩국수", "육개장 칼국수"],
                closedDays: "일",
                breakTime: nil,
                businessHours: [
                    "월": "10:00 - 20:00",
                    "화": "10:00 - 20:00",
                    "수": "10:00 - 20:00",
                    "목": "10:00 - 20:00",
                    "금": "10:00 - 20:00",
                    "토": "10:00 - 20:00",
                    "일": "휴무"
                ],
                amenities: "주차 O / 화장실 O",
                latitude: 37.5207908297398,
                longitude: 126.926911965929,
                youtubeId: "T62atXdV2s0",
                psyReview: nil
            ),
            Restaurant(
                storeID: "hongSeokCheonTheme_요미우돈교자",
                name: "요미우돈교자",
                category: "일식",
                number: "0507-1426-8113",
                address: "경기 수원시 팔달구 화서문로32번길 28",
                menus: ["넓적우동", "붓카케 우동", "고기 교자 만두", "가지 불고기 덮밥"],
                closedDays: "",
                breakTime: nil,
                businessHours: [
                    "월": "11:00 - 21:00",
                    "화": "11:00 - 21:00",
                    "수": "11:00 - 21:00",
                    "목": "11:00 - 21:00",
                    "금": "11:00 - 21:00",
                    "토": "11:00 - 21:00",
                    "일": "11:00 - 21:00",
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 37.2839309520531,
                longitude: 127.012264488268,
                youtubeId: "gbD1eKteaL0",
                psyReview: nil
            ),
            Restaurant(
                storeID: "hongSeokCheonTheme_본전돼지국밥",
                name: "본전돼지국밥",
                category: "한식",
                number: "051-441-2946",
                address: "부산 동구 중앙대로214번길 3-8",
                menus: ["돼지국밥"],
                closedDays: "",
                breakTime: nil,
                businessHours: [
                    "월": "09:00 - 21:00",
                    "화": "09:00 - 21:00",
                    "수": "09:00 - 21:00",
                    "목": "09:00 - 21:00",
                    "금": "09:00 - 21:00",
                    "토": "09:00 - 21:00",
                    "일": "09:00 - 21:00",
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 35.116594272274,
                longitude: 129.04139482351,
                youtubeId: "aaj8-GyAemk",
                psyReview: nil
            ),
            Restaurant(
                storeID: "hongSeokCheonTheme_톤쇼우",
                name: "톤쇼우",
                category: "일식",
                number: "010-5685-5482",
                address: "부산 금정구 금강로 247-10",
                menus: ["본삼겹", "특 로스카츠", "히레카츠", "카츠산도"],
                closedDays: "",
                breakTime: nil,
                businessHours: [
                    "월": "11:00 - 21:00",
                    "화": "11:00 - 21:00",
                    "수": "11:00 - 21:00",
                    "목": "11:00 - 21:00",
                    "금": "11:00 - 21:00",
                    "토": "11:00 - 21:00",
                    "일": "11:00 - 21:00",
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 35.2304471534003,
                longitude: 129.084270106003,
                youtubeId: "pQRy9ZFqQ6A",
                psyReview: nil
            )
        ]
    )
    
    // MARK: - 백종원 (골목식당, 스트리트푸드파이터 등)
    
    static let baekJongWonTheme = RestaurantTheme(
        themeType: .baekJongWonTheme,
        restaurants: [
            Restaurant(
                storeID: "baekJongWonTheme_기라성",
                name: "기라성",
                category: "중식",
                number: "063-582-1040",
                address: "전북 부안군 계화면 간재로 461 기라성",
                menus: ["해물짜장", "볶음밥", "돈까스", "비빔간짜장"],
                closedDays: "화",
                breakTime: nil,
                businessHours: [
                    "월": "11:00 - 18:00",
                    "화": "휴무",
                    "수": "11:00 - 18:00",
                    "목": "11:00 - 18:00",
                    "금": "11:00 - 18:00",
                    "토": "11:00 - 18:00",
                    "일": "11:00 - 18:00",
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 35.764060322108,
                longitude: 126.692563323509,
                youtubeId: "NROEyqEqkR4",
                psyReview: nil
            ),
            Restaurant(
                storeID: "baekJongWonTheme_엄정분식",
                name: "엄정분식",
                category: "한식",
                number: "043-844-6931",
                address: "충북 충주시 충인6길 37-1",
                menus: ["막창구이", "곱창전골"],
                closedDays: "일",
                breakTime: nil,
                businessHours: [
                    "월": "17:00 - 22:00",
                    "화": "17:00 - 22:00",
                    "수": "17:00 - 22:00",
                    "목": "17:00 - 22:00",
                    "금": "17:00 - 22:00",
                    "토": "11:00 - 22:30",
                    "일": "휴무"
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 36.973723104947,
                longitude: 127.933214337749,
                youtubeId: "IBKaevIroGs",
                psyReview: nil
            ),
            Restaurant(
                storeID: "baekJongWonTheme_산동포자",
                name: "산동포자",
                category: "중식",
                number: "032-431-8885",
                address: "인천 부평구 마장로 75 대경빌딩",
                menus: ["홍소스즈토우", "꼴뚜기튀김", "바지락볶음", "홍소로우", "중국식새우튀김"],
                closedDays: "",
                breakTime: nil,
                businessHours: [
                    "월": "18:00 - 22:00",
                    "화": "18:00 - 22:00",
                    "수": "18:00 - 22:00",
                    "목": "18:00 - 22:00",
                    "금": "18:00 - 22:00",
                    "토": "18:00 - 22:00",
                    "일": "18:00 - 22:00",
                ],
                amenities: "주차 x / 화장실 O",
                latitude: 37.4854923844293,
                longitude: 126.70769464585,
                youtubeId: "or2TgTRjP8",
                psyReview: nil
            )
        ]
    )
    
}

extension Restaurant {
    
    ///가게 영업상태
    enum StoreStatus {
        case open(closeTime: String)
        case closed(openTime: String)
        case breakTime(openTime: String)
        case holidayClosed
        case allTimeOpen
        
        var displayText: String {
            switch self {
            case .open(let closeTime):
                return "영업 중 \(closeTime)에 영업종료"
            case .closed(let openTime):
                return "영업 종료 \(openTime)에 영업시작"
            case .holidayClosed:
                return "휴무일"
            case .breakTime(let openTime):
                return "브레이크 타임 \(openTime)에 영업재개"
            case .allTimeOpen:
                return "24시간 영업"
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .open, .allTimeOpen:
                return .영업중
            case .closed:
                return .영업종료
            case .holidayClosed:
                return .휴무일
            case .breakTime:
                return .marker5
            }
        }
    }
    
    ///현재 가게 영업 상태 체크
    func checkStoreStatus() -> StoreStatus {
        let formatterManager = CustomFormatterManager.shared
        let formatter = formatterManager.timeFormatter()
        
        // 1. 현재 요일과 시간 확인
        let today = Date()
        guard let todayWeekday = formatterManager.weekdayString(from: today) else {
            return .closed(openTime: "")
        }
        
        // 2. 해당 요일의 영업시간 정보 가져오기
        guard let todayHoursStr = businessHours[todayWeekday] else {
            return .closed(openTime: "")
        }
        
        // 3. 휴무일인 경우
        if todayHoursStr == "휴무" {
            return .holidayClosed
        }
        
        if todayHoursStr == "00:00 - 24:00" {
            return .allTimeOpen
        }
        
        // 4. 영업시간 파싱
        let timeComponents = todayHoursStr.components(separatedBy: " - ")
        guard timeComponents.count == 2 else { return .closed(openTime: "") }
        
        let openTimeString = timeComponents[0].trimmingCharacters(in: .whitespacesAndNewlines)
        let closeTimeString = timeComponents[1].trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let openTime = formatter.date(from: openTimeString),
              let closeTime = formatter.date(from: closeTimeString) else {
            return .closed(openTime: "")
        }
        
        // 5. 브레이크 타임 체크
        if let breakTimeStr = breakTime {
            let breakComponents = breakTimeStr.components(separatedBy: " - ")
            if breakComponents.count == 2,
               let breakStartTime = formatter.date(from: breakComponents[0].trimmingCharacters(in: .whitespacesAndNewlines)),
               let breakEndTime = formatter.date(from: breakComponents[1].trimmingCharacters(in: .whitespacesAndNewlines)) {
                
                let currentMinutes = Calendar.current.component(.hour, from: today) * 60 + Calendar.current.component(.minute, from: today)
                let breakStartMinutes = Calendar.current.component(.hour, from: breakStartTime) * 60 + Calendar.current.component(.minute, from: breakStartTime)
                let breakEndMinutes = Calendar.current.component(.hour, from: breakEndTime) * 60 + Calendar.current.component(.minute, from: breakEndTime)
                
                if currentMinutes >= breakStartMinutes && currentMinutes < breakEndMinutes {
                    return .breakTime(openTime: breakComponents[1].trimmingCharacters(in: .whitespacesAndNewlines))
                }
            }
        }
        
        // 6. 현재 시간과 영업시간 비교
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: today)
        let currentMinute = calendar.component(.minute, from: today)
        
        let openHour = calendar.component(.hour, from: openTime)
        let openMinute = calendar.component(.minute, from: openTime)
        let closeHour = calendar.component(.hour, from: closeTime)
        let closeMinute = calendar.component(.minute, from: closeTime)
        
        let currentTotalMinutes = currentHour * 60 + currentMinute
        let openTotalMinutes = openHour * 60 + openMinute
        let closeTotalMinutes = closeHour * 60 + closeMinute
        
        // 7. 영업 종료 시간이 익일인 경우 처리 (예: 새벽 2시 종료)
        if closeTotalMinutes < openTotalMinutes {
            if currentTotalMinutes >= openTotalMinutes || currentTotalMinutes <= closeTotalMinutes {
                return .open(closeTime: closeTimeString)
            } else {
                return .closed(openTime: openTimeString)
            }
        } else {
            if currentTotalMinutes >= openTotalMinutes && currentTotalMinutes < closeTotalMinutes {
                return .open(closeTime: closeTimeString)
            } else {
                return .closed(openTime: openTimeString)
            }
        }
    }
}
