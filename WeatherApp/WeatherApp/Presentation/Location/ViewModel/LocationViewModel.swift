//
//  LocationViewModel.swift
//  WeatherApp
//
//  Created by shinyoungkim on 5/27/25.
//

import Foundation
import RxSwift
import RxCocoa

final class LocationViewModel {
    private let fetchDailyWeatherUseCase: FetchDailyWeatherUseCaseProtocol
    private let fetchHourlyWeatherUseCase: FetchHourlyWeatherUseCaseProtocol
    private let fetchCurrentWeatherUseCase: FetchCurrentWeatherUseCaseProtocol
    private let reverseGeocodingUseCase: ReverseGeocodingUseCaseProtocol
    private let getDailyWeatherAndTemperatureRangeUseCase: GetDailyWeatherAndTemperatureRangeUseCaseProtocol
    private let saveLocationUseCase: SaveLocationUseCaseProtocol

    private let disposeBag = DisposeBag()
    private let selectedLocation: Location

    private let currentWeatherRelay = BehaviorRelay<CurrentWeather?>(value: nil)
    private let dailyWeatherRelay = BehaviorRelay<[DailyWeather]>(value: [])
    private let hourlyWeatherRelay = BehaviorRelay<[HourlyWeather]>(value: [])
    private let currentLocationTextRelay = BehaviorRelay<String>(value: "")
    private let dailyWeatherAndTemperatureRangeRelay = BehaviorRelay<DailyWeatherAndTemperatureRange?>(value: nil)
    private let weatherConditionRelay = BehaviorRelay<Int>(value: 800)
    let saveLocationTrigger = PublishRelay<Void>()
    let saveResult = PublishRelay<Result<Void, Error>>()

    var currentWeather: Driver<CurrentWeather?> {
        currentWeatherRelay.asDriver()
    }

    var dailyWeatherAndTemperatureRange: Observable<DailyWeatherAndTemperatureRange?> {
        dailyWeatherAndTemperatureRangeRelay.asObservable()
    }

    var hourlyWeather: Observable<[HourlyWeather]> {
        hourlyWeatherRelay.asObservable()
    }

    var currentTemp: Driver<String>?
    var todayMaxTemp: Driver<String>?
    var todayMinTemp: Driver<String>?
    var currentLocationText: Driver<(location: String, weather: String?)>?
    var weatherCondition: Driver<WeatherCondition>?
    var currentDate: Driver<String>?

    let didEnterRelay = PublishRelay<Void>()
    
    private let isSaved: Bool
    
    var isLocationSaved: Bool {
        return isSaved
    }

    init(
        location: Location,
        fetchDailyWeatherUseCase: FetchDailyWeatherUseCaseProtocol,
        fetchHourlyWeatherUseCase: FetchHourlyWeatherUseCaseProtocol,
        fetchCurrentWeatherUseCase: FetchCurrentWeatherUseCaseProtocol,
        reverseGeocodingUseCase: ReverseGeocodingUseCaseProtocol,
        getDailyWeatherAndTemperatureRangeUseCase: GetDailyWeatherAndTemperatureRangeUseCaseProtocol,
        saveLocationUseCase: SaveLocationUseCaseProtocol,
        isSaved: Bool = false
    ) {
        self.selectedLocation = location
        self.fetchDailyWeatherUseCase = fetchDailyWeatherUseCase
        self.fetchHourlyWeatherUseCase = fetchHourlyWeatherUseCase
        self.fetchCurrentWeatherUseCase = fetchCurrentWeatherUseCase
        self.reverseGeocodingUseCase = reverseGeocodingUseCase
        self.getDailyWeatherAndTemperatureRangeUseCase = getDailyWeatherAndTemperatureRangeUseCase
        self.saveLocationUseCase = saveLocationUseCase
        self.isSaved = isSaved

        bind()
    }

    private func bind() {
        didEnterRelay
            .subscribe(onNext: { [weak self] in
                self?.fetchWeather()
            })
            .disposed(by: disposeBag)

        currentTemp = currentWeatherRelay
            .map { weather in
                guard let temp = weather?.temp else { return "--" }
                return "\(Int(Float(temp).rounded()))"
            }
            .asDriver(onErrorJustReturn: "--")

        todayMaxTemp = dailyWeatherRelay
            .map { weathers in
                guard let max = weathers.first?.temp.max else { return "-" }
                return "\(Int(Float(max).rounded()))"
            }
            .asDriver(onErrorJustReturn: "-")

        todayMinTemp = dailyWeatherRelay
            .map { weathers in
                guard let min = weathers.first?.temp.min else { return "-" }
                return "\(Int(Float(min).rounded()))"
            }
            .asDriver(onErrorJustReturn: "-")

        currentLocationText = Observable
            .combineLatest(currentLocationTextRelay, currentWeatherRelay)
            .map { location, weather in
                let description = weather?.weather.first?.description
                return (location, description)
            }
            .asDriver(onErrorJustReturn: ("", nil))

        weatherCondition = weatherConditionRelay
            .map { WeatherCondition(from: $0) }
            .asDriver(onErrorJustReturn: .clear)

        currentDate = currentWeatherRelay
            .map { value in
                guard let value else { return "" }
                let dt = TimeInterval(value.dt)
                let monthDay = Date.formattedMonthDay(from: dt)
                let weekdayOrToday = Date.weekdayOrToday(from: dt)
                return "\(weekdayOrToday) \(monthDay)"
            }
            .asDriver(onErrorJustReturn: "")
        
        saveLocationTrigger
            .flatMapLatest { [weak self] _ -> Observable<Result<Void, Error>> in
                guard let self else { return .empty() }

                return self.saveLocationUseCase.execute(self.selectedLocation)
                    .andThen(Single.just(Result<Void, Error>.success(())))
                    .asObservable()
                    .catch { error in
                        Observable.just(.failure(error))
                    }
            }
            .bind(to: saveResult)
            .disposed(by: disposeBag)
    }

    private func fetchWeather() {
        guard let lat = Double(selectedLocation.latitude),
              let lon = Double(selectedLocation.longitude) else {
            return
        }

        self.currentLocationTextRelay.accept(self.selectedLocation.name)

        fetchCurrentWeatherUseCase.execute(lat: lat, lon: lon)
            .subscribe(onSuccess: { [weak self] weather in
                guard let self,
                      let conditionId = weather.weather.first?.id else { return }
                self.currentWeatherRelay.accept(weather)
                self.weatherConditionRelay.accept(conditionId)
            })
            .disposed(by: disposeBag)

        fetchDailyWeatherUseCase.execute(lat: lat, lon: lon)
            .subscribe(onSuccess: { [weak self] daily in
                self?.dailyWeatherRelay.accept(daily)
            })
            .disposed(by: disposeBag)

        fetchHourlyWeatherUseCase.execute(lat: lat, lon: lon)
            .subscribe(onSuccess: { [weak self] hourly in
                self?.hourlyWeatherRelay.accept(hourly)
            })
            .disposed(by: disposeBag)

        getDailyWeatherAndTemperatureRangeUseCase.execute(lat: lat, lon: lon)
            .subscribe(onSuccess: { [weak self] range in
                self?.dailyWeatherAndTemperatureRangeRelay.accept(range)
            })
            .disposed(by: disposeBag)
    }
}
