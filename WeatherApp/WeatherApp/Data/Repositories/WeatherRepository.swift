//
//  WeatherRepository.swift
//  WeatherApp
//
//  Created by 양원식 on 5/21/25.
//

import RxSwift

// MARK: - 날씨 리포지토리 구현체
final class WeatherRepositoryImpl: WeatherRepositoryProtocol {
    private let service: WeatherAPIService

    init(apiService: WeatherAPIService = .shared) {
        self.service = apiService
    }

    /// service를 통해 날씨 데이터를 요청
    func fetchWeather(lat: Double, lon: Double) -> Single<WeatherResponse> {
        return service.fetchWeather(lat: lat, lon: lon)
    }
}
