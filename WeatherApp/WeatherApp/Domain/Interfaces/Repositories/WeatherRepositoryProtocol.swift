//
//  Untitled.swift
//  WeatherApp
//
//  Created by 양원식 on 5/21/25.
//
import RxSwift

// MARK: - 날씨 리포지토리 프로토콜
protocol WeatherRepositoryProtocol {
    func fetchWeather(
        lat: Double,
        lon: Double
    ) -> Single<WeatherResponse>
    
}
