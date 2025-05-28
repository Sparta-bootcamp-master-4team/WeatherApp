//
//  FetchDailyWeatherUseCase.swift
//  WeatherApp
//
//  Created by 양원식 on 5/21/25.
//

import RxSwift

// MARK: - 일별 날씨 유즈케이스 구현체
final class FetchDailyWeatherUseCase: FetchDailyWeatherUseCaseProtocol {
    private let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }

    func execute(lat: Double, lon: Double) -> Single<[DailyWeather]> {
        repository.fetchWeather(lat: lat, lon: lon)
            .map { Array($0.daily.prefix(8)) }
    }
}
