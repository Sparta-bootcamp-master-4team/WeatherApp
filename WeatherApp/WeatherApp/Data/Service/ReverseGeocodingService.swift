//
//  ReverseGeocodingService.swift
//  WeatherApp
//
//  Created by tlswo on 5/21/25.
//

import Foundation
import RxSwift

// MARK: - Protocol

protocol ReverseGeocodingServiceProtocol {
    func fetchAddressName(x: Double, y: Double) -> Single<String>
}

// MARK: - Service

final class ReverseGeocodingService: ReverseGeocodingServiceProtocol {
    
    // MARK: - Properties

    private let apiKey = Bundle.main.kakaoAPIKey
    private let baseURL = "https://dapi.kakao.com/v2/local/geo/coord2regioncode.json"

    // MARK: - Public Methods

    func fetchAddressName(x: Double, y: Double) -> Single<String> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(NSError(domain: "APIService", code: -1, userInfo: nil)))
                return Disposables.create()
            }

            // MARK: - URL Construction

            var components = URLComponents(string: self.baseURL)
            components?.queryItems = [
                URLQueryItem(name: "x", value: "\(x)"),
                URLQueryItem(name: "y", value: "\(y)")
            ]

            guard let url = components?.url else {
                single(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
                return Disposables.create()
            }

            // MARK: - Request Setup

            var request = URLRequest(url: url)
            request.setValue("KakaoAK \(self.apiKey)", forHTTPHeaderField: "Authorization")

            // MARK: - Network Call

            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    single(.failure(error))
                    return
                }

                guard
                    let data = data,
                    let decoded = try? JSONDecoder().decode(RegionResponse.self, from: data),
                    let address = decoded.documents.first?.addressName
                else {
                    single(.failure(NSError(domain: "Decoding or Empty Data Error", code: -1, userInfo: nil)))
                    return
                }

                single(.success(address))
            }

            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
