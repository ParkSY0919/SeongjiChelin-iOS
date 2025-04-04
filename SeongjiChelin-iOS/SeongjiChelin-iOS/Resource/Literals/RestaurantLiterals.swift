//
//  RestaurantLiterals.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/4/25.
//

import Foundation

// 개별 가게 정보를 담는 구조체
struct Restaurant: Identifiable {
    let id = UUID()
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
    let themeName: String // 테마 이름 (예: "성시경 먹을텐데")
    let restaurants: [Restaurant] // 해당 테마의 가게 목록
}

struct RestaurantLiterals {
    
    static let allRestaurantThemes: [RestaurantTheme] = [
        sungSiKyungTheme,
        ttoGanJibTheme,
        hongSeokCheonTheme,
        baekJongWonTheme
    ]
    
    static let sungSiKyungTheme = RestaurantTheme(
            themeName: "성시경 먹을텐데",
            restaurants: [
                Restaurant(name: "영동설렁탕", category: "한식", storeInfo: nil, address: "서울 서초구 강남대로101안길 24", latitude: 37.50113, longitude: 127.02651, inVideoMenus: ["설렁탕", "수육"]),
                Restaurant(name: "대성정육식당", category: "한식", storeInfo: nil, address: "서울 동대문구 왕산로 117", latitude: 37.57452, longitude: 127.03983, inVideoMenus: ["김치찌개", "제육볶음"]),
                Restaurant(name: "우정낙지", category: "한식", storeInfo: nil, address: "서울 종로구 종로 104", latitude: 37.57031, longitude: 126.98915, inVideoMenus: ["낙지볶음", "조개탕"]),
                Restaurant(name: "만두란", category: "중식", storeInfo: nil, address: "서울 서대문구 증가로 13길 12", latitude: 37.58535, longitude: 126.92711, inVideoMenus: ["군만두", "고기만두", "찐만두"]),
                Restaurant(name: "신숙", category: "한식", storeInfo: nil, address: "서울 강남구 도산대로55길 45", latitude: 37.52548, longitude: 127.03896, inVideoMenus: ["닭볶음탕"]),
                Restaurant(name: "갯마을", category: "한식", storeInfo: nil, address: "서울 송파구 백제고분로41길 6", latitude: 37.50822, longitude: 127.09618, inVideoMenus: ["감자옹심이"]),
                Restaurant(name: "옥경이네 건생선", category: "한식", storeInfo: nil, address: "서울 중구 퇴계로85길 11", latitude: 37.56735, longitude: 127.01969, inVideoMenus: ["갑오징어 구이", "민어찜"]),
                Restaurant(name: "약수순대", category: "한식", storeInfo: nil, address: "서울 중구 다산로10길 12", latitude: 37.55439, longitude: 127.01077, inVideoMenus: ["순대국"]),
                Restaurant(name: "벽제갈비", category: "한식", storeInfo: nil, address: "서울 송파구 양재대로71길 6", latitude: 37.51462, longitude: 127.12160, inVideoMenus: ["양념갈비", "평양냉면"]),
                Restaurant(name: "윤화돈까스", category: "경양식", storeInfo: nil, address: "서울 영등포구 시흥대로 609", latitude: 37.48297, longitude: 126.90434, inVideoMenus: ["돈까스", "생선까스"]),
                Restaurant(name: "잼배옥", category: "한식", storeInfo: nil, address: "서울 중구 세종대로11길 31", latitude: 37.56422, longitude: 126.97535, inVideoMenus: ["설렁탕", "수육"]),
                Restaurant(name: "중앙해장", category: "한식", storeInfo: nil, address: "서울 강남구 영동대로86길 17", latitude: 37.50729, longitude: 127.06297, inVideoMenus: ["곱창전골", "양선지해장국"]),
                Restaurant(name: "산동칼국수", category: "한식", storeInfo: nil, address: "서울 영등포구 경인로77길 16", latitude: 37.51667, longitude: 126.90699, inVideoMenus: ["칼국수", "만두"]),
                Restaurant(name: "원조 평양냉면집", category: "한식", storeInfo: nil, address: "인천 중구 답동로11번길 6", latitude: 37.47306, longitude: 126.62871, inVideoMenus: ["평양냉면", "불고기"]),
                Restaurant(name: "만석장", category: "한식", storeInfo: nil, address: "서울 종로구 종로3길 17", latitude: 37.57094, longitude: 126.97874, inVideoMenus: ["쌈밥정식", "두부"]),
            ]
        )
    
    // MARK: - 또간집 (풍자)
    
    static let ttoGanJibTheme = RestaurantTheme(
            themeName: "풍자의 또간집",
            restaurants: [
                Restaurant(name: "땀땀 강남본점", category: "아시안", storeInfo: nil, address: "서울 강남구 강남대로98길 12-5", latitude: 37.50051, longitude: 127.02802, inVideoMenus: ["매운 소곱창 쌀국수"]),
                Restaurant(name: "진주회관", category: "한식", storeInfo: nil, address: "서울 중구 세종대로11길 26", latitude: 37.56410, longitude: 126.97573, inVideoMenus: ["콩국수", "김치볶음밥"]),
                Restaurant(name: "남도분식 북촌본점", category: "분식", storeInfo: nil, address: "서울 종로구 북촌로 42-1", latitude: 37.58088, longitude: 126.98434, inVideoMenus: ["빨콩떡볶이", "상추튀김", "김밥쌈"]),
                Restaurant(name: "고갯마루집", category: "한식", storeInfo: nil, address: "서울 마포구 동교로 155", latitude: 37.55946, longitude: 126.92312, inVideoMenus: ["양념게장 백반"]),
                Restaurant(name: "호랑이굴", category: "한식", storeInfo: nil, address: "서울 성동구 독서당로 227", latitude: 37.54327, longitude: 127.02851, inVideoMenus: ["곱창전골"]),
                Restaurant(name: "미도식당", category: "양식", storeInfo: nil, address: "서울 광진구 동일로 241", latitude: 37.55441, longitude: 127.07419, inVideoMenus: ["명란 크림 파스타", "스테이크 덮밥"]),
                Restaurant(name: "마포갈매기 본점", category: "한식", storeInfo: nil, address: "서울 마포구 토정로 313-3", latitude: 37.54139, longitude: 126.95112, inVideoMenus: ["마포갈매기", "돼지껍데기"]),
                Restaurant(name: "미로식당", category: "한식/분식", storeInfo: nil, address: "서울 마포구 양화로19길 22-22", latitude: 37.55601, longitude: 126.92455, inVideoMenus: ["떡볶이", "곱도리탕"]),
                Restaurant(name: "오봉집 문래본점", category: "한식", storeInfo: nil, address: "서울 영등포구 당산로 34", latitude: 37.51917, longitude: 126.89401, inVideoMenus: ["직화낙지볶음", "보쌈"]),
                ]
            )
    
    // MARK: - 최자로드
    
    static let choizaLoadTheme = RestaurantTheme(
            themeName: "최자로드",
            restaurants: [
                Restaurant(name: "오통영", category: "한식", storeInfo: nil, address: "서울 강남구 압구정로46길 71", latitude: 37.52906, longitude: 127.04169, inVideoMenus: ["굴전", "멍게비빔밥", "매생이탕"]),
                Restaurant(name: "중앙갈치식당", category: "한식", storeInfo: nil, address: "서울 중구 남대문시장길 22-12", latitude: 37.55979, longitude: 126.97715, inVideoMenus: ["갈치조림"]),
                Restaurant(name: "호수집", category: "한식", storeInfo: nil, address: "서울 중구 청파로 443", latitude: 37.55577, longitude: 126.97080, inVideoMenus: ["닭꼬치", "닭볶음탕"]),
                Restaurant(name: "대성집", category: "한식", storeInfo: nil, address: "서울 종로구 사직로 5", latitude: 37.57618, longitude: 126.96882, inVideoMenus: ["도가니탕", "수육"]),
                Restaurant(name: "금돼지식당", category: "한식", storeInfo: nil, address: "서울 중구 다산로 149", latitude: 37.55854, longitude: 127.01124, inVideoMenus: ["본삼겹", "등목살", "김치찌개"]),
                Restaurant(name: "몽크스부처", category: "채식/양식", storeInfo: nil, address: "서울 강남구 선릉로155길 5", latitude: 37.52731, longitude: 127.03654, inVideoMenus: ["비건 버거", "두부 크림 파스타", "비건 피자"]), // 채식 레스토랑
                Restaurant(name: "영화루", category: "중식", storeInfo: nil, address: "서울 종로구 자하문로7길 65", latitude: 37.58316, longitude: 126.96998, inVideoMenus: ["고추간짜장", "탕수육"]),
                Restaurant(name: "안동장", category: "중식", storeInfo: nil, address: "서울 중구 을지로 124", latitude: 37.56614, longitude: 126.99023, inVideoMenus: ["굴짬뽕", "송이덮밥"]),
                Restaurant(name: "수퍼판", category: "퓨전 한식", storeInfo: nil, address: "서울 용산구 이태원로55가길 37", latitude: 37.53947, longitude: 126.99915, inVideoMenus: ["매생이굴떡국", "더덕구이 샐러드", "고사리 파스타"]), // 이혜정 셰프 운영
                Restaurant(name: "가타쯔무리", category: "일식", storeInfo: nil, address: "서울 마포구 성미산로 198", latitude: 37.56332, longitude: 126.92170, inVideoMenus: ["우동", "붓카케 우동"]), // 오복수산 옆집
                Restaurant(name: "소설한남", category: "한식", storeInfo: nil, address: "서울 용산구 한남대로20길 21-18", latitude: 37.53789, longitude: 127.00307, inVideoMenus: ["한식 코스 (시기별 변동)"]), // 파인 다이닝
            ]
        )
    
    // MARK: - 홍석천 이원일
    
    static let hongSeokCheonTheme = RestaurantTheme(
            themeName: "홍석천이원일",
            restaurants: [
                Restaurant(name: "소와나", category: "한식", storeInfo: nil, address: "서울 강남구 도산대로55길 49", latitude: 37.52568, longitude: 127.03941, inVideoMenus: ["한우 오마카세", "특수부위"]),
                Restaurant(name: "네기실비", category: "한식", storeInfo: nil, address: "서울 강남구 논현로150길 10", latitude: 37.51653, longitude: 127.03069, inVideoMenus: ["소고기 주물럭", "대파 김치"]),
                Restaurant(name: "한와담 블랙", category: "한식", storeInfo: nil, address: "서울 용산구 독서당로 67", latitude: 37.53635, longitude: 127.00831, inVideoMenus: ["한우 안심", "깍두기 볶음밥"]),
                Restaurant(name: "바오바", category: "아시안", storeInfo: nil, address: "서울 용산구 이태원로42길 48", latitude: 37.53560, longitude: 126.99770, inVideoMenus: ["바오", "타이완식 볶음밥"]),
                Restaurant(name: "단상", category: "퓨전 한식", storeInfo: nil, address: "서울 강남구 도산대로55길 46", latitude: 37.52583, longitude: 127.03890, inVideoMenus: ["감태 타르트", "들기름 카펠리니", "한식 코스"]),
                Restaurant(name: "피자에비뉴", category: "양식", storeInfo: nil, address: "서울 강남구 강남대로110길 13", latitude: 37.50254, longitude: 127.02845, inVideoMenus: ["페퍼로니 피자", "치즈 피자"]),
                Restaurant(name: "목로", category: "한식", storeInfo: nil, address: "서울 용산구 이태원로54길 16-6", latitude: 37.53817, longitude: 127.00008, inVideoMenus: ["곱도리탕", "육전"]), // 이태원
                Restaurant(name: "로컬릿", category: "채식/양식", storeInfo: nil, address: "서울 서초구 동광로 95", latitude: 37.48530, longitude: 126.99240, inVideoMenus: ["비건 라자냐", "부라타 샐러드"]), // 방배동 채식 레스토랑
                Restaurant(name: "창화루", category: "중식", storeInfo: nil, address: "서울 종로구 수표로 28", latitude: 37.57258, longitude: 126.98753, inVideoMenus: ["샤오롱바오", "탄탄면", "마파두부"]), // 익선동 분점 등 여러 곳
                Restaurant(name: "라페름", category: "샐러드/브런치", storeInfo: nil, address: "서울 용산구 이태원로54길 32", latitude: 37.53834, longitude: 127.00087, inVideoMenus: ["퀴노아 샐러드", "아보카도 샐러드", "치킨 스테이크"]), // 한남동
                Restaurant(name: "무궁화", category: "한식", storeInfo: nil, address: "서울 중구 을지로 30 (롯데호텔 38층)", latitude: 37.56528, longitude: 126.98020, inVideoMenus: ["한정식 코스"]), // 파인 다이닝
            ]
        )
    
    // MARK: - 백종원 (골목식당, 스트리트푸드파이터 등)
    
    static let baekJongWonTheme = RestaurantTheme(
            themeName: "님아 그 시장을 가오",
            restaurants: [
                // --- 예산시장 편 ---
                Restaurant(name: "시장 국밥", category: "한식", storeInfo: nil, address: "충남 예산군 예산읍 예산시장 (백종원 거리 인근)", latitude: 36.67870, longitude: 126.84520, inVideoMenus: ["돼지국밥", "소머리국밥"]), // 예산시장 대표 위치
                Restaurant(name: "선봉국수", category: "한식", storeInfo: nil, address: "충남 예산군 예산읍 예산시장 (백종원 거리 인근)", latitude: 36.67870, longitude: 126.84520, inVideoMenus: ["파기름 비빔국수", "잔치국수"]),
                Restaurant(name: "신광정육점 (불판)", category: "한식/기타", storeInfo: nil, address: "충남 예산군 예산읍 예산시장 (백종원 거리 인근)", latitude: 36.67870, longitude: 126.84520, inVideoMenus: ["삼겹살", "목살", "갈매기살 (직접 구워먹기)"]),
                Restaurant(name: "백술상회", category: "기타", storeInfo: nil, address: "충남 예산군 예산읍 예산시장 (백종원 거리 인근)", latitude: 36.67870, longitude: 126.84520, inVideoMenus: ["예산 사과 막걸리", "골목 막걸리"]),
                Restaurant(name: "연돈볼카츠 예산시장점", category: "분식", storeInfo: nil, address: "충남 예산군 예산읍 예산시장 (백종원 거리 인근)", latitude: 36.67870, longitude: 126.84520, inVideoMenus: ["연돈볼카츠"]),
                 Restaurant(name: "시장꽈배기", category: "분식/디저트", storeInfo: nil, address: "충남 예산군 예산읍 예산시장 (백종원 거리 인근)", latitude: 36.67870, longitude: 126.84520, inVideoMenus: ["꽈배기", "찹쌀도너츠"]),

                // --- 강릉 중앙시장 편 ---
                Restaurant(name: "강릉 성남 칼국수", category: "한식", storeInfo: nil, address: "강원 강릉시 중앙시장길 22-2 (성남동)", latitude: 37.75221, longitude: 128.89832, inVideoMenus: ["장칼국수"]),
                Restaurant(name: "놀랄 호떡 군만두", category: "분식", storeInfo: nil, address: "강원 강릉시 금성로13번길 11-1 (성남동, 중앙시장 내)", latitude: 37.75235, longitude: 128.89870, inVideoMenus: ["아이스크림 호떡", "모짜렐라 치즈 호떡"]),
                Restaurant(name: "팡파미유 육쪽마늘빵", category: "카페/디저트", storeInfo: nil, address: "강원 강릉시 금성로13번길 15 (성남동, 중앙시장 근처)", latitude: 37.75248, longitude: 128.89873, inVideoMenus: ["육쪽마늘빵"]),
                Restaurant(name: "중앙시장 어묵고로케 (예: 수제어묵고로케)", category: "분식", storeInfo: nil, address: "강원 강릉시 금성로 21 (성남동, 중앙시장 내)", latitude: 37.75259, longitude: 128.89855, inVideoMenus: ["어묵고로케 (치즈, 김치, 고구마 등)"]), // 특정 가게 지정 어려움

                // --- 제주 동문시장 편 ---
                Restaurant(name: "서울 떡볶이", category: "분식", storeInfo: nil, address: "제주 제주시 동문로4길 11 (이도일동, 동문시장 내)", latitude: 33.51295, longitude: 126.52755, inVideoMenus: ["떡볶이", "튀김", "김밥"]),
                Restaurant(name: "오복 떡집", category: "카페/디저트", storeInfo: nil, address: "제주 제주시 동문로 15 (일도일동, 동문시장 내)", latitude: 33.51308, longitude: 126.52821, inVideoMenus: ["오메기떡"]),
                Restaurant(name: "광명 식당", category: "한식", storeInfo: nil, address: "제주 제주시 동문로4길 9 (이도일동, 동문시장 내)", latitude: 33.51301, longitude: 126.52769, inVideoMenus: ["순대국밥", "순대", "내장"]),
                Restaurant(name: "동문시장 회센터 (예: 딱새우회, 고등어회 파는 곳)", category: "일식/한식", storeInfo: nil, address: "제주 제주시 동문로 (동문시장 내 회센터 구역)", latitude: 33.5131, longitude: 126.5280, inVideoMenus: ["딱새우회", "고등어회", "갈치회"]), // 특정 가게 지정 어려움

                // --- 속초 관광수산시장 편 ---
                Restaurant(name: "만석 닭강정 중앙시장점", category: "한식", storeInfo: nil, address: "강원 속초시 중앙로147번길 16 (중앙동)", latitude: 38.20721, longitude: 128.59071, inVideoMenus: ["닭강정 (보통맛, 매운맛)"]),
                Restaurant(name: "속초 술찐빵 (예: 원조 술찐빵)", category: "분식/디저트", storeInfo: nil, address: "강원 속초시 중앙시장로 (중앙동, 속초관광수산시장 내)", latitude: 38.2068, longitude: 128.5910, inVideoMenus: ["술빵 (막걸리빵)"]), // 특정 가게 지정 어려움
                Restaurant(name: "속초 씨앗호떡 (예: 남포동 찹쌀 씨앗호떡)", category: "분식", storeInfo: nil, address: "강원 속초시 중앙시장로 (중앙동, 속초관광수산시장 내)", latitude: 38.2070, longitude: 128.5912, inVideoMenus: ["씨앗호떡"]), // 특정 가게 지정 어려움
                Restaurant(name: "88생선구이", category: "한식", storeInfo: nil, address: "강원 속초시 중앙부두길 71 (중앙동)", latitude: 38.20400, longitude: 128.59405, inVideoMenus: ["모듬 생선구이"]), // 시장 근처 유명 맛집
            ]
        )
    
}
