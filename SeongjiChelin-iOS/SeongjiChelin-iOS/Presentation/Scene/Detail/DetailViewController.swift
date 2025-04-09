//
//  DetailViewController.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/6/25.
//

import UIKit

import RxCocoa
import RxSwift
import RxCombine
import SnapKit
import Then
import YouTubePlayerKit

final class DetailViewController: BaseViewController {
    
    private let scheduleView = WeeklyScheduleView()
    
    private var isNoYoutube: Bool = false
    private let disposeBag = DisposeBag()
    private let viewModel: DetailViewModel
    
    private let dismissButton = UIButton()
    private let favoriteButton = SJFavoriteButton(cornerRadius: 35/2)
    private let storeNameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let addressToolLabel = SJStoreInfoBaseLabelView(type: .address)
    private let storeAddressLabel = UILabel()
    private let numberToolLabel = SJStoreInfoBaseLabelView(type: .number)
    private let storeNumberLabel = UILabel()
    
    private let parkingToolLabel = SJStoreInfoBaseLabelView(type: .parking)
    private let parkingLabel = UILabel()
    
    private let openingHoursToolLabel = SJStoreInfoBaseLabelView(type: .time)
    private let openingHoursLabel = UILabel()
    
    private let nearWeatherLabel = UILabel()
    private let nearWeatherImageView = UIImageView()
    private let youtubePlayerContainer = UIView()
    
    private lazy var playerViewController = YouTubePlayerViewController(player: viewModel.youtubePlayer)
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSheet()
        bind()
    }
    
    override func setHierarchy() {
        view.addSubviews(
            dismissButton,
            favoriteButton,
            storeNameLabel,
            categoryLabel,
            addressToolLabel,
            storeAddressLabel,
            numberToolLabel,
            storeNumberLabel,
            parkingToolLabel,
            parkingLabel,
            openingHoursToolLabel,
            openingHoursLabel,
            nearWeatherLabel,
            nearWeatherImageView,
            youtubePlayerContainer,
            scheduleView
        )
    }
    
    override func setLayout() {
        dismissButton.snp.makeConstraints {
            $0.centerY.equalTo(favoriteButton.snp.centerY)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.size.equalTo(36)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.bottom.equalTo(storeNameLabel.snp.bottom)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.size.equalTo(36)
        }
        
        storeNameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.trailing.lessThanOrEqualTo(favoriteButton.snp.leading)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.bottom.equalTo(storeNameLabel.snp.bottom)
            $0.leading.equalTo(storeNameLabel.snp.trailing).offset(10)
        }
        
        addressToolLabel.snp.makeConstraints {
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(30)
            $0.leading.equalTo(storeNameLabel.snp.leading)
        }
        
        storeAddressLabel.snp.makeConstraints {
            $0.top.equalTo(addressToolLabel.snp.top).offset(2)
            $0.leading.equalTo(addressToolLabel.snp.trailing)
            $0.trailing.equalTo(favoriteButton.snp.trailing)
        }
        
        numberToolLabel.snp.makeConstraints {
            //주소가 길어지면 길어진 label에 맞춰야 하기에
            $0.top.equalTo(storeAddressLabel.snp.bottom).offset(10)
            $0.leading.equalTo(addressToolLabel.snp.leading)
        }
        
        storeNumberLabel.snp.makeConstraints {
            $0.top.equalTo(numberToolLabel.snp.top).offset(2)
            $0.leading.equalTo(numberToolLabel.snp.trailing)
        }
        
        parkingToolLabel.snp.makeConstraints {
            $0.top.equalTo(storeNumberLabel.snp.bottom).offset(10)
            $0.leading.equalTo(addressToolLabel.snp.leading)
        }
        
        parkingLabel.snp.makeConstraints {
            $0.top.equalTo(parkingToolLabel.snp.top).offset(2)
            $0.leading.equalTo(parkingToolLabel.snp.trailing)
        }
        
        openingHoursToolLabel.snp.makeConstraints {
            $0.top.equalTo(parkingLabel.snp.bottom).offset(10)
            $0.leading.equalTo(addressToolLabel.snp.leading)
        }
        
        openingHoursLabel.snp.makeConstraints {
            $0.top.equalTo(openingHoursToolLabel.snp.top).offset(2)
            $0.leading.equalTo(openingHoursToolLabel.snp.trailing)
            $0.trailing.equalTo(favoriteButton.snp.trailing)
        }
        
        scheduleView.snp.makeConstraints {
            $0.top.equalTo(openingHoursLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(120)
        }
        
        addChild(playerViewController)
        
        youtubePlayerContainer.addSubviews(loadingIndicator, playerViewController.view)
        
//        youtubePlayerContainer.snp.makeConstraints {
//            $0.top.equalTo(openingHoursLabel.snp.bottom).offset(12)
//            $0.horizontalEdges.equalToSuperview().inset(24)
//            $0.height.equalTo(youtubePlayerContainer.snp.width).multipliedBy(9.0/16.0)
//        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        playerViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        playerViewController.didMove(toParent: self)
    }
    
    override func setStyle() {
        view.backgroundColor = .bg100
        
        dismissButton.do {
            $0.setImage(UIImage(systemName: "xmark"), for: .normal)
            $0.tintColor = .text100
            $0.backgroundColor = .bg200
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = 35/2
        }
        
        youtubePlayerContainer.do {
            $0.backgroundColor = .bg200
            $0.isHidden = true
        }
        
        loadingIndicator.do {
            $0.hidesWhenStopped = true // 멈추면 자동으로 숨김
            $0.color = .primary300
        }
        
        storeNumberLabel.do {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(handleStoreInfoLabelTap))
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(gesture)
        }
        
        storeNameLabel.setLabelUI("", font: .seongiFont(.title_bold_20), textColor: .primary200)
        storeNumberLabel.setLabelUI("", font: .seongiFont(.body_bold_12), textColor: .marker4)
        
        [categoryLabel, storeAddressLabel, parkingLabel, openingHoursLabel, nearWeatherLabel].forEach { i in
            i.setLabelUI(
                "",
                font: .seongiFont(.body_bold_12),
                textColor: .accentPink,
                numberOfLines: 3
            )
        }
        
        let openTimes = ["11:10", "11:20", "11:30", "11:40", "11:50", "11:40", "10:40"]
        let closeTimes = ["22:00", "22:00", "22:00", "22:00", "22:00", "22:00", "20:00"]
        scheduleView.updateSchedule(openTimes: openTimes, closeTimes: closeTimes, holidayIndex: 4)
    }
    
    /// restaurant 정보 업데이트
    func updateRestaurantInfo(_ restaurant: Restaurant) {
        viewModel.updateRestaurantInfo(restaurant)
    }
    
    //TODO: 추후 각 데이터 바인딩 수정
    private func configureDetailView(restaurant: Restaurant) {
//        let isYoutubeIdNil = restaurant.youtubeId == nil
//           isNoYoutube = isYoutubeIdNil
//           openingHoursToolLabel.isNoYoutube(isValid: isYoutubeIdNil)
        
        storeNameLabel.text = restaurant.name
        categoryLabel.text = restaurant.category
        storeAddressLabel.text = restaurant.address
        storeNumberLabel.text = restaurant.number
        parkingLabel.text = restaurant.amenities
        
        openingHoursLabel.do {
            let status = restaurant.checkStoreStatus()
            $0.text = status.displayText
            $0.textColor = status.textColor
        }
        
        //메뉴관련
        //openingHoursLabel.text = restaurant.menus.map(\.self).joined(separator: ", ")
        
        
        
        nearWeatherLabel.text = "🌡️ 현재 근처 날씨: " + "맑음"
        
        if let sheet = self.sheetPresentationController {
            let isCustomSmall = sheet.selectedDetentIdentifier == .customSmall
            switchLayout(isCustomSmall: isCustomSmall)
        }
    }
    
//    private func updateStoreStatus(_ restaurant: Restaurant) {
//        let status = restaurant.checkStoreStatus()
//        openingHoursLabel.text = status.displayText
//        openingHoursLabel.textColor = status.textColor
//        
//        // 상태에 따라 배경색 변경 (선택사항)
//        switch status {
//        case .open:
//            openingHoursLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
//        case .closed, .holidayClosed:
//            openingHoursLabel.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
//        }
//    }
    
    @objc
    private func handleStoreInfoLabelTap(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }
        guard let phoneNumber = storeNumberLabel.text else { return }
        if storeNumberLabel.text == "등록된 연락처가 없습니다." { return }
        
        
        if phoneNumber != "등록된 연락처가 없습니다." && !phoneNumber.isEmpty {
            makePhoneCall(phoneNumber: phoneNumber)
        } else {
            print("전화번호 정보가 없거나 유효하지 않습니다.")
            let alert = UIAlertManager.shared.showAlert(title: "통화 연결 실패", message: "연락처 정보가 없습니다.")
            present(alert, animated: true)
        }
    }
    
    private func makePhoneCall(phoneNumber: String) {
        let cleanedPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        guard let phoneUrl = URL(string: "telprompt://\(cleanedPhoneNumber)") else {
            print("🚨 유효하지 않은 전화번호 URL 형식입니다.")
            
            let alert = UIAlertManager.shared.showAlert(title: "통화 연결 실패", message: "전화번호 형식이 올바르지 않습니다.")
            present(alert, animated: true)
            return
        }
        
        if UIApplication.shared.canOpenURL(phoneUrl) {
            UIApplication.shared.open(phoneUrl, options: [:], completionHandler: nil)
        } else {
            print("🚨 전화를 걸 수 없습니다. (기기 또는 번호 문제)")
            let alert = UIAlertManager.shared.showAlert(title: "통화 연결 실패", message: "이 기기에서는 전화를 걸 수 없거나 번호에 문제가 있습니다.")
            present(alert, animated: true)
        }
    }
    
}

extension DetailViewController {
    
    private func setSheet() {
        if let sheet = self.sheetPresentationController {
            let smallDetent = UISheetPresentationController.Detent.custom(identifier: .customSmall) { context in
                return context.maximumDetentValue * 0.45
            }
            sheet.selectedDetentIdentifier = .customSmall
            sheet.largestUndimmedDetentIdentifier = .customSmall
            sheet.detents = [smallDetent, .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
            sheet.delegate = self
        }
    }
    
    private func bind() {
        let input = DetailViewModel.Input(dismissTapped: dismissButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.dismissTrigger
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }.disposed(by: disposeBag)
        
        output.restaurantInfo
            .drive(with: self) { owner, restaurant in
                owner.isNoYoutube = restaurant.youtubeId == nil
                owner.configureDetailView(restaurant: restaurant)
            }.disposed(by: disposeBag)
        
        output.youtubeInfo
            .drive(with: self) { owner, videoId in
                if let videoId {
                    Task {
                        do {
                            try await owner.playerViewController.player.load(source: .video(id: videoId))
                        } catch {
                            print("비디오 로드 실패: \(error)")
                        }
                    }
                }
            }.disposed(by: disposeBag)
        
        let stateObservable: Observable<YouTubePlayer.State> = viewModel.youtubePlayer.statePublisher.asObservable()
        
        stateObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                print("Player state changed (Rx): \(state)")
                switch state {
                case .idle:
                    print("로딩 중")
                    self.loadingIndicator.startAnimating()
                    self.playerViewController.view.isHidden = true
                case .ready:
                    print("준비 완료")
                    self.loadingIndicator.stopAnimating()
                    self.playerViewController.view.isHidden = false
                case .error(let error):
                    print("Player error (Rx): \(error)")
                    self.loadingIndicator.stopAnimating()
                    self.playerViewController.view.isHidden = false
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func switchLayout(isCustomSmall: Bool) {
        print("isCustomSmall: \(isCustomSmall)")
        // 두 조건에 따라 유튜브컨테이너 등 표시 여부 결정
        let shouldHideContainer = isNoYoutube || isCustomSmall
        youtubePlayerContainer.isHidden = shouldHideContainer
        dismissButton.isHidden = shouldHideContainer
        
        if shouldHideContainer {
            favoriteButton.snp.remakeConstraints {
                $0.bottom.equalTo(storeNameLabel.snp.bottom)
                $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
                $0.size.equalTo(36)
            }
            
            youtubePlayerContainer.snp.remakeConstraints {
                $0.top.equalTo(openingHoursLabel.snp.bottom).offset(12)
                $0.horizontalEdges.equalToSuperview().inset(24)
                $0.height.equalTo(0)
            }
        } else {
            favoriteButton.snp.remakeConstraints {
                $0.bottom.equalTo(storeNameLabel.snp.bottom)
                $0.trailing.equalTo(dismissButton.snp.leading).offset(-10)
                $0.size.equalTo(36)
            }
            
            youtubePlayerContainer.snp.remakeConstraints {
                $0.top.equalTo(openingHoursLabel.snp.bottom).offset(12)
                $0.horizontalEdges.equalToSuperview().inset(24)
                $0.height.equalTo(youtubePlayerContainer.snp.width).multipliedBy(9.0/16.0)
            }
        }
        
        // 레이아웃 업데이트 강제 with 애니메이션
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
}

extension DetailViewController: UISheetPresentationControllerDelegate {
    
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        let isCustomSmall = sheetPresentationController.selectedDetentIdentifier == .customSmall
        switchLayout(isCustomSmall: isCustomSmall)
    }
    
}

extension UISheetPresentationController.Detent.Identifier {
    
    static let customSmall = UISheetPresentationController.Detent.Identifier("customSmall")
    
}


final class WeeklyScheduleView: UIView {
    
    //헤더 (요일) 레이블
    private let weekdayLabels: [UILabel] = {
        let days = ["월", "화", "수", "목", "금", "토", "일"]
        return days.map { day in
            return UILabel().then {
                $0.text = day
                $0.textAlignment = .center
                $0.font = .seongiFont(.body_bold_14)
                $0.textColor = .primary200
            }
        }
    }()
    
    //영업 시작 시간 레이블
    private let openTimeLabels: [UILabel] = {
        return (0..<7).map { index in
            return UILabel().then {
                $0.text = "11:50"
                $0.textAlignment = .center
                $0.font = .seongiFont(.body_regular_12)
                $0.textColor = .accentPink
            }
        }
    }()
    
    //영업 종료 시간 레이블
    private let closeTimeLabels: [UILabel] = {
        return (0..<7).map { _ in
            return UILabel().then {
                $0.text = "22:00"
                $0.textAlignment = .center
                $0.font = .seongiFont(.body_regular_12)
                $0.textColor = .accentPink
            }
        }
    }()
    
    // 정기 휴무일 레이블
    private let regularLabel = UILabel()
    // 휴무일 레이블
    private let sundayLabel = UILabel()
    private let dividerLine = UIView()
    
//    private let holidayIndex
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setHierarchy() {
        //구분선 추가
        addSubviews(dividerLine, regularLabel, sundayLabel)
        
        //요일 레이블 추가
        weekdayLabels.forEach { addSubview($0) }
        
        //영업 시작 시간 레이블 추가
        openTimeLabels.forEach { addSubview($0) }
        
        //영업 종료 시간 레이블 추가
        closeTimeLabels.forEach { addSubview($0) }
    }
    
    private func setLayout() {
        //요일 레이블 레이아웃
        for (index, label) in weekdayLabels.enumerated() {
            label.snp.makeConstraints {
                $0.top.equalToSuperview().offset(16)
                $0.width.equalToSuperview().dividedBy(7)
                $0.height.equalTo(20)
                
                if index == 0 {
                    $0.leading.equalToSuperview()
                } else {
                    $0.leading.equalTo(weekdayLabels[index-1].snp.trailing)
                }
            }
        }
        
        //구분선 레이아웃
        dividerLine.snp.makeConstraints {
            $0.top.equalTo(weekdayLabels[0].snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.height.equalTo(1)
        }
        
        //영업 시작 시간 레이블 레이아웃
        for (index, label) in openTimeLabels.enumerated() {
            label.snp.makeConstraints {
                $0.top.equalTo(dividerLine.snp.bottom).offset(12)
                $0.width.equalToSuperview().dividedBy(7)
                $0.height.equalTo(20)
                
                if index == 0 {
                    $0.leading.equalToSuperview()
                } else {
                    $0.leading.equalTo(openTimeLabels[index-1].snp.trailing)
                }
            }
        }
        
        //영업 종료 시간 레이블 레이아웃
        for (index, label) in closeTimeLabels.enumerated() {
            label.snp.makeConstraints {
                $0.top.equalTo(openTimeLabels[0].snp.bottom).offset(8)
                $0.width.equalToSuperview().dividedBy(7)
                $0.height.equalTo(20)
                
                if index == 0 {
                    $0.leading.equalToSuperview()
                } else {
                    $0.leading.equalTo(closeTimeLabels[index-1].snp.trailing)
                }
            }
        }
        
        regularLabel.snp.makeConstraints {
            $0.top.equalTo(dividerLine.snp.bottom).offset(12)
            $0.width.equalToSuperview().dividedBy(7)
            $0.height.equalTo(20)
            $0.leading.equalTo(openTimeLabels[6].snp.leading)
        }
        
        sundayLabel.snp.makeConstraints {
            $0.top.equalTo(regularLabel.snp.bottom).offset(8)
            $0.width.equalToSuperview().dividedBy(7)
            $0.height.equalTo(20)
            $0.leading.equalTo(regularLabel.snp.leading)
        }
    }
    
    private func setStyle() {
        self.do {
            $0.backgroundColor = .bg100
            $0.layer.cornerRadius = 12
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.bg200.cgColor
        }
        
        regularLabel.setLabelUI(
            "정기",
            font: .seongiFont(.body_bold_12),
            textColor: .primary300,
            alignment: .center
        )
        
        sundayLabel.setLabelUI(
            "휴무",
            font: .seongiFont(.body_bold_12),
            textColor: .primary300,
            alignment: .center
        )
        
        dividerLine.backgroundColor = .bg200
    }
    
    
    //영업시간 정보 업데이트 메서드
    func updateSchedule(openTimes: [String], closeTimes: [String], holidayIndex: Int) {
        // 기존 레이아웃 제약조건 제거
        regularLabel.snp.removeConstraints()
        
        // 새로운 위치에 정기 휴무일 레이블 배치
        regularLabel.snp.makeConstraints {
            $0.top.equalTo(dividerLine.snp.bottom).offset(12)
            $0.width.equalToSuperview().dividedBy(7)
            $0.height.equalTo(20)
            $0.leading.equalTo(openTimeLabels[holidayIndex].snp.leading)
        }
        
        // 일요일 레이블 위치도 업데이트
        sundayLabel.snp.removeConstraints()
        sundayLabel.snp.makeConstraints {
            $0.top.equalTo(regularLabel.snp.bottom).offset(8)
            $0.width.equalToSuperview().dividedBy(7)
            $0.height.equalTo(20)
            $0.leading.equalTo(regularLabel.snp.leading)
        }
        
        // 모든 레이블 보이게 초기화
        for i in 0..<openTimeLabels.count {
            openTimeLabels[i].isHidden = false
            closeTimeLabels[i].isHidden = false
        }
        
        // 휴무일 레이블 숨기기
        if holidayIndex >= 0 && holidayIndex < openTimeLabels.count {
            openTimeLabels[holidayIndex].isHidden = true
            closeTimeLabels[holidayIndex].isHidden = true
        }
        
        // 영업 시작 시간 업데이트
        for (index, label) in openTimeLabels.enumerated() {
            if index < openTimes.count && index != holidayIndex {
                label.text = openTimes[index]
            }
        }
        
        // 영업 종료 시간 업데이트
        for (index, label) in closeTimeLabels.enumerated() {
            if index < closeTimes.count && index != holidayIndex {
                label.text = closeTimes[index]
            }
        }
        
        // 레이아웃 즉시 업데이트
        self.layoutIfNeeded()
    }
    
}
