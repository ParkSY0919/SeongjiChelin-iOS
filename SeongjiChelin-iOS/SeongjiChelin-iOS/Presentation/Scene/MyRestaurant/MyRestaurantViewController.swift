//
//  MyRestaurantViewController.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/12/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class MyRestaurantViewController: BaseViewController {
    
    weak var coordinator: MyRestaurantCoordinator?
    
    private let viewModel: MyRestaurantViewModel
    private let disposeBag = DisposeBag()
    private var currentFilterType: SJFilterType = .all
    private var currentDetailViewController: DetailViewController?
    
    private let titleLabel = UILabel()
    private let backButton = UIButton()
    private let filterView = SJFilterView()
    private let tableView = UITableView()
    private let emptyView = EmptyRestaurantView()
    
    init(viewModel: MyRestaurantViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchRestaurants(filter: .all)
    }
    
    override func setHierarchy() {
        view.addSubviews(
            titleLabel,
            backButton,
            filterView,
            tableView,
            emptyView
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.size.equalTo(35)
        }
        
        filterView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(22)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(filterView.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints {
            $0.center.equalTo(tableView)
            $0.size.equalTo(CGSize(width: 240, height: 200))
        }
    }
    
    override func setStyle() {
        view.backgroundColor = .bg150
        
        titleLabel.do {
            $0.text = StringLiterals.shared.myRestaurants
            $0.font = .seongiFont(.title_bold_20)
            $0.textColor = .text100
        }
        
        backButton.do {
            $0.setImage(ImageLiterals.xmark, for: .normal)
            $0.tintColor = .text100
            $0.backgroundColor = .bg200
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = 35/2
        }
        
        emptyView.isHidden = true
        
        tableView.do {
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.rowHeight = 120
            $0.register(MyRestaurantTableViewCell.self, forCellReuseIdentifier: MyRestaurantTableViewCell.identifier)
        }
    }
    
    private func bindViewModel() {
        let input = MyRestaurantViewModel.Input(
            filterType: filterView.selectedFilterSubject,
            tableCellTapped: tableView.rx.modelSelected(Restaurant.self),
            backButtonTapped: backButton.rx.controlEvent(.touchUpInside)
        )
        let output = viewModel.transform(input: input)
        
        // 현재 필터 타입 저장
        filterView.selectedFilterSubject
            .subscribe(onNext: { [weak self] filterType in
                self?.currentFilterType = filterType
            })
            .disposed(by: disposeBag)
        
        output.restaurants
            .drive(tableView.rx.items(cellIdentifier: MyRestaurantTableViewCell.identifier, cellType: MyRestaurantTableViewCell.self)) { row, element, cell in
                cell.configure(with: element)
            }.disposed(by: disposeBag)
        
        output.isEmpty
            .drive(with: self) { owner, isEmpty in
                owner.updateEmptyView(isEmpty: isEmpty)
            }.disposed(by: disposeBag)
        
        output.tableCellTrigger
            .drive(with: self) { owner, restaurantTable in
                owner.navigateToDetailView(with: restaurantTable)
            }.disposed(by: disposeBag)
        
        output.backButtonTrigger
            .drive(with: self) { owner, _ in
                owner.backButtonTapped()
            }.disposed(by: disposeBag)
    }
    
    private func updateEmptyView(isEmpty: Bool) {
        emptyView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    private func navigateToDetailView(with restaurant: Restaurant) {
        if let detailVC = self.currentDetailViewController,
           self.presentedViewController === detailVC {
            detailVC.updateRestaurantInfo(restaurant)
        } else {
            // 없으면 새로 생성해서 표시
            let vm = DetailViewModel(restaurantInfo: restaurant)
            let detailVC = DetailViewController(viewModel: vm)
            detailVC.onChangeState = { [weak self] in
                guard let self else { return }
                self.filterView.selectedFilterSubject.onNext(self.currentFilterType)
            }
            self.present(detailVC, animated: true) { [weak self] in
                self?.currentDetailViewController = detailVC
            }
        }
    }
    
    @objc
    private func backButtonTapped() {
        coordinator?.didFinishMyRestaurant()
        
        if coordinator == nil {
            navigationController?.popViewController(animated: true)
        }
    }
    
}
