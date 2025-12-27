//
//  RestaurantDataRepository.swift
//  SeongjiChelin-iOS
//
//  Created by Claude on 12/27/25.
//

import Foundation
import RxSwift

/// 버전 체크 결과
struct VersionCheckResult {
    let needsUpdate: Bool
    let currentVersion: String?
    let latestVersion: String
    let downloadUrl: String?
}

/// 식당 데이터 통합 Repository (Remote + Local + Realm)
final class RestaurantDataRepository {

    static let shared = RestaurantDataRepository()

    private let remoteDataSource: RestaurantRemoteDataSource
    private let localDataSource: RestaurantLocalDataSource
    private let legacyRepository: RestaurantRepository
    private let userDefaultsManager: UserDefaultsManager

    private let disposeBag = DisposeBag()

    // 메모리 캐시
    private var cachedThemes: [RestaurantTheme]?
    private var cachedRestaurants: [String: Restaurant]?

    private init(
        remoteDataSource: RestaurantRemoteDataSource = .shared,
        localDataSource: RestaurantLocalDataSource = .shared,
        legacyRepository: RestaurantRepository = RestaurantRepository(),
        userDefaultsManager: UserDefaultsManager = .shared
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.legacyRepository = legacyRepository
        self.userDefaultsManager = userDefaultsManager

        loadCachedDataIntoMemory()
    }

    // MARK: - Data Access

    /// 모든 테마 가져오기 (메모리 캐시 > 로컬 캐시 > 폴백)
    func getAllThemes() -> [RestaurantTheme] {
        if let cached = cachedThemes {
            return cached
        }

        if let localData = localDataSource.loadCachedThemes() {
            cachedThemes = localData
            return localData
        }

        // 폴백: 기존 RestaurantLiterals 사용
        return RestaurantLiterals.allRestaurantThemes
    }

    /// 모든 식당 데이터 가져오기
    func getAllRestaurants() -> [Restaurant] {
        return getAllThemes().flatMap { $0.restaurants }
    }

    /// 특정 식당 가져오기
    func getRestaurant(storeID: String) -> Restaurant? {
        if let cached = cachedRestaurants?[storeID] {
            return cached
        }
        return getAllRestaurants().first { $0.storeID == storeID }
    }

    /// 테마별 식당 가져오기
    func getRestaurantsByTheme(_ themeType: RestaurantThemeType) -> [Restaurant] {
        return getAllThemes().first { $0.themeType == themeType }?.restaurants ?? []
    }

    // MARK: - Patch Related

    /// 오늘 패치가 필요한지 확인
    func shouldPatchToday() -> Bool {
        return userDefaultsManager.needsPatchToday
    }

    /// 캐시된 버전 가져오기
    func getCachedVersion() -> String? {
        return userDefaultsManager.cachedVersion
    }

    /// 마지막 패치 날짜 가져오기
    func getLastPatchDate() -> Date? {
        return userDefaultsManager.lastPatchDate
    }

    /// 서버 버전 확인
    func checkForUpdates() -> Observable<VersionCheckResult> {
        return remoteDataSource.checkVersion()
            .map { [weak self] remoteVersion in
                let localVersion = self?.userDefaultsManager.cachedVersion
                let needsUpdate = self?.userDefaultsManager.isNewerVersion(
                    remote: remoteVersion.version,
                    than: localVersion
                ) ?? true

                return VersionCheckResult(
                    needsUpdate: needsUpdate,
                    currentVersion: localVersion,
                    latestVersion: remoteVersion.version,
                    downloadUrl: remoteVersion.downloadUrl
                )
            }
    }

    /// 최신 데이터 다운로드
    func downloadLatestData(progress: PublishSubject<Float>) -> Observable<Bool> {
        return remoteDataSource.downloadRestaurantData(progress: progress)
            .flatMap { [weak self] data -> Observable<Bool> in
                guard let self = self else { return .just(false) }

                // 로컬 저장
                let saved = self.localDataSource.saveRestaurantData(data)

                if saved {
                    // 메모리 캐시 업데이트
                    self.updateMemoryCache(from: data)

                    // Realm Bridge 동기화
                    self.syncWithRealmBridges()

                    // 버전 및 날짜 저장
                    self.userDefaultsManager.recordPatchCompletion(version: data.version)

                    print("[DataRepository] 패치 완료: 버전 \(data.version)")
                }

                return .just(saved)
            }
            .catch { error in
                print("[DataRepository] 다운로드 실패: \(error)")
                return .just(false)
            }
    }

    // MARK: - Cache Management

    /// 메모리 캐시 초기화
    func loadCachedDataIntoMemory() {
        if let themes = localDataSource.loadCachedThemes() {
            cachedThemes = themes
            cachedRestaurants = Dictionary(
                uniqueKeysWithValues: themes.flatMap { $0.restaurants }.map { ($0.storeID, $0) }
            )
            print("[DataRepository] 메모리 캐시 로드 완료: \(cachedRestaurants?.count ?? 0)개 식당")
        }
    }

    /// 캐시 강제 새로고침
    func refreshCache() {
        cachedThemes = nil
        cachedRestaurants = nil
        loadCachedDataIntoMemory()
    }

    /// 모든 캐시 삭제
    func clearAllCache() {
        cachedThemes = nil
        cachedRestaurants = nil
        _ = localDataSource.clearCache()
        userDefaultsManager.resetPatchInfo()
    }

    // MARK: - Private Helpers

    private func updateMemoryCache(from data: RemoteRestaurantData) {
        let themes = data.themes.compactMap { $0.toRestaurantTheme() }
        cachedThemes = themes
        cachedRestaurants = Dictionary(
            uniqueKeysWithValues: themes.flatMap { $0.restaurants }.map { ($0.storeID, $0) }
        )
    }

    private func syncWithRealmBridges() {
        let allRestaurants = getAllRestaurants()
        // 기존 Repository를 통해 Bridge 재초기화
        // 새 식당이 추가되었을 경우에만 Bridge 생성
        legacyRepository.initializeRestaurantBridges()
        print("[DataRepository] Realm Bridge 동기화 완료")
    }
}

// MARK: - Compatibility with RestaurantLiterals

extension RestaurantLiterals {

    /// 동적 데이터 접근 (캐시 우선)
    static var dynamicThemes: [RestaurantTheme] {
        return RestaurantDataRepository.shared.getAllThemes()
    }

    /// 동적 전체 식당 데이터
    static var dynamicRestaurantsData: [Restaurant] {
        return RestaurantDataRepository.shared.getAllRestaurants()
    }
}
