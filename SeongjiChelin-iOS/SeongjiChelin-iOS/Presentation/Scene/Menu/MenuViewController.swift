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
    
    private let disposeBag = DisposeBag()
    private let viewModel: MenuViewModel
    
    private let onboardingLabel = UILabel()
    private let underLine1 = UIView()
    private let tableView = UITableView()
    private let underLine2 = UIView()
    private let sirenImageView = UIImageView()
    private let infoSuggestCorrectionLabel = UILabel()
    
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
            onboardingLabel,
            underLine1,
            tableView,
            underLine2,
            sirenImageView,
            infoSuggestCorrectionLabel
        )
    }
    
    override func setLayout() {
        onboardingLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        underLine1.snp.makeConstraints {
            $0.top.equalTo(onboardingLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalTo(onboardingLabel)
            $0.height.equalTo(0.6)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(underLine1.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(5)
            $0.height.equalTo(viewModel.currentMenuItems.count * 40)
        }
        
        underLine2.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(15)
            $0.horizontalEdges.equalTo(onboardingLabel)
            $0.height.equalTo(0.6)
        }
        
        sirenImageView.snp.makeConstraints {
            $0.top.equalTo(underLine2.snp.bottom).offset(15)
            $0.leading.equalTo(onboardingLabel.snp.leading)
            $0.size.equalTo(14)
        }
        
        infoSuggestCorrectionLabel.snp.makeConstraints {
            $0.centerY.equalTo(sirenImageView)
            $0.leading.equalTo(sirenImageView.snp.trailing).offset(4)
            $0.trailing.equalTo(onboardingLabel.snp.trailing)
        }
    }
    
    override func setStyle() {
        view.do {
            $0.backgroundColor = .bg100
            $0.isOpaque = true
            $0.alpha = 1.0
        }
        
        onboardingLabel.setLabelUI(
            "성지슐랭 ＞",
            font: .seongiFont(.title_bold_20),
            textColor: .primary100
        )
        
        tableView.do {
            $0.register(UITableViewCell.self, forCellReuseIdentifier: viewModel.cellIdentifier)
            $0.separatorStyle = .none
            $0.backgroundColor = .clear
            $0.rowHeight = 40
            $0.isScrollEnabled = false
        }
        
        [underLine1, underLine2].forEach { i in
            i.backgroundColor = .lightGray
        }
        
        sirenImageView.do {
            $0.image = UIImage(systemName: "light.beacon.min")
            $0.tintColor = .text100
            $0.contentMode = .scaleAspectFill
        }
        
        infoSuggestCorrectionLabel.setLabelUI(
            "정보 수정 제안 및 QnA",
            font: .seongiFont(.body_regular_14),
            textColor: .text100
        )
    }
    
}

private extension MenuViewController {
    
    func bind() {
        let input = MenuViewModel.Input(
            modelSelected: tableView.rx.modelSelected(String.self)
        )
        
        let output = viewModel.transform(input: input)
        
        output.menuItems
            .drive(
                tableView.rx.items(cellIdentifier: viewModel.cellIdentifier,
                                   cellType: UITableViewCell.self)
            ) { row, element, cell in
                cell.textLabel?.text = element
                cell.textLabel?.textColor = .text100
                cell.textLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        output.selectedItemAction
            .drive(onNext: { [weak self] selectedItem in
                guard let self else { return }
                switch selectedItem {
                case "홈":
                    print("selectedItem: 홈")
                case "나만의 식당":
                    print("selectedItem: 나만의 식당")
                default:
                    self.dismiss(animated: true)
                }
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}
