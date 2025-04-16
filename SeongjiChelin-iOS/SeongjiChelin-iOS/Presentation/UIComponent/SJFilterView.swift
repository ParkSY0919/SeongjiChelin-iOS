//
//  SJFilterView.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/12/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then
import RealmSwift

enum SJFilterType {
    case all
    case visited
    case favorite
    case rated
    
    var title: String {
        switch self {
        case .all:
            return "전체"
        case .visited:
            return "방문한 곳"
        case .favorite:
            return "저장한 곳"
        case .rated:
            return "리뷰남긴 곳"
        }
    }
    
    var icon: UIImage? {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10)
        
        switch self {
        case .all:
            return UIImage(systemName: "list.bullet")?.withConfiguration(symbolConfig)
        case .visited:
            return UIImage(resource: .footFill).withRenderingMode(.alwaysTemplate)
        case .favorite:
            return UIImage(systemName: "bookmark.fill")?.withConfiguration(symbolConfig)
        case .rated:
            return UIImage(systemName: "star.fill")?.withConfiguration(symbolConfig)
        }
    }
}

final class SJFilterView: UIView {
    
    private let disposeBag = DisposeBag()
    let selectedFilterSubject = PublishSubject<SJFilterType>()
    
    private let scrollView = UIScrollView()
    private let filterStackView = UIStackView()
    private let filterButtons: [UIButton]
    private var currentSelectedButton: UIButton?
    
    init() {
        let filterTypes: [SJFilterType] = [.all, .visited, .favorite, .rated]
        
        
        self.filterButtons = filterTypes.map { type in
            let button = UIButton(type: .system)
            
            var config = UIButton.Configuration.bordered()
            config.image = type.icon
            config.title = type.title
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.seongiFont(.body_bold_12)
                outgoing.foregroundColor = .text100
                return outgoing
            }
            config.baseForegroundColor = .primary100
            config.imagePadding = 3
            config.cornerStyle = .capsule
            button.configuration = config

            
            let handler: UIButton.ConfigurationUpdateHandler = { button in
                switch button.state {
                    
                case .normal:
                    button.configuration?.baseForegroundColor = .bg300
                    button.configuration?.background.backgroundColor = .bg100
                case .selected:
                    button.configuration?.baseForegroundColor = .bg100
                    button.configuration?.background.backgroundColor = .primary200
                default:
                    return
                }
            }
            button.configurationUpdateHandler = handler
            button.contentMode = .scaleAspectFit
            
            button.tag = filterTypes.firstIndex(of: type) ?? 0
            return button
        }
        
        super.init(frame: .zero)
        configureUI()
        setUpBindings()
        
        // 기본 선택은 '전체'
        selectFilter(type: .all)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews(scrollView)
        scrollView.addSubview(filterStackView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        filterStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.do {
            $0.showsHorizontalScrollIndicator = false
        }
        
        filterStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fillProportionally
            $0.alignment = .leading
        }
        
        filterButtons.forEach { filterStackView.addArrangedSubview($0) }
        
    }
    
    private func setUpBindings() {
        for (index, button) in filterButtons.enumerated() {
            button.rx.tap
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    
                    let filterType = self.getFilterType(tag: index)
                    self.selectFilter(type: filterType)
                    self.selectedFilterSubject.onNext(filterType)
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func getFilterType(tag: Int) -> SJFilterType {
        switch tag {
        case 0: return .all
        case 1: return .visited
        case 2: return .favorite
        case 3: return .rated
        default: return .all
        }
    }
    
    private func selectFilter(type: SJFilterType) {
        // 모든 버튼 비활성화
        filterButtons.forEach { button in
            button.isSelected = false
        }
        
        // 선택된 버튼 활성화
        if let index = [.all, .visited, .favorite, .rated].firstIndex(of: type),
           index < filterButtons.count {
            let selectedButton = filterButtons[index]
            selectedButton.isSelected = true
            currentSelectedButton = selectedButton
        }
    }
    
}
