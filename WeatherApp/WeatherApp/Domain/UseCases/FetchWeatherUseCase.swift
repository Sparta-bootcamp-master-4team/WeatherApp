//
//  FetchWeatherUseCase.swift
//  WeatherApp
//
//  Created by 양원식 on 5/21/25.
//

import RxSwift

// MARK: - 전체 날씨 유즈케이스 구현체
final class FetchAllWeatherUseCase: FetchAllWeatherUseCaseProtocol {
    private let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }

    func execute(lat: Double, lon: Double) -> Single<WeatherResponse> {
        repository.fetchWeather(lat: lat, lon: lon)
    }
}

