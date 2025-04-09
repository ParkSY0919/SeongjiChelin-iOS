//
//  RestaurantLiterals.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/4/25.
//

import UIKit

// 개별 가게 정보를 담는 구조체
struct Restaurant: Identifiable {
    let id = UUID()
    let youtubeId: String?
    let name: String
    let category: String // 한식, 양식 등
    let storeInfo: String? // 가게 번호 등
    let address: String
    let latitude: Double // 위도
    let longitude: Double // 경도
    let inVideoMenus: [String]? // 영상 속 메뉴
}

// 테마별 가게 목록을 담는 구조체
struct RestaurantTheme: Identifiable {
    let id = UUID() // 고유 ID (선택사항)
    let themeType: RestaurantThemeType
    let restaurants: [Restaurant] // 해당 테마의 가게 목록
}

enum RestaurantThemeType: String, CaseIterable {
    case psyTheme = "psy Pick!"
    case sungSiKyungTheme = "성시경의 먹을텐데"
    case ttoGanJibTheme = "풍자의 또간집"
    case choizaLoadTheme = "최자의 최자로드"
    case hongSeokCheonTheme = "홍석천과 이원일"
    case baekJongWonTheme = "백종원의 님아 그 시장을 가오"
    
    var image: UIImage {
        switch self {
        case .psyTheme: .riceImage()
        case .sungSiKyungTheme: .eyeglassesImage()
        case .ttoGanJibTheme: .walkImage()
        case .choizaLoadTheme: .roadImage()
        case .hongSeokCheonTheme: .person2Image()
        case .baekJongWonTheme: .cartImage()
        }
    }
    
    var color: UIColor {
        switch self {
        case .psyTheme: .primary200
        case .sungSiKyungTheme: .marker1
        case .ttoGanJibTheme: .marker2
        case .choizaLoadTheme: .marker3
        case .hongSeokCheonTheme: .marker4
        case .baekJongWonTheme: .marker5
        }
    }
}

struct RestaurantLiterals {
    
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
            Restaurant(youtubeId: nil, name: "우정초밥", category: "일식", storeInfo: "070-4320-2333", address: "서울 성북구 종암로3길 31 1층", latitude: 37.5929970946678, longitude: 127.034297992637, inVideoMenus: ["런치 오마카세", "디너 오마카세"]),
            Restaurant(youtubeId: nil, name: "대청 치마오", category: "일식", storeInfo: "02-3413-7708", address: "서울 강남구 개포로 623 지하 1층 106호", latitude: 37.494341198165, longitude: 127.079647753194, inVideoMenus: ["본격 가라아게동"]),
            Restaurant(youtubeId: nil, name: "훗카이도 부타동 스미레", category: "일식", storeInfo: nil, address: "서울특별시 서대문구 연세로4길 61", latitude: 37.5585661705571, longitude: 126.939533144555, inVideoMenus: ["삼겹 부타동"]),
            Restaurant(youtubeId: nil, name: "크레이지카츠", category: "일식", storeInfo: "070-8621-7219", address: "서울 마포구 포은로2나길 44 2층", latitude: 37.5504517603956, longitude: 126.909712822276, inVideoMenus: ["특로스"]),
            Restaurant(youtubeId: nil, name: "추억닭발 본점", category: "한식", storeInfo: "032-511-2881", address: "인천 부평구 부평문화로 47 2층 201호", latitude: 37.4941372513679, longitude: 126.721454845328, inVideoMenus: ["추억닭발(국물 닭발)"]),
            Restaurant(youtubeId: nil, name: "작은정원 가좌점", category: "한식", storeInfo: "032-573-8889", address: "인천 서구 건지로 363 1층", latitude: 37.4973235910899, longitude: 126.682366877646, inVideoMenus: ["쭈꾸미볶음정식(매운맛)"]),
            Restaurant(youtubeId: nil, name: "고려왕족발 가정점", category: "한식", storeInfo: "032-579-6790", address: "인천 서구 가정로380번길 7 2층", latitude: 37.5188394173766, longitude: 126.673872306107, inVideoMenus: ["왕족발(앞다리)"])
        ]
    )
    
    // MARK: - 성시경
    
    static let sungSiKyungTheme = RestaurantTheme(
        themeType: .sungSiKyungTheme,
        restaurants: [
            Restaurant(youtubeId: "Khjn-JspNkQ", name: "화진호이선장네해물", category: "한식", storeInfo: "033-631-0750", address: "강원특별자치도 속초시 먹거리4길 18-1 1층", latitude: 38.1953880677414, longitude: 128.573234420923, inVideoMenus: ["가자미튀김", "가자미조림", "대구탕", "회덮밥"]),
            Restaurant(youtubeId: "vDVTYhm-2uU", name: "먹거리집", category: "한식", storeInfo: nil, address: "서울 중랑구 면목로91길 8 1층", latitude: 37.594576216919, longitude: 127.085389481171, inVideoMenus: ["수육", "내장", "제육볶음", "순대국"]),
            Restaurant(youtubeId: "wKNO7zfr8JQ", name: "풍성감자탕", category: "한식", storeInfo: "02-446-0354", address: "서울 광진구 자양로18길 5", latitude: 37.5375769086631, longitude: 127.083844149774, inVideoMenus: ["감자탕"]),
            Restaurant(youtubeId: "IJwIJZ3G-pw", name: "전원식당", category: "한식", storeInfo: "033-633-0282", address: "강원특별자치도 속초시 영금정로 15 1층", latitude: 38.2129588244246, longitude: 128.598068148553, inVideoMenus: ["두루치기"]),
            Restaurant(youtubeId: "TUbvswTagLg", name: "충북원조순대국밥", category: "한식", storeInfo: nil, address: "서울 동작구 서달로14길 16 1층", latitude: 37.5078713792896, longitude: 126.963822451667, inVideoMenus: ["막창전골", "순대"]),
            Restaurant(youtubeId: "oCVgwsJbFpk", name: "옛날칼국수", category: "한식", storeInfo: "02-939-6169", address: "서울 노원구 동일로 1417 1층", latitude: 37.6550688080345, longitude: 127.059980216361, inVideoMenus: ["칼국수", "얼큰수제비", "청양", "부추전", "왕만두"])
        ]
    )
    
    // MARK: - 또간집 (풍자)
    
    static let ttoGanJibTheme = RestaurantTheme(
        themeType: .ttoGanJibTheme,
        restaurants: [
            Restaurant(youtubeId: "vr3kD181iP4", name: "복돈이부추삼겹살", category: "한식", storeInfo: "0507-1310-5124", address: "서울 관악구 남현1길 68-14 남현빌딩", latitude: 37.4751687521468, longitude: 126.981124579443, inVideoMenus: ["삼겹살"]),
            Restaurant(youtubeId: "gAg30SNDBbY", name: "걸리버막창", category: "한식", storeInfo: "053-356-6824", address: "대구 북구 옥산로 53", latitude: 35.885531706055, longitude: 128.581455376842, inVideoMenus: ["막창, 된장찌개"]),
            Restaurant(youtubeId: "nOImQVpgYl4", name: "오뚜기분식", category: "분식", storeInfo: "043-844-3461", address: "충북 충주시 자유시장길 31 1층", latitude: 36.9734239530015, longitude: 127.932641315938, inVideoMenus: ["쫄면", "김밥"]),
            Restaurant(youtubeId: "ReGp1WJE6VY", name: "진중 우육면관 본점", category: "아시안", storeInfo: "0507-1376-2257", address: "서울 종로구 청계천로 75-2 진중 우육면관 본점 (Niroumianguan)", latitude: 37.5685890877443, longitude: 126.985964604292, inVideoMenus: ["우육면(특)", "오이소채"]),
            Restaurant(youtubeId: "2b8JtDgSckQ", name: "담택", category: "일식", storeInfo: "0507-1347-4561", address: "서울 마포구 동교로12안길 51 1층", latitude: 37.5544519990868, longitude: 126.915164802094, inVideoMenus: ["시오라멘"]),
        ]
    )
    
    // MARK: - 최자로드
    
    static let choizaLoadTheme = RestaurantTheme(
        themeType: .choizaLoadTheme,
        restaurants: [
            Restaurant(youtubeId: "b8haUWdjYUM", name: "남영탉", category: "한식", storeInfo: "070-8733-5949", address: "서울 용산구 한강대로80길 12 1층", latitude: 37.5425431587763, longitude: 126.973487034748, inVideoMenus: ["동양탉", "마크탉", "탉무릎연골", "완탉면", "탉개장"]),
            Restaurant(youtubeId: "UxMXbgceWKs", name: "사랑방 참숯화로구이", category: "한식", storeInfo: "02-774-5950", address: "서울 용산구 신흥로36길 4", latitude: 37.5464262359766, longitude: 126.981789206434, inVideoMenus: ["삼겹살", "돼지갈비"]),
            Restaurant(youtubeId: "r3haobf1qkQ", name: "은주정", category: "한식", storeInfo: "0507-1406-4669", address: "서울 중구 창경궁로8길 32", latitude: 37.5686824540468, longitude: 126.999757313391, inVideoMenus: ["김치찌개", "고기추가", "라면사리"]),
            Restaurant(youtubeId: "TwlzZI0jZw0", name: "맛이차이나", category: "중식", storeInfo: "010-9822-2653", address: "서울 마포구 독막로 68", latitude: 37.5475998077326, longitude: 126.920858592344, inVideoMenus: ["양장피", "팔보채", "어향가지", "청증 우럭", "탕수육", "흑후추 소스 소고기", "짜장면", "공부탕면(백짬뽕)", "볶음밥"])
        ]
    )
    
    // MARK: - 홍석천 이원일
    
    static let hongSeokCheonTheme = RestaurantTheme(
        themeType: .hongSeokCheonTheme,
        restaurants: [
            Restaurant(youtubeId: "ec-6uhaWqho", name: "당산옛날곱창", category: "한식", storeInfo: "02-3667-2315", address: "서울 영등포구 당산로47길 14 1층", latitude: 37.5353741059467, longitude: 126.902277256782, inVideoMenus: ["모듬곱창"]),
            Restaurant(youtubeId: "T62atXdV2s0", name: "진주집", category: "한식", storeInfo: "02-780-6108", address: "서울 영등포구 국제금융로6길 33 지하 1층", latitude: 37.5207908297398, longitude: 126.926911965929, inVideoMenus: ["콩국수", "육개장 칼국수"]),
            Restaurant(youtubeId: "gbD1eKteaL0", name: "요미우돈교자", category: "일식", storeInfo: "0507-1426-8113", address: "경기 수원시 팔달구 화서문로32번길 28", latitude: 37.2839309520531, longitude: 127.012264488268, inVideoMenus: ["넓적우동", "붓카케 우동", "고기 교자 만두", "가지 불고기 덮밥"]),
            Restaurant(youtubeId: "aaj8-GyAemk", name: "본전돼지국밥", category: "한식", storeInfo: "051-441-2946", address: "부산 동구 중앙대로214번길 3-8", latitude: 35.116594272274, longitude: 129.04139482351, inVideoMenus: ["돼지국밥"]),
            Restaurant(youtubeId: "pQRy9ZFqQ6A", name: "톤쇼우", category: "일식", storeInfo: "010-5685-5482", address: "부산 금정구 금강로 247-10", latitude: 35.2304471534003, longitude: 129.084270106003, inVideoMenus: ["본삼겹", "특 로스카츠", "히레카츠", "카츠산도"])
        ]
    )
    
    // MARK: - 백종원 (골목식당, 스트리트푸드파이터 등)
    
    static let baekJongWonTheme = RestaurantTheme(
        themeType: .baekJongWonTheme,
        restaurants: [
            Restaurant(youtubeId: "NROEyqEqkR4", name: "기라성", category: "중식", storeInfo: "063-582-1040", address: "전북 부안군 계화면 간재로 461 기라성", latitude: 35.764060322108, longitude: 126.692563323509, inVideoMenus: ["해물짜장", "볶음밥", "돈까스", "비빔간짜장"]),
            Restaurant(youtubeId: "IBKaevIroGs", name: "엄정분식", category: "분식", storeInfo: "043-844-6931", address: "충북 충주시 충인6길 37-1", latitude: 36.973723104947, longitude: 127.933214337749, inVideoMenus: ["막창구이", "곱창전골"]),
            Restaurant(youtubeId: "or2TgTRjPq8", name: "산동포자", category: "중식", storeInfo: "032-431-8885", address: "인천 부평구 마장로 75 대경빌딩", latitude: 37.4854923844293, longitude: 126.70769464585, inVideoMenus: ["홍소스즈토우", "꼴뚜기튀김", "바지락볶음", "홍소로우", "중국식새우튀김"]),
            ]
    )
    
}
