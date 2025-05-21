//
//  WeatherAPIService.swift
//  WeatherApp
//
//  Created by 양원식 on 5/20/25.
//

import Foundation
import RxSwift

// MARK: - Weather API Error 정의
enum WeatherAPIError: Error {
    case invalidURL
    case noData
    case decodingFailed(Error)
}

// MARK: - 날씨 API 서비스
final class WeatherAPIService {
    static let shared = WeatherAPIService()
    private init() {}

    private let apiKey = Bundle.main.weatherAPIKey

    /// 날씨 데이터를 요청.
    func fetchWeather(
        lat: Double,
        lon: Double,
        exclude: [String] = ["minutely", "alerts"],
        units: String = "metric",
        lang: String = "kr"
    ) -> Single<WeatherResponse> {
        return Single.create { [weak self] single in
            guard let self = self, let url = self.makeURL(lat: lat, lon: lon, exclude: exclude, units: units, lang: lang) else {
                single(.failure(WeatherAPIError.invalidURL))
                return Disposables.create()
            }

            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    single(.failure(error))
                    return
                }

                guard let data = data else {
                    single(.failure(WeatherAPIError.noData))
                    return
                }

                do {
                    let decoded = try self.decode(data: data)
                    single(.success(decoded))
                } catch {
                    single(.failure(WeatherAPIError.decodingFailed(error)))
                }
            }

            task.resume()
            return Disposables.create { task.cancel() }
        }
    }

    // MARK: - URL 생성
    private func makeURL(lat: Double, lon: Double, exclude: [String], units: String, lang: String) -> URL? {
        var components = URLComponents(string: "https://api.openweathermap.org/data/3.0/onecall")
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "exclude", value: exclude.joined(separator: ",")),
            URLQueryItem(name: "units", value: units),
            URLQueryItem(name: "lang", value: lang),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        return components?.url
    }

    // MARK: - 디코딩
    private func decode(data: Data) throws -> WeatherResponse {
        let decoder = JSONDecoder()
        return try decoder.decode(WeatherResponse.self, from: data)
    }
}
