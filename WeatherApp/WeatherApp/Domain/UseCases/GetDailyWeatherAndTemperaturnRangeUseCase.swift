//
//  GetDailyWeatherAndTemperaturnRangeUseCase.swift
//  WeatherApp
//
//  Created by 양원식 on 5/23/25.
//

import RxSwift

final class GetDailyWeatherAndTemperaturnRangeUseCase: GetDailyWeatherAndTemperatureRangeUseCaseProtocol {
    
    private let fetchDailyWeatherUseCase: FetchDailyWeatherUseCaseProtocol
    private let fetchTemperatureRangeUseCase: FetchDailyTemperatureRangeUseCaseProtocol

    init(
        fetchDailyWeatherUseCase: FetchDailyWeatherUseCaseProtocol,
        fetchTemperatureRangeUseCase: FetchDailyTemperatureRangeUseCaseProtocol
    ) {
        self.fetchDailyWeatherUseCase = fetchDailyWeatherUseCase
        self.fetchTemperatureRangeUseCase = fetchTemperatureRangeUseCase
    }

    func execute(lat: Double, lon: Double) -> Single<DailyWeatherAndTemperatureRange> {
        return Single.zip(
            fetchDailyWeatherUseCase.execute(lat: lat, lon: lon),
            fetchTemperatureRangeUseCase.execute(lat: lat, lon: lon)
        ) { dailyWeatherList, temperatureRange in
            return DailyWeatherAndTemperatureRange(
                dailyWeather: dailyWeatherList,
                temperatureRange: temperatureRange
            )
        }
    }
}
