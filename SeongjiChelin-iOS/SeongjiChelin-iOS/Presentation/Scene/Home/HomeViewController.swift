//
//  ViewController.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/28/25.
//

import UIKit

import GoogleMaps
import RxCocoa
import RxSwift
import SideMenu
import SnapKit
import Then

final class HomeViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: HomeViewModel
    private let selectedFilterSubject = PublishSubject<RestaurantThemeType?>()
    private var currentMarkers: [GMSMarker] = []
    
    private let customNavBar = UIView()
    private let menuButton = UIButton()
    private let micButton = UIButton()
    private let searchTextField: UITextField = UITextField()
    private let favoriteListButton = SJFavoriteButton(isHomeFavorite: true)
    
    private let scrollView = UIScrollView()
    private let restaurantStackView = UIStackView()
    private let psyThemeButton = SJStoreFilterButton(theme: .psyTheme)
    private let sungSiKyungThemeButton = SJStoreFilterButton(theme: .sungSiKyungTheme)
    private let ttoGanJibThemeButton = SJStoreFilterButton(theme: .ttoGanJibTheme)
    private let choizaLoadThemeButton = SJStoreFilterButton(theme: .choizaLoadTheme)
    private let hongSeokCheonThemeButton = SJStoreFilterButton(theme: .hongSeokCheonTheme)
    private let baekJongWonThemeButton = SJStoreFilterButton(theme: .baekJongWonTheme)
    
    let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
    lazy var mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        setupNavMenuBar()
        bind()
    }
    
    override func setHierarchy() {
        view.addSubview(mapView)
        
        mapView.addSubviews(
            customNavBar,
            favoriteListButton,
            scrollView
        )
        
        customNavBar.addSubviews(
            menuButton,
            searchTextField,
            micButton
        )
        
        scrollView.addSubview(restaurantStackView)
        
        restaurantStackView.addArrangedSubviews(
            psyThemeButton,
            sungSiKyungThemeButton,
            ttoGanJibThemeButton,
            choizaLoadThemeButton,
            hongSeokCheonThemeButton,
            baekJongWonThemeButton
        )
    }
    
    override func setLayout() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        customNavBar.snp.makeConstraints {
            $0.top.equalToSuperview().inset(45)
            $0.leading.equalToSuperview().inset(15)
            $0.trailing.equalTo(favoriteListButton.snp.leading).offset(-15)
            $0.height.equalToSuperview().multipliedBy(0.06)
        }
        
        favoriteListButton.snp.makeConstraints {
            $0.top.equalTo(customNavBar.snp.top)
            $0.trailing.equalToSuperview().inset(15)
            $0.height.equalToSuperview().multipliedBy(0.06)
            $0.width.equalToSuperview().multipliedBy(0.14)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(customNavBar.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(hongSeokCheonThemeButton.snp.height)
        }
        
        restaurantStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.height.equalToSuperview()
        }
        
        menuButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.verticalEdges.equalToSuperview().inset(15)
            $0.width.equalTo(menuButton.snp.height)
        }
        
        micButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.verticalEdges.equalToSuperview().inset(15)
            $0.width.equalTo(menuButton.snp.height)
        }
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalTo(menuButton.snp.trailing).offset(6)
            $0.trailing.equalTo(micButton.snp.leading).offset(-6)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func setStyle() {
        view.backgroundColor = .white
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        customNavBar.backgroundColor = .accentBeige
        
        scrollView.do {
            $0.showsHorizontalScrollIndicator = false
        }
        
        restaurantStackView.do {
            $0.axis = .horizontal
            $0.alignment = .leading
            $0.spacing = 8
            $0.distribution = .fillProportionally
        }
    }
    
}

private extension HomeViewController {
    
    func setupNavMenuBar() {
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view, forMenu: .left)
        if let sideMenuNav = navigationController as? SideMenuNavigationController {
            sideMenuNav.sideMenuDelegate = self
        }
        
        customNavBar.do {
            $0.backgroundColor = .bg100
            $0.layer.cornerRadius = 8 // 동적대응되도록 추후 변경
        }
        
        menuButton.do {
            let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
            let boldMenuImage = UIImage(systemName: "line.horizontal.3", withConfiguration: boldConfig)
            $0.setImage(boldMenuImage, for: .normal)
            $0.tintColor = .text200
        }
        
        micButton.do {
            let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
            let boldMenuImage = UIImage(systemName: "microphone", withConfiguration: boldConfig)
            $0.setImage(boldMenuImage, for: .normal)
            $0.tintColor = .text200
        }
        
        searchTextField.do {
            $0.placeholder = "식당, 장소, 카테고리 등 검색"
            $0.textAlignment = .left
        }
    }
    
    func bind() {
        // 모든 필터 버튼의 tapSubject를 하나로 합칩니다.
        let allFilterButtonTaps = Observable.merge(
            psyThemeButton.tapSubject,
            sungSiKyungThemeButton.tapSubject,
            ttoGanJibThemeButton.tapSubject,
            choizaLoadThemeButton.tapSubject,
            hongSeokCheonThemeButton.tapSubject,
            baekJongWonThemeButton.tapSubject
        )
        
        // ViewModel의 Input 준비
        let input = HomeViewModel.Input(
            menuTapped: menuButton.rx.tap.asControlEvent(),
            micTapped: micButton.rx.tap.asControlEvent(),
            selectedFilterTheme: selectedFilterSubject.asObservable()
        )
        
        allFilterButtonTaps
            .subscribe(with: self, onNext: { owner, tappedThemeType in
                owner.updateStoreFilterButtonUI(selectedThemeType: tappedThemeType)
                owner.selectedFilterSubject.onNext(tappedThemeType)
            })
            .disposed(by: disposeBag)
        
        
        // --- Output 바인딩 ---
        let output = viewModel.transform(input: input)
        
        output.menuTrigger
            .drive(with: self, onNext: { owner, _ in
                guard let menu = SideMenuManager.default.leftMenuNavigationController else { return }
                owner.present(menu, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        output.micTrigger
            .drive(with: self, onNext: { owner, _ in
                owner.showToast(message: "음성 검색 기능은 아직 준비 중입니다.")
            })
            .disposed(by: disposeBag)
        
        output.filteredList
            .drive(with: self, onNext: { owner, themes in
                owner.updateMarkers(themes: themes)
            })
            .disposed(by: disposeBag)
    }
    
    func updateStoreFilterButtonUI(selectedThemeType: RestaurantThemeType?) {
        let allButtons = [psyThemeButton, sungSiKyungThemeButton, ttoGanJibThemeButton,
                          choizaLoadThemeButton, hongSeokCheonThemeButton, baekJongWonThemeButton]
        
        for button in allButtons {
            if button.themeType == selectedThemeType {
                button.isSelected = true
            } else {
                button.isSelected = false
            }
        }
    }
    
    /// 지도 마커 업데이트 함수
    func updateMarkers(themes: [RestaurantTheme]) {
        // 1. 기존 마커 제거
        self.currentMarkers.forEach { i in
            i.map = nil
        }
        
        var newMarkers: [GMSMarker] = []
        
        // 2. 마커 추가
        for theme in themes {
            for restaurant in theme.restaurants {
                let position = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
                let marker = GMSMarker(position: position)
                marker.title = restaurant.name
                marker.snippet = "\(restaurant.category) | \(restaurant.address)"
                
                let customMarkerView = CustomMarkerView(themeType: theme.themeType)
                marker.iconView = customMarkerView
                marker.groundAnchor = CGPoint(x: 0.5, y: 1.0)
                
                marker.userData = ["themeType": theme.themeType, "restaurant": restaurant] // 예시 데이터
                
                marker.map = self.mapView
                newMarkers.append(marker)
            }
        }
        
        // 3. 현재 표시된 마커 배열 업데이트
        self.currentMarkers = newMarkers
        
        // 4. 지도 카메라 조정
        fitBoundsToMarkers(markers: newMarkers)
    }
    
    /// 마커에 맞춰 카메라 조정
    func fitBoundsToMarkers(markers: [GMSMarker]) {
        guard !markers.isEmpty else { return }
        
        var bounds = GMSCoordinateBounds()
        for marker in markers {
            bounds = bounds.includingCoordinate(marker.position)
        }
        
        let update: GMSCameraUpdate
        if markers.count == 1 {
            // 마커 하나일 때
            update = GMSCameraUpdate.setTarget(markers.first!.position, zoom: 15)
        } else {
            update = GMSCameraUpdate.fit(bounds, withPadding: 60.0)
        }
        
        mapView.animate(with: update)
    }
    
}

extension HomeViewController: SideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("사이드 메뉴가 나타날 예정입니다. (animated: \(animated))")
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.mapView.alpha = 0.6
        }
        
    }
    
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("사이드 메뉴가 사라질 예정입니다. (animated: \(animated))")
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.mapView.alpha = 1.0
        }
    }
    
}
