//
//  FetchCurrentWeatherUseCaseProtocol.swift
//  WeatherApp
//
//  Created by 양원식 on 5/21/25.
//

import RxSwift

// MARK: - 현재 날씨 유즈케이스 프로토콜
protocol FetchCurrentWeatherUseCaseProtocol {
    func execute(lat: Double, lon: Double) -> Single<CurrentWeather>
}
