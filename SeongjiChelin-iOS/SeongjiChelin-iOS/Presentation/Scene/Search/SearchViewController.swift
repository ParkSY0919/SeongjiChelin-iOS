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
    private lazy var searchResultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: setupCollectionView())
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navTextField.becomeFirstResponder()
    }
    
    override func setHierarchy() {
        view.addSubviews(customNavBar, searchResultCollectionView)
        
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
        
        searchResultCollectionView.snp.makeConstraints {
            $0.top.equalTo(customNavBar.snp.bottom).offset(20)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
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
        
        searchResultCollectionView.do {
            $0.showsVerticalScrollIndicator = false
            $0.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        }
    }
    
}

private extension SearchViewController {
    
    func bind() {
        let input = SearchViewModel.Input(
            navBackButtonTapped: navBackBtn.rx.tap,
            returnKeyTapped: navTextField.rx.controlEvent(.editingDidEndOnExit),
            searchTextFieldText: navTextField.rx.text.orEmpty
        )
        
        let output = viewModel.transform(input: input)
        
        output.navBackButtonTrigger
            .drive(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        output.returnKeyTrigger
            .drive(with: self) { owner, _ in
                owner.navTextField.resignFirstResponder()
            }.disposed(by: disposeBag)
        
        output.filterRestaurantList
            .drive(searchResultCollectionView.rx.items(cellIdentifier: HomeCollectionViewCell.identifier, cellType: HomeCollectionViewCell.self))
        { item, data, cell in
            cell.configureCell(store: data)
        }.disposed(by: disposeBag)
        
        output.scrollTopTrigger
            .bind(with: self) { owner, _ in
                owner.setScrollToTop()
            }.disposed(by: disposeBag)
    }
    
    func setScrollToTop() {
        print(#function)
        let indexPath = NSIndexPath(row: NSNotFound, section: 0)
        searchResultCollectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
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
    
}
