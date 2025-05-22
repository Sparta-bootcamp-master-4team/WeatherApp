//
//  MainViewModel.swift
//  WeatherApp
//
//  Created by 양원식 on 5/20/25.
//

import RxSwift
import RxCocoa

final class MainViewModel {
    private let fetchDailyWeatherUseCase: FetchDailyWeatherUseCaseProtocol
    private let fetchHourlyWeatherUseCase: FetchHourlyWeatherUseCaseProtocol
    private let fetchCurrentWeatherUseCase: FetchCurrentWeatherUseCaseProtocol
    private let getCurrentLocationUseCase: GetCurrentLocationUseCaseProtocol
    private let reverseGeocodingUseCase: ReverseGeocodingUseCaseProtocol
    private let disposeBag = DisposeBag()

    // MARK: - ViewModel -> View
    private let currentWeatherRelay = BehaviorRelay<CurrentWeather?>(value: nil)
    private let dailyWeatherRelay = BehaviorRelay<[DailyWeather]>(value: [])
    private let hourlyWeatherRelay = BehaviorRelay<[HourlyWeather]>(value: [])
    private let currentLocationRelay = BehaviorRelay<Location>(value: Location(name: "My Home", latitude: "37.440070781162675", longitude: "127.12814126170936"))
    private let currentLocationTextRelay = BehaviorRelay<String>(value: "위치 불러오는 중...")

    var currentWeather: Driver<CurrentWeather?> {
        currentWeatherRelay.asDriver()
    }
    var dailyWeather: Observable<[DailyWeather]> {
        dailyWeatherRelay.asObservable() // mainDetailVM에서 sections에 넣을 데이터인데, Driver는 UI 바인딩에 최적화되어있기에.
    }
    var hourlyWeather: Observable<[HourlyWeather]> {
        hourlyWeatherRelay.asObservable()
    }
    var currentTemp: Driver<String>?
    var todayMaxTemp: Driver<String>?
    var todayMinTemp: Driver<String>?
    var currentLocationText: Driver<String>? {
        currentLocationTextRelay.asDriver()
    }

    

    // MARK: - View -> ViewModel
    let didEnterRelay = PublishRelay<Void>()

    init(
        fetchDailyWeatherUseCase: FetchDailyWeatherUseCaseProtocol,
        fetchHourlyWeatherUseCase: FetchHourlyWeatherUseCaseProtocol,
        fetchCurrentWeatherUseCase: FetchCurrentWeatherUseCaseProtocol,
        getCurrentLocationUseCase: GetCurrentLocationUseCaseProtocol,
        reverseGeocodingUseCase: ReverseGeocodingUseCaseProtocol
    ) {
        self.fetchDailyWeatherUseCase = fetchDailyWeatherUseCase
        self.fetchHourlyWeatherUseCase = fetchHourlyWeatherUseCase
        self.fetchCurrentWeatherUseCase = fetchCurrentWeatherUseCase
        self.getCurrentLocationUseCase = getCurrentLocationUseCase
        self.reverseGeocodingUseCase = reverseGeocodingUseCase

        bind()
    }

    private func fetchCurrentLocation() {
        getCurrentLocationUseCase.execute()
            .subscribe(onSuccess: { [weak self] value in
                guard let self else { return }
                let latitude = value.latitude
                let longitude = value.longitude
                let location = Location(name: "집", latitude: String(latitude), longitude: String(longitude))
                currentLocationRelay.accept(location)
            }).disposed(by: disposeBag)
    }

    private func bind() {
        didEnterRelay
            .do(onNext: { print("didEnter triggered") })
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                fetchCurrentLocation()
            }).disposed(by: disposeBag)

        currentLocationRelay
            .skip(1)
            .do(onNext: { _ in print("currentLocation triggered") })
            .subscribe(onNext: { [weak self] location in
                guard let self,
                      let latitude = Double(location.latitude),
                      let longitude = Double(location.longitude) else { return }

                self.reverseGeocodingUseCase.getAddressFromCoordinates(x: longitude, y: latitude)
                    .subscribe(onSuccess: { [weak self] value in
                        guard let self else { return }
                        print(value)
                        currentLocationTextRelay.accept(value)
                    }).disposed(by: disposeBag)

                self.fetchCurrentWeatherUseCase.execute(lat: latitude, lon: longitude)
                    .subscribe(onSuccess: { [weak self] value in
                        guard let self else { return }
                        currentWeatherRelay.accept(value)
                    }).disposed(by: disposeBag)

                self.fetchDailyWeatherUseCase.execute(lat: latitude, lon: longitude)
                    .subscribe(onSuccess: { [weak self] value in
                        print(value[0])
                        guard let self else { return }
                        dailyWeatherRelay.accept(value)
                    }).disposed(by: disposeBag)
                // 남은 일자, 시간 별 데이터도 fetch 필요
                self.fetchHourlyWeatherUseCase.execute(lat: latitude, lon: longitude)
                    .subscribe(onSuccess: { [weak self] value in
                        print(value)
                        guard let self else { return }
                        hourlyWeatherRelay.accept(value)
                    }).disposed(by: disposeBag)

            }).disposed(by: disposeBag)

        currentTemp = currentWeatherRelay
            .map { weather in
                guard let temp = weather?.temp else { return "--" }
                return "\(Int(Float(temp).rounded(.toNearestOrAwayFromZero)))"
            }.asDriver(onErrorJustReturn: "--")
        todayMaxTemp = dailyWeatherRelay
            .map { weathers in
                guard let max = weathers.first?.temp.max else { return "-" }

                print("최고 기온 : \(Float(max).rounded(.toNearestOrAwayFromZero))")
                return "\(Int(Float(max).rounded(.toNearestOrAwayFromZero)))"
            }.asDriver(onErrorJustReturn: "-")
        todayMinTemp = dailyWeatherRelay
            .map { weathers in
                guard let min = weathers.first?.temp.min else { return "-" }
                print("최저 기온 : \(Float(min).rounded(.toNearestOrAwayFromZero))")
                return "\(Int(Float(min).rounded(.toNearestOrAwayFromZero)))"
            }.asDriver(onErrorJustReturn: "-")
    }

}
