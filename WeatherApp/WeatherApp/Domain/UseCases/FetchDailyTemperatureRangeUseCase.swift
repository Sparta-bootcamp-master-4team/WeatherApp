//
//  FetchDailyTemperatureRangeUseCase.swift
//  WeatherApp
//
//  Created by 양원식 on 5/22/25.
//

import RxSwift

// MARK: - 8일 예보 최저/최고 온도 중 최대값 추출 유즈케이스
final class FetchDailyTemperatureRangeUseCase: FetchDailyTemperatureRangeUseCaseProtocol {
    private let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }

    /// 8일간의 일일 예보 중,
    /// 최저 기온들 중 가장 높은 값과
    /// 최고 기온들 중 가장 높은 값을 추출하여 반환합니다.
    ///
    /// - Parameters:
    ///   - lat: 위도 (Latitude)
    ///   - lon: 경도 (Longitude)
    /// - Returns: `Single<TemperatureRange>` 타입의 비동기 스트림
    ///   - `highestMinTemp`: 8일 중 가장 높은 최저 기온
    ///   - `highestMaxTemp`: 8일 중 가장 높은 최고 기온
    ///
    /// ## 사용 예시:
    /// ```
    /// useCase.execute(lat: 37.5665, lon: 126.9780)
    ///     .subscribe(onSuccess: { range in
    ///         print("가장 높은 최저온도: \(range.highestMinTemp)°C")
    ///         print("가장 높은 최고온도: \(range.highestMaxTemp)°C")
    ///     })
    ///     .disposed(by: disposeBag)
    /// ```
    func execute(lat: Double, lon: Double) -> Single<TemperatureRange> {
        return repository.fetchWeather(lat: lat, lon: lon)
            .map { response in
                let dailyList = Array(response.daily.prefix(8))
                
                let highestMinTemp = dailyList.map { $0.temp.min }.max() ?? 0.0
                let highestMaxTemp = dailyList.map { $0.temp.max }.max() ?? 0.0
                
                return TemperatureRange(
                    highestMinTemp: highestMinTemp,
                    highestMaxTemp: highestMaxTemp
                )
            }
    }
}
