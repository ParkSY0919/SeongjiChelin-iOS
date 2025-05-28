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
    
    // MARK: - Properties
    private let scheduleView = SJWeeklyScheduleView()
    
    var onChangeState: (() -> Void)?
    var onDismiss: (() -> Void)?
    
    weak var coordinator: Coordinator?
    
    private let disposeBag = DisposeBag()
    private let viewModel: DetailViewModel
    
    // MARK: - UI Components
    private lazy var dismissButton = UIButton().then {
        $0.setImage(ImageLiterals.xmark, for: .normal)
        $0.tintColor = .text100
        $0.backgroundColor = .bg200
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 18
    }
    
    private let visitButton = SJButton(type: .foot, repo: RestaurantRepository())
    private let favoriteButton = SJButton(type: .favorite, repo: RestaurantRepository())
    
    // 식당 정보 표시 UI들 그룹화
    private struct StoreInfoViews {
        let nameLabel = UILabel()
        let categoryLabel = UILabel()
        let addressToolLabel = SJStoreInfoBaseLabelView(type: .address)
        let addressLabel = UILabel()
        let numberToolLabel = SJStoreInfoBaseLabelView(type: .number)
        let numberLabel = UILabel()
        let parkingToolLabel = SJStoreInfoBaseLabelView(type: .parking)
        let parkingLabel = UILabel()
        let openingHoursToolLabel = SJStoreInfoBaseLabelView(type: .time)
        let openingHoursLabel = UILabel()
        let menusToolLabel = SJStoreInfoBaseLabelView(type: .video)
        let menusLabel = UILabel()
        let nearWeatherLabel = UILabel()
        let nearWeatherImageView = UIImageView()
    }
    
    private let storeInfo = StoreInfoViews()
    
    // YouTube 관련 뷰들
    private struct YouTubeViews {
        let container = UIView()
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
    }
    
    private let youtubeViews = YouTubeViews()
    private lazy var playerViewController = YouTubePlayerViewController(player: viewModel.youtubePlayer)
    
    // MARK: - State
    private var currentSheetState: SheetState = .medium {
        didSet {
            guard oldValue != currentSheetState else { return }
            updateLayoutForSheetState()
        }
    }
    
    private enum SheetState {
        case medium, large
    }
    
    // MARK: - Lifecycle
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSheet()
        setupBindings()
        setupYouTubePlayer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSheetState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            onDismiss?()
        }
    }
    
    // MARK: - Setup Methods
    override func setHierarchy() {
        view.addSubviews(
            dismissButton,
            visitButton,
            favoriteButton,
            storeInfo.nameLabel,
            storeInfo.categoryLabel,
            storeInfo.addressToolLabel,
            storeInfo.addressLabel,
            storeInfo.numberToolLabel,
            storeInfo.numberLabel,
            storeInfo.parkingToolLabel,
            storeInfo.parkingLabel,
            storeInfo.openingHoursToolLabel,
            storeInfo.openingHoursLabel,
            storeInfo.menusToolLabel,
            storeInfo.menusLabel,
            storeInfo.nearWeatherLabel,
            storeInfo.nearWeatherImageView,
            youtubeViews.container,
            scheduleView
        )
        
        setupYouTubeHierarchy()
    }
    
    private func setupYouTubeHierarchy() {
        addChild(playerViewController)
        youtubeViews.container.addSubviews(
            youtubeViews.loadingIndicator,
            playerViewController.view
        )
        playerViewController.didMove(toParent: self)
    }
    
    override func setLayout() {
        setupConstraints()
    }
    
    private func setupConstraints() {
        // 기본 버튼 레이아웃
        setupButtonConstraints()
        
        // 스토어 정보 레이아웃
        setupStoreInfoConstraints()
        
        // 스케줄 뷰 레이아웃
        scheduleView.snp.makeConstraints {
            $0.top.equalTo(storeInfo.openingHoursLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(120)
        }
        
        // YouTube 플레이어 레이아웃
        setupYouTubeConstraints()
    }
    
    private func setupButtonConstraints() {
        dismissButton.snp.makeConstraints {
            $0.centerY.equalTo(favoriteButton.snp.centerY)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.size.equalTo(36)
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
    }
    
    private func setupStoreInfoConstraints() {
        // 스토어 이름과 카테고리
        storeInfo.nameLabel.snp.makeConstraints {
            $0.bottom.equalTo(favoriteButton.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        storeInfo.categoryLabel.snp.makeConstraints {
            $0.bottom.equalTo(storeInfo.nameLabel.snp.bottom)
            $0.leading.equalTo(storeInfo.nameLabel.snp.trailing).offset(10)
            $0.trailing.lessThanOrEqualTo(visitButton.snp.leading).offset(-10)
            $0.width.greaterThanOrEqualTo(30).priority(.required)
        }
        
        // 주소 정보
        storeInfo.addressToolLabel.snp.makeConstraints {
            $0.top.equalTo(storeInfo.nameLabel.snp.bottom).offset(30)
            $0.leading.equalTo(storeInfo.nameLabel.snp.leading)
        }
        
        storeInfo.addressLabel.snp.makeConstraints {
            $0.top.equalTo(storeInfo.addressToolLabel.snp.top).offset(2)
            $0.leading.equalTo(storeInfo.addressToolLabel.snp.trailing)
            $0.trailing.equalTo(favoriteButton.snp.trailing)
        }
        
        // 연락처 정보
        storeInfo.numberToolLabel.snp.makeConstraints {
            $0.top.equalTo(storeInfo.addressLabel.snp.bottom).offset(15)
            $0.leading.equalTo(storeInfo.addressToolLabel.snp.leading)
        }
        
        storeInfo.numberLabel.snp.makeConstraints {
            $0.top.equalTo(storeInfo.numberToolLabel.snp.top).offset(2)
            $0.leading.equalTo(storeInfo.numberToolLabel.snp.trailing)
        }
        
        // 주차 정보
        storeInfo.parkingToolLabel.snp.makeConstraints {
            $0.top.equalTo(storeInfo.numberLabel.snp.bottom).offset(15)
            $0.leading.equalTo(storeInfo.addressToolLabel.snp.leading)
        }
        
        storeInfo.parkingLabel.snp.makeConstraints {
            $0.top.equalTo(storeInfo.parkingToolLabel.snp.top).offset(2)
            $0.leading.equalTo(storeInfo.parkingToolLabel.snp.trailing)
        }
        
        // 영업 시간 정보
        storeInfo.openingHoursToolLabel.snp.makeConstraints {
            $0.top.equalTo(storeInfo.parkingLabel.snp.bottom).offset(15)
            $0.leading.equalTo(storeInfo.addressToolLabel.snp.leading)
        }
        
        storeInfo.openingHoursLabel.snp.makeConstraints {
            $0.top.equalTo(storeInfo.openingHoursToolLabel.snp.top).offset(2)
            $0.leading.equalTo(storeInfo.openingHoursToolLabel.snp.trailing)
            $0.trailing.equalTo(favoriteButton.snp.trailing)
        }
    }
    
    private func setupYouTubeConstraints() {
        youtubeViews.loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        playerViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        view.backgroundColor = .bg100
        setupUIStyles()
    }
    
    private func setupUIStyles() {
        // YouTube 컨테이너 스타일
        youtubeViews.container.do {
            $0.backgroundColor = .bg200
            $0.isHidden = true
        }
        
        // 로딩 인디케이터 스타일
        youtubeViews.loadingIndicator.do {
            $0.hidesWhenStopped = true
            $0.color = .primary300
        }
        
        // 전화번호 탭 제스처
        setupPhoneNumberTapGesture()
        
        // 라벨 스타일 설정
        setupLabelStyles()
    }
    
    private func setupPhoneNumberTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handlePhoneNumberTap))
        storeInfo.numberLabel.isUserInteractionEnabled = true
        storeInfo.numberLabel.addGestureRecognizer(gesture)
    }
    
    private func setupLabelStyles() {
        storeInfo.nameLabel.setLabelUI(
            "",
            font: .seongiFont(.title_bold_20),
            textColor: .primary200
        )
        
        storeInfo.numberLabel.setLabelUI(
            "",
            font: .seongiFont(.body_bold_12),
            textColor: .marker4
        )
        
        [
            storeInfo.categoryLabel,
            storeInfo.addressLabel,
            storeInfo.parkingLabel,
            storeInfo.openingHoursLabel,
            storeInfo.menusLabel
        ].forEach {
            $0.setLabelUI(
                "",
                font: .seongiFont(.body_bold_12),
                textColor: .accentPink,
                numberOfLines: 3
            )
        }
    }
    
    // MARK: - Setup Methods
    private func setupSheet() {
        guard let sheet = sheetPresentationController else { return }
        
        if viewModel.restaurantInfo.themeType == .psyTheme {
            print("주인장 테마")
            // 주인장 테마일 때는 medium 고정
            sheet.selectedDetentIdentifier = .medium
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = false
        } else {
            // 일반 테마일 때는 기존 동작
            sheet.selectedDetentIdentifier = .medium
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        sheet.preferredCornerRadius = 20
        sheet.delegate = self
    }
    
    private func setupYouTubePlayer() {
        // YouTube 플레이어 상태 관찰
        viewModel.youtubePlayer.statePublisher.asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                self?.handleYouTubePlayerState(state)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        let input = DetailViewModel.Input(dismissTapped: dismissButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        // 버튼 상태 변경 콜백
        [favoriteButton, visitButton].forEach { button in
            button.onChangeState = { [weak self] in
                self?.onChangeState?()
            }
        }
        
        // ViewModel 출력 바인딩
        bindViewModelOutputs(output)
    }
    
    private func bindViewModelOutputs(_ output: DetailViewModel.Output) {
        output.dismissTrigger
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.restaurantInfo
            .drive(with: self) { owner, restaurant in
                owner.configureDetailView(restaurant: restaurant)
            }
            .disposed(by: disposeBag)
        
        output.youtubeInfo
            .drive(with: self) { owner, videoId in
                owner.handleYouTubeVideoLoad(videoId)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - YouTube Handling
    private func handleYouTubeVideoLoad(_ videoId: String?) {
        guard let videoId = videoId, !videoId.isEmpty else { return }
        
        Task {
            do {
                try await playerViewController.player.load(source: .video(id: videoId))
                try await playerViewController.player.stop()
            } catch {
                print("비디오 로드 실패: \(error)")
            }
        }
    }
    
    private func handleYouTubePlayerState(_ state: YouTubePlayer.State) {
        switch state {
        case .idle:
            youtubeViews.loadingIndicator.startAnimating()
            playerViewController.view.isHidden = true
        case .ready:
            youtubeViews.loadingIndicator.stopAnimating()
            playerViewController.view.isHidden = false
        case .error(let error):
            print("YouTube Player error: \(error)")
            youtubeViews.loadingIndicator.stopAnimating()
            playerViewController.view.isHidden = false
        }
    }
    
    // MARK: - Restaurant Info Configuration
    func updateRestaurantInfo(_ restaurant: Restaurant) {
        viewModel.updateRestaurantInfo(restaurant)
    }
    
    private func configureDetailView(restaurant: Restaurant) {
        configureBasicInfo(restaurant)
        configureBusinessHours(restaurant)
        configureButtons(restaurant)
        configureYouTubeVisibility(restaurant)
        updateLayoutForSheetState()
    }
    
    private func configureBasicInfo(_ restaurant: Restaurant) {
        storeInfo.nameLabel.text = restaurant.name
        storeInfo.categoryLabel.text = restaurant.category
        storeInfo.addressLabel.text = restaurant.address
        storeInfo.numberLabel.text = restaurant.number
        storeInfo.parkingLabel.text = restaurant.amenities
        storeInfo.menusLabel.text = restaurant.menus.joined(separator: ", ")
    }
    
    private func configureBusinessHours(_ restaurant: Restaurant) {
        let status = restaurant.checkStoreStatus()
        storeInfo.openingHoursLabel.text = status.displayText
        storeInfo.openingHoursLabel.textColor = status.textColor
        
        let holidayIndex = CustomFormatterManager.shared.weekdayString(from: restaurant.closedDays) ?? -1
        scheduleView.updateSchedule(businessHours: restaurant.businessHours, holidayIndex: holidayIndex - 1)
    }
    
    private func configureButtons(_ restaurant: Restaurant) {
        visitButton.configureWithRestaurant(restaurant: restaurant)
        favoriteButton.configureWithRestaurant(restaurant: restaurant)
    }
    
    private func configureYouTubeVisibility(_ restaurant: Restaurant) {
        let hasYouTube = restaurant.youtubeId != nil
        storeInfo.menusToolLabel.isNoYoutube(isValid: !hasYouTube)
    }
    
    // MARK: - Sheet State Management
    private func updateSheetState() {
        guard let sheet = sheetPresentationController else { return }
        let newState: SheetState = sheet.selectedDetentIdentifier == .medium ? .medium : .large
        currentSheetState = newState
    }
    
    private func updateLayoutForSheetState() {
        let isMedium = currentSheetState == .medium
        
        // UI 요소 표시/숨김
        [dismissButton, storeInfo.menusToolLabel, storeInfo.menusLabel].forEach {
            $0.isHidden = isMedium
        }
        
        let hasYouTube = viewModel.restaurantInfo.youtubeId != nil
        youtubeViews.container.isHidden = isMedium || !hasYouTube
        
        updateConstraintsForSheetState(isMedium: isMedium, hasYouTube: hasYouTube)
    }
    
    private func updateConstraintsForSheetState(isMedium: Bool, hasYouTube: Bool) {
        if isMedium {
            setupMediumStateConstraints()
        } else {
            setupLargeStateConstraints(hasYouTube: hasYouTube)
        }
    }
    
    private func setupMediumStateConstraints() {
        favoriteButton.snp.remakeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.size.equalTo(36)
        }
        
        storeInfo.nameLabel.snp.remakeConstraints {
            $0.bottom.equalTo(favoriteButton.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        storeInfo.categoryLabel.snp.remakeConstraints {
            $0.bottom.equalTo(storeInfo.nameLabel.snp.bottom)
            $0.leading.equalTo(storeInfo.nameLabel.snp.trailing).offset(10)
            $0.trailing.lessThanOrEqualTo(visitButton.snp.leading).offset(-10)
            $0.width.greaterThanOrEqualTo(30).priority(.required)
        }
        
        youtubeViews.container.snp.remakeConstraints {
            $0.top.equalTo(scheduleView.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(0)
        }
    }
    
    private func setupLargeStateConstraints(hasYouTube: Bool) {
        favoriteButton.snp.remakeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.trailing.equalTo(dismissButton.snp.leading).offset(-10)
            $0.size.equalTo(36)
        }
        
        storeInfo.nameLabel.snp.remakeConstraints {
            $0.top.equalTo(favoriteButton.snp.bottom).offset(14)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        storeInfo.categoryLabel.snp.remakeConstraints {
            $0.bottom.equalTo(storeInfo.nameLabel.snp.bottom)
            $0.leading.equalTo(storeInfo.nameLabel.snp.trailing).offset(10)
            $0.trailing.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(20)
            $0.width.greaterThanOrEqualTo(30).priority(.required)
        }
        
        if hasYouTube {
            youtubeViews.container.snp.remakeConstraints {
                $0.top.equalTo(scheduleView.snp.bottom).offset(30)
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.height.equalTo(youtubeViews.container.snp.width).multipliedBy(9.0/16.0)
            }
            
            setupMenusConstraintsForLargeState()
        }
    }
    
    private func setupMenusConstraintsForLargeState() {
        storeInfo.menusToolLabel.snp.remakeConstraints {
            $0.top.equalTo(youtubeViews.container.snp.bottom).offset(10)
            $0.leading.equalTo(youtubeViews.container.snp.leading)
            $0.width.equalTo(150)
        }
        
        storeInfo.menusLabel.snp.remakeConstraints {
            $0.top.equalTo(storeInfo.menusToolLabel.snp.top).offset(4)
            $0.leading.equalTo(storeInfo.menusToolLabel.snp.trailing)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    @objc
    private func handlePhoneNumberTap() {
        guard let phoneNumber = storeInfo.numberLabel.text,
              phoneNumber != "등록된 연락처가 없습니다.",
              !phoneNumber.isEmpty else {
            showAlert(title: "통화 연결 실패", message: "연락처 정보가 없습니다.")
            return
        }
        
        makePhoneCall(phoneNumber: phoneNumber)
    }
    
    private func makePhoneCall(phoneNumber: String) {
        let cleanedPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        guard let phoneUrl = URL(string: "telprompt://\(cleanedPhoneNumber)"),
              UIApplication.shared.canOpenURL(phoneUrl) else {
            showAlert(title: "통화 연결 실패", message: "전화번호 형식이 올바르지 않거나 통화가 불가능합니다.")
            return
        }
        
        UIApplication.shared.open(phoneUrl)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertManager.shared.showAlert(title: title, message: message)
        present(alert, animated: true)
    }
}

// MARK: - UISheetPresentationControllerDelegate
extension DetailViewController: UISheetPresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        onDismiss?()
    }
}
