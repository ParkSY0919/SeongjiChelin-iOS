//
//  PatchViewModel.swift
//  SeongjiChelin-iOS
//
//  Created by Claude on 12/27/25.
//

import Foundation
import RxSwift
import RxCocoa

final class PatchViewModel: ViewModelProtocol {

    struct Input {
        let viewDidLoad: Observable<Void>
    }

    struct Output {
        let patchState: Driver<PatchState>
        let progress: Driver<Float>
        let statusText: Driver<String>
        let shouldNavigateToHome: Signal<Void>
    }

    private let patchManager: DataPatchManager
    private let disposeBag = DisposeBag()

    private let shouldNavigateToHomeRelay = PublishRelay<Void>()

    init(patchManager: DataPatchManager = .shared) {
        self.patchManager = patchManager
    }

    func transform(input: Input) -> Output {
        // 뷰 로드 시 패치 시작
        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.startPatch()
            })
            .disposed(by: disposeBag)

        // 상태 변환
        let patchState = patchManager.patchState
            .asDriver(onErrorJustReturn: .idle)

        let progress = patchManager.progressSubject
            .asDriver(onErrorJustReturn: 0)

        let statusText = patchState
            .map { $0.displayText }

        let shouldNavigateToHome = shouldNavigateToHomeRelay.asSignal()

        return Output(
            patchState: patchState,
            progress: progress,
            statusText: statusText,
            shouldNavigateToHome: shouldNavigateToHome
        )
    }

    private func startPatch() {
        patchManager.executePatch { [weak self] in
            self?.shouldNavigateToHomeRelay.accept(())
        }
    }
}
