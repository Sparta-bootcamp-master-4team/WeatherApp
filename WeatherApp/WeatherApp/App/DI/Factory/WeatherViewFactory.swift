//
//  Untitled.swift
//  WeatherApp
//
//  Created by 양원식 on 5/26/25.
//

final class WeatherViewModelFactory {
    func makeMainViewModel() -> MainViewModel {
        let repo = WeatherRepositoryImpl()
        let locationRepo = LocationRepository(locationService: LocationService())
        let reverseRepo = ReverseGeocodingRepository(reverseGeocodingService: ReverseGeocodingService())

        let daily = FetchDailyWeatherUseCase(repository: repo)
        let hourly = FetchHourlyWeatherUseCase(repository: repo)
        let current = FetchCurrentWeatherUseCase(repository: repo)
        let location = GetCurrentLocationUseCase(repository: locationRepo)
        let reverse = ReverseGeocodingUseCase(repository: reverseRepo)
        let dailyAndRange = GetDailyWeatherAndTemperaturnRangeUseCase(
            fetchDailyWeatherUseCase: daily,
            fetchTemperatureRangeUseCase: FetchDailyTemperatureRangeUseCase(repository: repo)
        )

        return MainViewModel(
            fetchDailyWeatherUseCase: daily,
            fetchHourlyWeatherUseCase: hourly,
            fetchCurrentWeatherUseCase: current,
            getCurrentLocationUseCase: location,
            reverseGeocodingUseCase: reverse,
            getDailyWeatherAndTemperatureRangeUseCase: dailyAndRange
        )
    }

    func makeMainDetailViewModel(mainVM: MainViewModel) -> MainDetailViewModel {
        return MainDetailViewModel(
            hourlyWeatherObservable: mainVM.hourlyWeather,
            dailyWeatherAndTemperatureRangeObservable: mainVM.dailyWeatherAndTemperatureRange
        )
    }

    func makePageViewModel() -> PageViewModel {
        return PageViewModel()
    }
}
