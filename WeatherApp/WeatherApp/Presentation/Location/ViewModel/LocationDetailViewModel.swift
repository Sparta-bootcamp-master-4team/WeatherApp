//
//  LocationDetailViewModel.swift
//  WeatherApp
//
//  Created by shinyoungkim on 5/27/25.
//

import Foundation
import RxSwift

final class LocationDetailViewModel {
    let sections: Observable<[MainSectionModel]>

    private let hourlyWeatherObservable: Observable<[HourlyWeather]>
    private let dailyWeatherAndTemperatureRangeObservable: Observable<DailyWeatherAndTemperatureRange?>

    init(
        hourlyWeatherObservable: Observable<[HourlyWeather]>,
        dailyWeatherAndTemperatureRangeObservable: Observable<DailyWeatherAndTemperatureRange?>
    ) {
        self.hourlyWeatherObservable = hourlyWeatherObservable
        self.dailyWeatherAndTemperatureRangeObservable = dailyWeatherAndTemperatureRangeObservable

        self.sections = Observable
            .combineLatest(hourlyWeatherObservable, dailyWeatherAndTemperatureRangeObservable)
            .map { hourly, dailyAndRange in
                return [
                    .hourly(
                        items: hourly.map { .hourlyWeatherItem($0) },
                        header: "시간별 날씨"
                    ),
                    .daily(
                        items: dailyAndRange?.dailyWeather.map { _ in
                            .dailyWeatherListItem(
                                DailyWeatherAndTemperatureRange(
                                    dailyWeather: dailyAndRange?.dailyWeather ?? [],
                                    temperatureRange: dailyAndRange?.temperatureRange ?? TemperatureRange(highestMinTemp: 0, highestMaxTemp: 0)
                                )
                            )
                        } ?? [],
                        header: "요일별 날씨"
                    )
                ]
            }
    }
}
