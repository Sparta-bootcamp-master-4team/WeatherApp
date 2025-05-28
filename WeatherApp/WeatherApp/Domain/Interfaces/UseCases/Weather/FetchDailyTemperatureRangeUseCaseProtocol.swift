//
//  FetchDailyTemperatureRangeUseCaseProtocol.swift
//  WeatherApp
//
//  Created by 양원식 on 5/22/25.
//

import RxSwift

// MARK: - 8일 예보에서 최고 최저 온도만 반환
protocol FetchDailyTemperatureRangeUseCaseProtocol {
    func execute(lat: Double, lon: Double) -> Single<TemperatureRange>
}
