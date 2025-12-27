//
//  RestaurantRemoteDataSource.swift
//  SeongjiChelin-iOS
//
//  Created by Claude on 12/27/25.
//

import Foundation
import RxSwift

/// GitHub Releases에서 식당 데이터를 가져오는 Remote Data Source
final class RestaurantRemoteDataSource {

    static let shared = RestaurantRemoteDataSource()

    // MARK: - Configuration

    /// GitHub Releases 다운로드 URL
    /// 형식: https://github.com/{owner}/{repo}/releases/latest/download/{filename}
    private let baseURL = "https://github.com/psyeon1120/SeongjiChelin-iOS/releases/latest/download"
    private let dataFileName = "restaurants_latest.json"
    private let metadataFileName = "validation_report.json"

    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
    }

    // MARK: - Version Check

    /// 서버의 최신 버전 정보 확인
    func checkVersion() -> Observable<RemoteVersionInfo> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(RemoteDataSourceError.invalidResponse)
                return Disposables.create()
            }

            // 먼저 HEAD 요청으로 최신 릴리스 확인
            guard let url = URL(string: "\(self.baseURL)/\(self.dataFileName)") else {
                observer.onError(RemoteDataSourceError.invalidResponse)
                return Disposables.create()
            }

            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"

            let task = self.session.dataTask(with: request) { _, response, error in
                if let error = error {
                    observer.onError(RemoteDataSourceError.versionCheckFailed(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    // Release가 없으면 로컬 버전 사용
                    let versionInfo = RemoteVersionInfo(
                        version: "0.0.0",
                        lastUpdated: nil,
                        downloadUrl: nil
                    )
                    observer.onNext(versionInfo)
                    observer.onCompleted()
                    return
                }

                // Last-Modified 헤더에서 업데이트 시간 추출
                let lastModified = httpResponse.value(forHTTPHeaderField: "Last-Modified")

                let versionInfo = RemoteVersionInfo(
                    version: "latest",
                    lastUpdated: lastModified,
                    downloadUrl: url.absoluteString
                )
                observer.onNext(versionInfo)
                observer.onCompleted()
            }

            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }

    /// GitHub Releases에서 JSON 다운로드
    func downloadRestaurantData(progress: PublishSubject<Float>? = nil) -> Observable<RemoteRestaurantData> {
        return downloadRawData(progress: progress)
            .map { data in
                let decoder = JSONDecoder()
                return try decoder.decode(RemoteRestaurantData.self, from: data)
            }
            .catch { error in
                throw RemoteDataSourceError.parsingFailed(error)
            }
    }

    /// Raw JSON 데이터 다운로드
    func downloadRawData(progress: PublishSubject<Float>? = nil) -> Observable<Data> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(RemoteDataSourceError.invalidResponse)
                return Disposables.create()
            }

            guard let url = URL(string: "\(self.baseURL)/\(self.dataFileName)") else {
                observer.onError(RemoteDataSourceError.invalidResponse)
                return Disposables.create()
            }

            progress?.onNext(0.1)

            let task = self.session.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(RemoteDataSourceError.downloadFailed(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.onError(RemoteDataSourceError.invalidResponse)
                    return
                }

                guard httpResponse.statusCode == 200 else {
                    if httpResponse.statusCode == 404 {
                        // Release가 없으면 폴백 데이터 사용
                        let fallbackData = self.createFallbackData()
                        progress?.onNext(1.0)
                        observer.onNext(fallbackData)
                        observer.onCompleted()
                    } else {
                        observer.onError(RemoteDataSourceError.invalidResponse)
                    }
                    return
                }

                guard let data = data else {
                    observer.onError(RemoteDataSourceError.invalidResponse)
                    return
                }

                progress?.onNext(1.0)
                observer.onNext(data)
                observer.onCompleted()
            }

            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }

    // MARK: - Private Helpers

    /// 폴백 데이터 생성 (Release가 없을 때)
    private func createFallbackData() -> Data {
        let remoteData = createRemoteDataFromLiterals()
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            return try encoder.encode(remoteData)
        } catch {
            return Data()
        }
    }

    /// RestaurantLiterals를 RemoteRestaurantData로 변환 (폴백용)
    private func createRemoteDataFromLiterals() -> RemoteRestaurantData {
        let themes = RestaurantLiterals.allRestaurantThemes.map { theme -> RemoteRestaurantTheme in
            let restaurants = theme.restaurants.map { restaurant -> RemoteRestaurant in
                RemoteRestaurant(
                    storeID: restaurant.storeID,
                    name: restaurant.name,
                    category: restaurant.category,
                    number: restaurant.number,
                    address: restaurant.address,
                    menus: restaurant.menus,
                    closedDays: restaurant.closedDays,
                    breakTime: restaurant.breakTime,
                    businessHours: restaurant.businessHours,
                    amenities: restaurant.amenities,
                    latitude: restaurant.latitude,
                    longitude: restaurant.longitude,
                    youtubeId: restaurant.youtubeId,
                    psyReview: restaurant.psyReview,
                    externalLinks: restaurant.externalLinks,
                    aggregatedRating: restaurant.aggregatedRating,
                    lastVerified: nil,
                    verificationStatus: nil
                )
            }

            return RemoteRestaurantTheme(
                themeType: theme.themeType.idPrefix,
                displayName: theme.themeType.rawValue,
                restaurants: restaurants
            )
        }

        return RemoteRestaurantData(
            version: "1.0.0",
            lastUpdated: ISO8601DateFormatter().string(from: Date()),
            themes: themes
        )
    }
}

// MARK: - Error Types

enum RemoteDataSourceError: Error, LocalizedError {
    case networkUnavailable
    case downloadFailed(Error)
    case parsingFailed(Error)
    case versionCheckFailed(Error)
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return StringLiterals.shared.networkUnavailable
        case .downloadFailed(let error):
            return "\(StringLiterals.shared.downloadFailed): \(error.localizedDescription)"
        case .parsingFailed(let error):
            return "\(StringLiterals.shared.dataProcessingFailed): \(error.localizedDescription)"
        case .versionCheckFailed(let error):
            return "\(StringLiterals.shared.versionCheckFailed): \(error.localizedDescription)"
        case .invalidResponse:
            return StringLiterals.shared.unknownError
        }
    }

    var isRecoverable: Bool {
        switch self {
        case .networkUnavailable, .versionCheckFailed:
            return true
        default:
            return false
        }
    }
}
