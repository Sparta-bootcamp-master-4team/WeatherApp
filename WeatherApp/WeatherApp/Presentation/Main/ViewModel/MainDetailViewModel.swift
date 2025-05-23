//
//  MainDetailViewModel.swift
//  WeatherApp
//
//  Created by 송규섭 on 5/22/25.
//

import Foundation
import RxSwift
import RxCocoa

final class MainDetailViewModel {
    var sections: Observable<[MainSectionModel]>
    private let hourlyWeatherObservable: Observable<[HourlyWeather]>
    private let dailyWeatherAndtemperatureRangeObservable: Observable<DailyWeatherAndTemperatureRange?>
    init(hourlyWeatherObservable: Observable<[HourlyWeather]>,
         dailyWeatherAndTemperatureRangeObservable: Observable<DailyWeatherAndTemperatureRange?>) {
        self.hourlyWeatherObservable = hourlyWeatherObservable
        self.dailyWeatherAndtemperatureRangeObservable = dailyWeatherAndTemperatureRangeObservable
        self.sections = Observable.combineLatest(hourlyWeatherObservable, dailyWeatherAndTemperatureRangeObservable)
            .map({ hourly, dailyAndRange in
                return [
                    .hourly(items: hourly.map { .hourlyWeatherItem($0) }),
                    .daily(items: dailyAndRange?.dailyWeather.map { _ in
                        return .dailyWeatherListItem(DailyWeatherAndTemperatureRange(dailyWeather: dailyAndRange?.dailyWeather ?? [], temperatureRange: dailyAndRange?.temperatureRange ?? TemperatureRange(highestMinTemp: 0, highestMaxTemp: 0)))
                    } ?? [] )
                ]
            })

    }
}

