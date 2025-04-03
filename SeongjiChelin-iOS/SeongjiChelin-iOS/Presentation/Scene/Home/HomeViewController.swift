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

final class HomeViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: HomeViewModel
    
    private let infoLabel = UILabel()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavMenuBar()
        
        bind()
    }
    
    override func setHierarchy() {
        view.addSubview(infoLabel)
    }
    
    override func setLayout() {
        infoLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func setStyle() {
        view.backgroundColor = .white
        
        infoLabel.do {
            $0.text = "메인 화면입니다."
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 20, weight: .bold)
        }
    }
    
}

private extension HomeViewController {
    
    func setupNavMenuBar() {
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: .left)
        if let sideMenuNav = navigationController as? SideMenuNavigationController {
            sideMenuNav.sideMenuDelegate = self
        }
        
        self.title = "메인"
        let menuImage = UIImage(systemName: "line.horizontal.3")
        let menuButton = UIBarButtonItem(
            image: menuImage,
            style: .plain,
            target: self,
            action: nil
        )
        self.navigationItem.leftBarButtonItem = menuButton
    }
    
    func bind() {
        let input = HomeViewModel.Input(
            menuTapped: self.navigationItem.leftBarButtonItem?.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.menuTrigger?
            .drive(with: self, onNext: { owner, _ in
                guard let menu = SideMenuManager.default.leftMenuNavigationController else {
                    print("SideMenu가 설정되지 않았습니다.")
                    return
                }
                owner.present(menu, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
}

extension HomeViewController: SideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("사이드 메뉴가 나타날 예정입니다. (animated: \(animated))")
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.backgroundColor = self?.view.backgroundColor?.withAlphaComponent(0.4)
        }
        
    }
    
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("사이드 메뉴가 사라질 예정입니다. (animated: \(animated))")
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.backgroundColor = self?.view.backgroundColor?.withAlphaComponent(1.0)
        }
    }
    
}
