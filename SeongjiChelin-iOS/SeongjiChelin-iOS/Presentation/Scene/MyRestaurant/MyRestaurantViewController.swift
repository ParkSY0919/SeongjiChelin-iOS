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
    
    // MARK: - Properties
    
    private let viewModel = MyRestaurantViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let filterView = SJFilterView()
    private let tableView = UITableView()
    private let emptyView = EmptyRestaurantView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        print(#function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchRestaurants(filter: .all)
    }
    
    override func setHierarchy() {
        view.addSubviews(
            titleLabel,
            filterView,
            tableView,
            emptyView
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        filterView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
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
            $0.text = "나만의 식당"
            $0.font = .seongiFont(.title_bold_20)
            $0.textColor = .text100
        }
        
        emptyView.isHidden = true
        
        tableView.do {
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.register(MyRestaurantTableViewCell.self, forCellReuseIdentifier: MyRestaurantTableViewCell.identifier)
        }
    }
    
    // MARK: - Data Binding
    
    private func bindViewModel() {
        // 필터 선택 이벤트 바인딩
        filterView.selectedFilterSubject
            .subscribe(onNext: { [weak self] filterType in
                self?.viewModel.fetchRestaurants(filter: filterType)
            })
            .disposed(by: disposeBag)
        
        // 레스토랑 데이터 바인딩
        viewModel.restaurantsRelay
            .subscribe(onNext: { [weak self] restaurants in
                self?.tableView.reloadData()
                self?.updateEmptyView(isEmpty: restaurants.isEmpty)
            })
            .disposed(by: disposeBag)
        
        // 테이블뷰 델리게이트 & 데이터소스 설정
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.restaurantsRelay
            .bind(to: tableView.rx.items(cellIdentifier: MyRestaurantTableViewCell.identifier, cellType: MyRestaurantTableViewCell.self)) { [weak self] index, restaurant, cell in
                guard let self = self else { return }
                cell.configure(with: restaurant)
                
                // 셀 선택 시 상세 페이지로 이동
//                cell.rx.tapGesture()
//                    .when(.recognized)
//                    .subscribe(onNext: { _ in
//                        self.navigateToDetailView(with: restaurant)
//                    })
//                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helper Methods
    
    private func updateEmptyView(isEmpty: Bool) {
        emptyView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    private func navigateToDetailView(with restaurant: RestaurantTable) {
        
        let detailVC = DetailViewController(viewModel: DetailViewModel(restaurantInfo: Restaurant.mappingRestaurant(restaurant)))
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension MyRestaurantViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - 빈 화면 표시용 뷰

final class EmptyRestaurantView: UIView {
    
    // MARK: - UI Components
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        addSubviews(
            imageView,
            titleLabel,
            descriptionLabel
        )
        
        imageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 80, height: 80))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        imageView.do {
            $0.image = UIImage(systemName: "fork.knife")
            $0.tintColor = .bg300
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.text = "저장된 식당이 없습니다"
            $0.font = .seongiFont(.title_bold_16)
            $0.textColor = .text100
        }
        
        descriptionLabel.do {
            $0.text = "식당을 방문하거나 즐겨찾기에 추가해보세요"
            $0.font = .seongiFont(.body_regular_14)
            $0.textColor = .text200
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
    }
} 
