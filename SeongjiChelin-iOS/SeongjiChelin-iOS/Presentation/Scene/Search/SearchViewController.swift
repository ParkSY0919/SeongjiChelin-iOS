//
//  SearchViewController.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/20/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class SearchViewController: BaseViewController {

    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()
    
    private let customNavBar = UIView()
    private let textFieldContainer = UIView()
    private let navBackBtn = UIButton()
    private let navTextField = UITextField()
    private let searchResultTableView = UITableView()
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    deinit {
        print("SearchViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func setHierarchy() {
        view.addSubviews(customNavBar, searchResultTableView)
        
        customNavBar.addSubviews(navBackBtn,
                                 textFieldContainer)
        
        textFieldContainer.addSubview(navTextField)
    }
    
    override func setLayout() {
        customNavBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalToSuperview().multipliedBy(0.06)
        }
        
        navBackBtn.snp.makeConstraints {
            $0.leading.height.equalToSuperview()
            $0.width.equalTo(navBackBtn.snp.height)
        }
        
        textFieldContainer.snp.makeConstraints {
            $0.leading.equalTo(navBackBtn.snp.trailing)
            $0.trailing.equalToSuperview().inset(40)
            $0.height.equalToSuperview()
        }
        
        navTextField.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        searchResultTableView.snp.makeConstraints {
            $0.top.equalTo(customNavBar.snp.bottom).offset(20)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        
    }
    
    override func setStyle() {
        view.backgroundColor = .white
        
        navBackBtn.do {
            $0.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            $0.tintColor = .primary200
            $0.contentMode = .scaleAspectFill
        }
        
        textFieldContainer.do {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.accentPink.cgColor
            $0.layer.cornerRadius = 8
        }
        
        navTextField.do {
            $0.placeholder = "식당, 주소 등을 입력해주세요."
            $0.font = .seongiFont(.body_regular_14)
            $0.textColor = .text200
            $0.textAlignment = .left
            $0.borderStyle = .none
            $0.clearButtonMode = .whileEditing
        }
        
        searchResultTableView.do {
            $0.backgroundColor = .accentBeige
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.rowHeight = 120
            $0.register(MyRestaurantTableViewCell.self, forCellReuseIdentifier: MyRestaurantTableViewCell.identifier)
        }
    }
    
    
}

private extension SearchViewController {
    
    func bind() {
        let input = SearchViewModel.Input(
            in_TapNavBackButton: navBackBtn.rx.tap,
            in_TapNavTextFieldReturnKey: navTextField.rx.controlEvent(.editingDidEndOnExit),
            in_NavTextFieldText: navTextField.rx.text.orEmpty
        )
        
        let output = viewModel.transform(input: input)
        
        output.out_TapNavBackButton
            .drive(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
    
    func setScrollToTop() {
        print(#function)
        let indexPath = NSIndexPath(row: NSNotFound, section: 0)
//        searchResultTableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
    }
    
}
