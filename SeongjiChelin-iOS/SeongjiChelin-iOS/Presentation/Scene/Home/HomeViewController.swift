//
//  ViewController.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/28/25.
//

import UIKit

import RxCocoa
import RxSwift
import SideMenu
import SnapKit
import Then
import GoogleMaps

final class HomeViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: HomeViewModel
    
    private let customNavBar = UIView()
    private let menuButton = UIButton()
    private let micButton = UIButton()
    private let searchTextField: UITextField = UITextField()
    
    private let favoriteListButton = SJFavoriteButton(isHomeFavorite: true)
    private let sungSiKyungThemeButton = SJStoreFilterButton(image: .eyeglassesImage(), theme: .sungSiKyungTheme)
    private let ttoGanJibThemeButton = SJStoreFilterButton(image: .walkImage(), theme: .ttoGanJibTheme)
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
            sungSiKyungThemeButton,
            ttoGanJibThemeButton
        )
        
        customNavBar.addSubviews(
            menuButton,
            searchTextField,
            micButton
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
        
        sungSiKyungThemeButton.snp.makeConstraints {
            $0.top.equalTo(customNavBar.snp.bottom).offset(10)
            $0.leading.equalTo(customNavBar.snp.leading)
            
        }
        
        ttoGanJibThemeButton.snp.makeConstraints {
            $0.top.equalTo(sungSiKyungThemeButton.snp.top)
            $0.leading.equalTo(sungSiKyungThemeButton.snp.trailing).offset(4)
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
        let input = HomeViewModel.Input(
            menuTapped: menuButton.rx.tap,
            micTapped: micButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.menuTrigger
            .drive(with: self, onNext: { owner, _ in
                guard let menu = SideMenuManager.default.leftMenuNavigationController else {
                    print("SideMenu가 설정되지 않았습니다.")
                    return
                }
                owner.present(menu, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        output.micTrigger
            .drive(with: self, onNext: { owner, _ in
                owner.showToast(message: "음성 검색 기능은 아직 준비 중입니다.")
            })
            .disposed(by: disposeBag)
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
