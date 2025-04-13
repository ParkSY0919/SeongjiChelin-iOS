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
    private let modeChangeButton = UIButton()
    
    private let scrollView = UIScrollView()
    private let restaurantStackView = UIStackView()
    private let psyThemeButton = SJStoreFilterButton(theme: .psyTheme)
    private let sungSiKyungThemeButton = SJStoreFilterButton(theme: .sungSiKyungTheme)
    private let ttoGanJibThemeButton = SJStoreFilterButton(theme: .ttoGanJibTheme)
    private let choizaLoadThemeButton = SJStoreFilterButton(theme: .choizaLoadTheme)
    private let hongSeokCheonThemeButton = SJStoreFilterButton(theme: .hongSeokCheonTheme)
    private let baekJongWonThemeButton = SJStoreFilterButton(theme: .baekJongWonTheme)
    
    private lazy var mapView = GMSMapView(options: .init())
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupCollectionView())
    
    private var currentDetailViewController: DetailViewController?
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        setupNavMenuBar()
        setupModeChangeButton()
        bind()
    }
    
    override func setHierarchy() {
        view.addSubview(mapView)
        
        view.addSubviews(
            customNavBar,
            modeChangeButton,
            scrollView,
            collectionView
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
            $0.top.equalToSuperview().inset(55)
            $0.leading.equalToSuperview().inset(15)
            $0.trailing.equalTo(modeChangeButton.snp.leading).offset(-15)
            $0.height.equalToSuperview().multipliedBy(0.06)
        }
        
        modeChangeButton.snp.makeConstraints {
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
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
    }
    
    override func setStyle() {
        view.backgroundColor = .bg150
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: 37.5665, longitude: 126.9780, zoom: 12.0)
        
        scrollView.do {
            $0.showsHorizontalScrollIndicator = false
        }
        
        restaurantStackView.do {
            $0.axis = .horizontal
            $0.alignment = .leading
            $0.spacing = 8
            $0.distribution = .fillProportionally
        }
        
        collectionView.do {
            $0.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
            $0.isHidden = true
            $0.backgroundColor = .clear
        }
    }
    
}

private extension HomeViewController {
    
    func setupNavMenuBar() {
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view, forMenu: .left)
        if let sideMenuNav = navigationController as? SideMenuNavigationController {
            sideMenuNav.sideMenuDelegate = self
        }
        
        // MenuViewController의 클로저 설정
        if let menuVC = SideMenuManager.default.leftMenuNavigationController?.viewControllers.first as? MenuViewController {
            menuVC.onMenuItemSelected = { [weak self] selectedItem in
                self?.handleMenuSelection(selectedItem)
            }
        }
        
        mapView.delegate = self
        
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
    
    func setupModeChangeButton() {
        modeChangeButton.do {
            var buttonConfiguration = UIButton.Configuration.plain()
            
            buttonConfiguration.baseForegroundColor = .bg100
            buttonConfiguration.background.backgroundColor = .primary200
            
            buttonConfiguration.imagePlacement = .top
            buttonConfiguration.imagePadding = 4
            buttonConfiguration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.seongiFont(.body_bold_10)
                outgoing.foregroundColor = .bg100
                return outgoing
            }
            $0.configuration = buttonConfiguration
            
            let buttonStateHandler: UIButton.ConfigurationUpdateHandler = { button in
                switch button.state {
                case .normal:
                    button.configuration?.title = "리스트"
                    button.configuration?.image = UIImage(systemName: "list.star")
                case .selected:
                    button.configuration?.title = "지도"
                    button.configuration?.image = UIImage(systemName: "map")
                default:
                    return
                }
            }
            $0.configurationUpdateHandler = buttonStateHandler
        }
    }
    
    func setupCollectionView() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 14
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        let width = (ConstantLiterals.ScreenSize.width - 20)
        layout.itemSize = CGSize(width: width, height: 200)
        layout.scrollDirection = .vertical
        
        return layout
    }
    
    func bind() {
        // 모든 필터 버튼의 tapSubject를 하나로 머지
        let allFilterButtonTaps = Observable.merge(
            psyThemeButton.tapSubject,
            sungSiKyungThemeButton.tapSubject,
            ttoGanJibThemeButton.tapSubject,
            choizaLoadThemeButton.tapSubject,
            hongSeokCheonThemeButton.tapSubject,
            baekJongWonThemeButton.tapSubject
        )
        
        /// Input 바인딩
        let input = HomeViewModel.Input(
            menuTapped: menuButton.rx.tap.asControlEvent(),
            micTapped: micButton.rx.tap.asControlEvent(),
            modeChangeTapped: modeChangeButton.rx.tap,
            listCellTapped: collectionView.rx.modelSelected((RestaurantTheme, Restaurant).self),
            selectedFilterTheme: selectedFilterSubject.asObservable()
        )
        
        allFilterButtonTaps
            .subscribe(with: self, onNext: { owner, tappedThemeType in
                owner.updateStoreFilterButtonUI(selectedThemeType: tappedThemeType)
                owner.selectedFilterSubject.onNext(tappedThemeType)
            })
            .disposed(by: disposeBag)
        
        /// Output 바인딩
        let output = viewModel.transform(input: input)
        
        output.menuTrigger
            .drive(with: self, onNext: { owner, _ in
                guard let menu = SideMenuManager.default.leftMenuNavigationController else { return }
                if let detailVC = owner.currentDetailViewController,
                   owner.presentedViewController === detailVC {
                    owner.dismiss(animated: true)
                }
                owner.present(menu, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        output.micTrigger
            .drive(with: self, onNext: { owner, _ in
                owner.showToast(message: "음성 검색 기능은 아직 준비 중입니다.")
            })
            .disposed(by: disposeBag)
        
        output.modeChangeTrigger
            .drive(with: self) { owner, _ in
                owner.modeChange()
            }.disposed(by: disposeBag)
        
        output.listCellTrigger
            .subscribe(with: self) { owner, tupleData in
                print("cell이 클릭되었습니다")
                let (_, restaurant) = tupleData
//                 현재 표시된 DetailViewController가 있는지 확인
                if let detailVC = owner.currentDetailViewController,
                   owner.presentedViewController === detailVC {
                    detailVC.updateRestaurantInfo(restaurant)
                } else {
                    // 없으면 새로 생성해서 표시
                    let vm = DetailViewModel(restaurantInfo: restaurant)
                    let vc = DetailViewController(viewModel: vm)
                    owner.present(vc, animated: true) { [weak self] in
                        self?.currentDetailViewController = vc
                    }
                }
            }.disposed(by: disposeBag)
        
        output.filteredList
            .drive(with: self, onNext: { owner, themes in
                owner.updateMarkers(themes: themes)
            })
            .disposed(by: disposeBag)
        
        output.filteredCellList
            .map { themes in
                themes.flatMap { theme in
                    theme.restaurants.map { restaurant in
                        (theme, restaurant)
                    }
                }
            }
            .drive(collectionView.rx.items(cellIdentifier: HomeCollectionViewCell.identifier, cellType: HomeCollectionViewCell.self)) { item, data, cell in
                let (theme, restaurant) = data
                cell.configureCell(theme: theme, store: restaurant)
            }
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
    
    func modeChange() {
        if let detailVC = currentDetailViewController,
           presentedViewController === detailVC {
            dismiss(animated: true)
        }
        modeChangeButton.isSelected.toggle()
        let isListState = modeChangeButton.isSelected
        
        UIView.animate(withDuration: 1.0) { [weak self] in
            guard let self else { return }
            
            switch isListState == true {
            case true:
                self.mapView.isHidden = true
                self.collectionView.isHidden = false
            case false:
                self.mapView.isHidden = false
                self.collectionView.isHidden = true
            }
        }
    }
    
    func handleMenuSelection(_ selectedItem: String) {
        print(#function)
        switch selectedItem {
        case "홈":
            print("홈홈홈")
        case "나만의 식당":
            let myRestaurantVC = MyRestaurantViewController()
            self.navigationController?.pushViewController(myRestaurantVC, animated: true)
        case "사용법":
            let onboardingVC = OnboardingViewController()
            UIView.animate(withDuration: 0.5) {
                self.navigationController?.pushViewController(onboardingVC, animated: true)
            }
        case "정보 수정 신고":
            let webVC = SJWebViewController(urlString: "https://notch-crate-349.notion.site/1d46931aa0158095b055d762d55f5d2a?pvs=4")
            self.present(webVC, animated: true)
        default:
            break
        }
    }
    
}

extension HomeViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let userData = marker.userData as? [String: Any],
           let restaurant = userData["restaurant"] as? Restaurant {
            
            // 현재 표시된 DetailViewController가 있는지 확인
            if let detailVC = currentDetailViewController,
               presentedViewController === detailVC {
                // 이미 표시된 DetailViewController가 있으면 내용만 업데이트
                detailVC.updateRestaurantInfo(restaurant)
            } else {
                // 없으면 새로 생성해서 표시
                let vm = DetailViewModel(restaurantInfo: restaurant)
                let vc = DetailViewController(viewModel: vm)
                present(vc, animated: true) { [weak self] in
                    self?.currentDetailViewController = vc
                }
            }
        }
        // 기본 동작 작동
        return false
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


