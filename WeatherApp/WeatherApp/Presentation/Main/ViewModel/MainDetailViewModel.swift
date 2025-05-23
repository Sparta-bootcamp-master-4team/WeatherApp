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

    var sections: Observable<[MainSectionModel]>?
    private let hourlyWeatherObservable: Observable<[HourlyWeather]>
    private let dailyWeatherObservable: Observable<[DailyWeather]>

    init(hourlyWeatherObservable: Observable<[HourlyWeather]>, dailyWeatherObservable: Observable<[DailyWeather]>) {
        self.hourlyWeatherObservable = hourlyWeatherObservable
        self.dailyWeatherObservable = dailyWeatherObservable

        bind()
    }

    func bind() {
        sections = Observable.combineLatest(hourlyWeatherObservable, dailyWeatherObservable)
            .map({ hourly, daily in
                return [
                    .hourly(items: hourly.map { .hourlyWeatherItem($0) }),
                    .daily(items: daily.map { .dailyWeatherItem($0) })
                ]
            })
    }
}
