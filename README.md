# SeongjiChelin (iOS 15.0+) 🍚

> 손안의 미식 여행 안내서

<br>

## 🍚 소개

> 💡 About 성지슐랭
>
> - 서비스 소개
>   - 인플루언서와 앱 개발자 추천 맛집을 지도로 탐색하고, 방문과 찜한 곳을 관리하는 서비스 앱입니다.
> - 개발 인원
>   - 1인 프로젝트
> - 개발 기간
>   - 집중 기간: 2025.03 - 2025.04 (2주)
>   - 유지보수 기간: 2025.04 - 현재 (진행 중)

<br>

## 🍚 About Developer

<div align=left>

| <img width="200px" src="https://avatars.githubusercontent.com/u/114901417?v=4"/> |
| :------------------------------------------------------------------------------: |
|                     [박신영](https://github.com/ParkSY0919)                      |
|                               기획 · 디자인 · iOS                                |

</div>

<br>

## 🍚 주요 화면
|   온보딩   |   사용법   |   홈(맵)   |   홈(리스트)   |
| :-------------: | :-------------: | :-------------: | :-------------: |
| <img src = "https://github.com/user-attachments/assets/a5eea9f1-e0d0-4870-b4c3-4cf8601b038b" width ="160">| <img src = "https://github.com/user-attachments/assets/7a2eb3cb-eec1-4b45-9f1f-02563f1d8862" width ="160">| <img src = "https://github.com/user-attachments/assets/691326bc-4f20-41a5-bf29-26fea9132949" width ="160">| <img src = "https://github.com/user-attachments/assets/22f9cdf6-8f11-4777-ab9b-53ed03ee0186" width ="160">|

|   정보 수정 신고   |   상세보기(개발자 맛집)   |   상세보기(인플루언서 맛집)   |   나만의 식당   |
| :-------------: | :-------------: | :-------------: | :-------------: |
| <img src = "https://github.com/user-attachments/assets/c94978ea-fea3-4032-8eae-f68229ec94bf" width ="160">| <img src = "https://github.com/user-attachments/assets/fb16d0f6-f5a1-4a66-a6b0-bcaf5ead55ee" width ="160">| <img src = "https://github.com/user-attachments/assets/ecaad071-7dda-430d-9aa9-972a8bfbeb22" width ="160">| <img src = "https://github.com/user-attachments/assets/7310a8af-d59d-46dc-bbc0-264d805388df" width ="160">|


<br>

## 🍚 주요 기능

> 💡 성지슐랭 주요 기능
>
> - 구글 맵 기반 맛집 위치 표시 및 탐색
> - 테마별 맛집 필터링 (PSY(개발자), 성시경, 최자로드, 홍석천이원일 등)
> - 지도/리스트 기반 인터페이스 전환 기능
> - 맛집 상세 정보 및 전화 연결 기능
> - 맛집 검색 기능
> - 방문 및 즐겨찾기 맛집 저장, 관리
> - 온보딩 화면을 통한 앱 사용법 안내 및 맛집 정보 수정 신고 기능

<br>


## 🍚 기술 스택 및 내용

> Framework: `UIKit`, `CoreLocation`
>
> Architecture: `MVVM`
>
> Design Patterns: `API Router`, `DI/DIP`, `Repository`, `Input-Output`
>
> Reactive Programming: `RxSwift`
>
> Library: `Alamofire`, `GoogleMaps`, `RealmSwift`, `SideMenu`, `SnapKit`, `Then`, `YouTubePlayerKit` ..

- ViewModel과 Input/Output 패턴으로 테마별 필터링 및 지도/리스트 뷰 전환 시 복잡한 상태를 효율적으로 관리하고, 단방향 데이터 흐름을 구성하여 안정성을 확보했습니다.
- 지도 위에 테마별 맛집 위치를 표시하고 지도/리스트 뷰 간 전환 기능을 구현하여 사용자가 원하는 방식으로 맛집을 탐색할 수 있도록 했습니다.
- RestaurantRepository를 통해 Realm 데이터 접근 및 테마별 맛집 필터링 로직을 캡슐화하여 비즈니스 로직과 데이터 접근 로직을 분리했습니다.
- RealmSwift를 활용해 사용자별 '방문', '즐겨찾기', '평점' 데이터를 효율적으로 저장 및 관리하고, 복잡한 테마별 맛집 데이터 필터링을 구현했습니다.
- CustomMarkerView, SJStoreFilterButton 등 커스텀 컴포넌트를 개발하여 유튜버 테마별 시각적 아이덴티티를 일관되게 적용하고 사용자 경험을 향상시켰습니다.
- 커스텀 마커 개발을 통한 시각화와 시트 표시 시, adjustCameraForMarker 함수로 마커의 가려짐 여부를 판별하여 카메라를 동적 조정했습니다. 마커 선택 시 동작하는 애니메이션과 GMSMapView 연동으로 사용자 인터랙션과 UX를 향상시켰습니다.
- YouTubePlayerKit과 RxCombine을 활용해 YouTubePlayer 상태를 반응형 스트림으로 관리하고, BehaviorRelay와 Driver로 UI와 비디오 상태를 실시간 동기화하였으며, 로딩 상태와 에러 처리를 반영해 사용자 경험을 향상시켰습니다.

<br>
