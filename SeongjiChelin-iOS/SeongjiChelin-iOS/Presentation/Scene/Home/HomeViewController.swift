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
    private var selectedMarker: GMSMarker?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(#function)
        viewModel.willAppearTrigger.onNext(())
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
            $0.isHidden = true
        }
        
        searchTextField.do {
            $0.placeholder = "식당, 주소 등을 입력해주세요."
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
            selectedFilterTheme: selectedFilterSubject.asObservable(),
            searchTextField: searchTextField.rx.text.orEmpty
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
        
        
        output.searchTextFieldTrigger
            .bind(with: self) { owner, text in
                print("text: \(text)")
                owner.modeChange(isListView: true)
            }.disposed(by: disposeBag)
        
        searchTextField.rx.controlEvent(.editingDidEnd)
            .subscribe(with: self) { owner, _ in
                if owner.searchTextField.text?.isEmpty ?? true {
                    print("Search text is empty.")
                    owner.modeChange()
                }
            }
            .disposed(by: disposeBag)
        
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
    
    func modeChange(isListView: Bool = false) {
        if let detailVC = currentDetailViewController,
           presentedViewController === detailVC {
            dismiss(animated: true)
        }
        var isListState = false
        
        if !isListView {
            modeChangeButton.isSelected.toggle()
            isListState = modeChangeButton.isSelected
        } else {
            modeChangeButton.isSelected = true
            isListState = true
        }
        
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
            let myRestaurantVC = MyRestaurantViewController(viewModel: MyRestaurantViewModel(repo: RestaurantRepository()))
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
    
    ///마커 표시 로직
    private func selectMarker(_ marker: GMSMarker, restaurant: Restaurant) {
        resetSelectedMarker()
        
        if let customIconView = marker.iconView as? CustomMarkerView {
            customIconView.scaleUp()
        }
        //다른 마커 위에 보이도록 zIndex 설정
         marker.zIndex = 1
        
        selectedMarker = marker
    }
    
    ///현재 선택된 마커를 원상태
    private func resetSelectedMarker() {
        if let marker = selectedMarker {
            if let customIconView = marker.iconView as? CustomMarkerView {
                customIconView.resetScale()
            }
            //zIndex 초기화
             marker.zIndex = 0
        }
        selectedMarker = nil
    }
    
}

extension HomeViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let userData = marker.userData as? [String: Any],
              let restaurant = userData["restaurant"] as? Restaurant else {
            resetSelectedMarker()
            return true
        }
        
        
        
        // 시트를 표시하고 카메라를 조정하는 로직을 캡슐화
        let presentAndAdjustCamera = { [weak self] (targetRestaurant: Restaurant, tappedMarker: GMSMarker) in
            guard let self else { return }
            
            let vm = DetailViewModel(restaurantInfo: targetRestaurant)
            let vc = DetailViewController(viewModel: vm)
            
            vc.onDismiss = { [weak self] in
                self?.resetSelectedMarker()
            }
            
            // 시트 표시
            self.present(vc, animated: true) { [weak self, tappedMarker] in
                guard let self = self,
                      let presentedSheetView = vc.view,
                      let window = self.view.window else {
                    print("Error: Could not get self, presentedSheetView, or window.")
                    self?.currentDetailViewController = vc
                    return
                }
                
                //1. 시트 뷰의 bounds를 윈도우 좌표계로 변환하여 프레임 얻기
                let sheetFrameInWindow = presentedSheetView.convert(presentedSheetView.bounds, to: window)
                let sheetTopY = sheetFrameInWindow.minY // 윈도우 기준 Y 좌표
                print("Sheet Frame in Window (Completion): \(sheetFrameInWindow)")
                
                //2. 마커의 화면 좌표 얻기 (MapView 기준)
                let markerPointOnMap = self.mapView.projection.point(for: tappedMarker.position)
                let markerPointOnWindow = self.mapView.convert(markerPointOnMap, to: window)
                let markerWindowY = markerPointOnWindow.y
                
                //마커와 시트뷰 사이 여백 보장
                let desiredMarkerVisiblePadding: CGFloat = 50
                let desiredMarkerVisibleY = sheetTopY - desiredMarkerVisiblePadding
                
                //마커가 detailVC에 가려진다면
                if markerWindowY > desiredMarkerVisibleY {
                    //그럼 맵뷰 카메라 이동
                    let scrollAmountY = markerWindowY - desiredMarkerVisibleY
                    let update = GMSCameraUpdate.scrollBy(x: 0, y: scrollAmountY)
                    self.mapView.animate(with: update)
                }
                
                self.currentDetailViewController = vc
            }
        }
        
        // 현재 표시된 DetailViewController가 있는지 확인
        if let detailVC = currentDetailViewController, presentedViewController === detailVC {
            print("Updating existing DetailViewController.")
            detailVC.updateRestaurantInfo(restaurant)
            DispatchQueue.main.async { [weak self] in
                self?.adjustCameraForMarker(marker, relativeTo: detailVC.view)
            }
        } else {
            print("Presenting new DetailViewController.")
            presentAndAdjustCamera(restaurant, marker)
        }
        
        selectMarker(marker, restaurant: restaurant)
        
        //기본 마커 탭 동작(카메라 자동 중앙 이동)을 막음
        return true
    }
    
    //카메라 조정을 위한 헬퍼 함수 (재사용 및 가독성 위해 분리)
    private func adjustCameraForMarker(_ marker: GMSMarker, relativeTo sheetView: UIView) {
        guard let window = view.window else {
            print("Warning: Could not get window. Cannot adjust camera.")
            return
        }
        
        //시트의 화면 상단 Y 좌표 (Window 기준)
        let sheetFrameInWindow = sheetView.convert(sheetView.bounds, to: window)
        let sheetTopY = sheetFrameInWindow.minY
        
        //마커의 화면 좌표 (MapView 기준)
        let markerPointOnMap = mapView.projection.point(for: marker.position)
        let markerPointOnWindow = mapView.convert(markerPointOnMap, to: window)
        let markerWindowY = markerPointOnWindow.y
        
        //마커가 보여야 할 최소 Y 좌표
        let desiredMarkerVisiblePadding: CGFloat = 50
        let desiredMarkerVisibleY = sheetTopY - desiredMarkerVisiblePadding
        
        //마커가 시트에 가려지는지 확인 및 스크롤
        if markerWindowY > desiredMarkerVisibleY {
            let scrollAmountY = markerWindowY - desiredMarkerVisibleY
            let update = GMSCameraUpdate.scrollBy(x: 0, y: scrollAmountY)
            print("Adjusting camera for marker. Scrolling map by \(scrollAmountY) points.")
            mapView.animate(with: update)
        }
    }
    
    ///지도 탭 했을 시 sheet 닫기
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("Map tapped at coordinate: \(coordinate)")
        resetSelectedMarker()
        //열려있는 DetailVC 닫기
        if let detailVC = currentDetailViewController, presentedViewController === detailVC {
            detailVC.dismiss(animated: true)
            currentDetailViewController = nil
        }
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


