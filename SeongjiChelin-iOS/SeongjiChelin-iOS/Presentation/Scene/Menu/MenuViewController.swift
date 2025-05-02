//
//  MenuViewController.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/3/25.
//

import UIKit

import RxCocoa
import RxSwift
import SideMenu
import SnapKit
import Then

struct SideMenuSetup {
    
    static func setupSideMenu() {
        let menuViewController = MenuViewController(viewModel: MenuViewModel())
        
        let menuNavigationController = SideMenuNavigationController(rootViewController: menuViewController)
        SideMenuManager.default.leftMenuNavigationController = menuNavigationController
        menuNavigationController.presentationStyle = .menuSlideIn
        menuNavigationController.pushStyle = .default
        menuNavigationController.presentDuration = 0.5
        menuNavigationController.dismissDuration = 0.35
    }
    
}

final class MenuViewController: BaseViewController {
    
    // MARK: - Properties
    var onMenuItemSelected: ((String) -> Void)?
    
    private let disposeBag = DisposeBag()
    private let viewModel: MenuViewModel
    
    private let logoImageView = UIImageView()
    private let underLine1 = UIView()
    private let tableView = UITableView()
    private let underLine2 = UIView()
    private let sirenImageView = UIImageView()
    private let infoSuggestCorrectionLabel = UILabel()
    private let labelTapGesture = UITapGestureRecognizer()
    
    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func setHierarchy() {
        view.addSubviews(
            logoImageView,
            underLine1,
            tableView,
            underLine2,
            sirenImageView,
            infoSuggestCorrectionLabel
        )
    }
    
    override func setLayout() {
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(18)
            $0.width.equalTo(110)
            $0.height.equalTo(logoImageView.snp.width).multipliedBy(0.5)
        }
        
        underLine1.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(15)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(18)
            $0.height.equalTo(0.6)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(underLine1.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.height.equalTo(viewModel.currentMenuItems.count * 40)
        }
        
        underLine2.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(15)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(18)
            $0.height.equalTo(0.6)
        }
        
        sirenImageView.snp.makeConstraints {
            $0.top.equalTo(underLine2.snp.bottom).offset(15)
            $0.leading.equalTo(underLine2.snp.leading).offset(-2)
            $0.size.equalTo(18)
        }
        
        infoSuggestCorrectionLabel.snp.makeConstraints {
            $0.bottom.equalTo(sirenImageView.snp.bottom)
            $0.leading.equalTo(sirenImageView.snp.trailing).offset(4)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func setStyle() {
        view.do {
            $0.backgroundColor = .bg100
            $0.isOpaque = true
            $0.alpha = 1.0
            $0.layer.shadowColor = UIColor.text200.cgColor
            $0.layer.shadowOpacity = 0.5
        }
        
        logoImageView.do {
            $0.image = ImageLiterals.horizentalLogo
            $0.contentMode = .scaleAspectFill
        }
        
        tableView.do {
            $0.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
            $0.separatorStyle = .none
            $0.backgroundColor = .clear
            $0.rowHeight = 40
            $0.isScrollEnabled = false
        }
        
        [underLine1, underLine2].forEach { i in
            i.backgroundColor = .primary200
        }
        
        sirenImageView.do {
            $0.image = ImageLiterals.siren
            $0.contentMode = .scaleAspectFill
            $0.tintColor = .primary300.withAlphaComponent(0.6)
        }
        
        infoSuggestCorrectionLabel.do {
            $0.setLabelUI(
                "정보 수정 신고",
                font: .seongiFont(.body_black_14),
                textColor: .primary200.withAlphaComponent(0.6)
            )
            $0.addGestureRecognizer(labelTapGesture)
            $0.isUserInteractionEnabled = true
        }
    }
    
}

private extension MenuViewController {
    
    func bind() {
        let input = MenuViewModel.Input(
            modelSelected: tableView.rx.modelSelected(String.self),
            infoLabelTapped: labelTapGesture.rx.event
        )
        
        let output = viewModel.transform(input: input)
        
        output.menuItems
            .drive(
                tableView.rx.items(cellIdentifier: MenuTableViewCell.identifier,
                                   cellType: MenuTableViewCell.self)
            ) { row, element, cell in
                cell.selectionStyle = .none
                cell.configureMenuCell(title: element)
            }
            .disposed(by: disposeBag)
        
        output.selectedItemAction
            .drive(onNext: { [weak self] selectedItem in
                guard let self else { return }
                // 클로저를 통해 선택된 메뉴 항목 전달
                self.onMenuItemSelected?(selectedItem)
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.infoLabelTrigger
            .drive(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true) {
                    owner.onMenuItemSelected?("정보 수정 신고")
                }
            }).disposed(by: disposeBag)
    }
    
}
