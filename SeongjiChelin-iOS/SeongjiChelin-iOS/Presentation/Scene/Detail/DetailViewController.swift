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
    
    private let scheduleView = SJWeeklyScheduleView()
    
    var onChangeState: (() -> ())?
    var onDismiss: (() -> ())?
    private var isNoYoutube: Bool = false
    private let disposeBag = DisposeBag()
    private let viewModel: DetailViewModel
    
    private let dismissButton = UIButton()
    private let visitButton = SJButton(type: .foot, repo: RestaurantRepository())
    private let favoriteButton = SJButton(type: .favorite, repo: RestaurantRepository())
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
    
    private let menusToolLabel = SJStoreInfoBaseLabelView(type: .video)
    private let menusLabel = UILabel()
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let sheet = self.sheetPresentationController {
            let isCustomSmall = sheet.selectedDetentIdentifier == .medium
            switchLayout(isCustomSmall: isCustomSmall)
        }
    }
    
    override func setHierarchy() {
        view.addSubviews(
            dismissButton,
            visitButton,
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
            menusToolLabel,
            menusLabel,
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
            $0.size.equalTo(favoriteButton.snp.size)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.size.equalTo(36)
        }
        
        visitButton.snp.makeConstraints {
            $0.centerY.equalTo(favoriteButton.snp.centerY)
            $0.trailing.equalTo(favoriteButton.snp.leading).offset(-10)
            $0.size.equalTo(favoriteButton.snp.size)
        }
        
        storeNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(favoriteButton.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        categoryLabel.snp.makeConstraints {
            $0.bottom.equalTo(storeNameLabel.snp.bottom)
            $0.leading.equalTo(storeNameLabel.snp.trailing).offset(10)
            $0.trailing.lessThanOrEqualTo(visitButton.snp.leading).offset(-10)
            $0.width.greaterThanOrEqualTo(30).priority(.required)
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
        
        menusToolLabel.snp.makeConstraints {
            $0.top.equalTo(scheduleView.snp.bottom).offset(20)
            $0.leading.equalTo(addressToolLabel.snp.leading)
        }
        
        menusLabel.snp.makeConstraints {
            $0.top.equalTo(menusToolLabel.snp.top).offset(4)
            $0.leading.equalTo(menusToolLabel.snp.trailing)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        addChild(playerViewController)
        
        youtubePlayerContainer.addSubviews(loadingIndicator, playerViewController.view)
        
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
            $0.setImage(ImageLiterals.xmark, for: .normal)
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
        
        [categoryLabel, storeAddressLabel, parkingLabel, openingHoursLabel, menusLabel].forEach { i in
            i.setLabelUI(
                "",
                font: .seongiFont(.body_bold_12),
                textColor: .accentPink,
                numberOfLines: 3
            )
        }
        
    }
    
    /// restaurant 정보 업데이트
    func updateRestaurantInfo(_ restaurant: Restaurant) {
        viewModel.updateRestaurantInfo(restaurant)
    }
    
    //TODO: 추후 각 데이터 바인딩 수정
    private func configureDetailView(restaurant: Restaurant) {
        let isYoutubeIdNil = restaurant.youtubeId == nil
        isNoYoutube = isYoutubeIdNil
        menusToolLabel.isNoYoutube(isValid: isYoutubeIdNil)
        
        storeNameLabel.text = restaurant.name
        categoryLabel.text = restaurant.category
        storeAddressLabel.text = restaurant.address
        storeNumberLabel.text = restaurant.number
        parkingLabel.text = restaurant.amenities
        menusLabel.text = restaurant.menus.map(\.self).joined(separator: ", ")
        
        openingHoursLabel.do {
            let status = restaurant.checkStoreStatus()
            $0.text = status.displayText
            $0.textColor = status.textColor
        }
        
        visitButton.configureWithRestaurant(restaurant: restaurant)
        favoriteButton.configureWithRestaurant(restaurant: restaurant)
        
        let holidyIndes = CustomFormatterManager.shared.weekdayString(from: restaurant.closedDays) ?? -1
        print("holidyIndes: \(holidyIndes)")
        scheduleView.updateSchedule(businessHours: restaurant.businessHours, holidayIndex: holidyIndes-1)
        
        nearWeatherLabel.text = "🌡️ 현재 근처 날씨: " + "맑음"
        
        if let sheet = self.sheetPresentationController {
            let isCustomSmall = sheet.selectedDetentIdentifier == .medium
            switchLayout(isCustomSmall: isCustomSmall)
        }
    }
    
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
            sheet.selectedDetentIdentifier = .medium
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
            sheet.delegate = self
        }
    }
    
    private func bind() {
        let input = DetailViewModel.Input(dismissTapped: dismissButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        [favoriteButton, visitButton].forEach { [weak self] i in
            i.onChangeState = {
                self?.onChangeState?()
            }
        }
        
        output.dismissTrigger
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }.disposed(by: disposeBag)
        
        output.restaurantInfo
            .drive(with: self) { owner, restaurant in
                owner.configureDetailView(restaurant: restaurant)
            }.disposed(by: disposeBag)
        
        output.youtubeInfo
            .drive(with: self) { owner, videoId in
                if let videoId, !videoId.isEmpty {
                    Task {
                        do {
                            try await owner.playerViewController.player.load(source: .video(id: videoId))
                            try await owner.playerViewController.player.pause()
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
        
        [dismissButton, menusToolLabel, menusLabel].forEach { i in
            i.isHidden = isCustomSmall
        }
        youtubePlayerContainer.isHidden = isCustomSmall || isNoYoutube
        
        
        if isCustomSmall {
            favoriteButton.snp.remakeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
                $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
                $0.size.equalTo(36)
            }
            
            storeNameLabel.snp.remakeConstraints {
                $0.bottom.equalTo(favoriteButton.snp.bottom)
                $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            }

            categoryLabel.snp.remakeConstraints {
                $0.bottom.equalTo(storeNameLabel.snp.bottom)
                $0.leading.equalTo(storeNameLabel.snp.trailing).offset(10)
                $0.trailing.lessThanOrEqualTo(visitButton.snp.leading).offset(-10)
                $0.width.greaterThanOrEqualTo(30).priority(.required)
            }
            
            youtubePlayerContainer.snp.remakeConstraints {
                $0.top.equalTo(menusLabel.snp.bottom).offset(20)
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.height.equalTo(0)
            }
        } else {
            favoriteButton.snp.remakeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
                $0.trailing.equalTo(dismissButton.snp.leading).offset(-10)
                $0.size.equalTo(36)
            }
            
            storeNameLabel.snp.remakeConstraints {
                $0.top.equalTo(favoriteButton.snp.bottom).offset(14)
                $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            }

            categoryLabel.snp.remakeConstraints {
                $0.bottom.equalTo(storeNameLabel.snp.bottom)
                $0.leading.equalTo(storeNameLabel.snp.trailing).offset(10)
                $0.trailing.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(20)
                $0.width.greaterThanOrEqualTo(30).priority(.required)
            }
            
            if !isNoYoutube {
                youtubePlayerContainer.snp.remakeConstraints {
                    $0.top.equalTo(menusLabel.snp.bottom).offset(10)
                    $0.horizontalEdges.equalToSuperview().inset(20)
                    $0.height.equalTo(youtubePlayerContainer.snp.width).multipliedBy(9.0/16.0)
                }
            }
        }
    }
    
}

extension DetailViewController: UISheetPresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("DetailViewController dismissed.")
        onDismiss?()
    }
    
}
