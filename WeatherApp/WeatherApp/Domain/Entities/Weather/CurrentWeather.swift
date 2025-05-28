//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by 양원식 on 5/21/25.
//

import Foundation

// MARK: - 현재 날씨
struct CurrentWeather: Decodable {
    let dt: Int                        // 현재 시간 (Unix Timestamp)
    let sunrise: Int?                 // 일출 시각 (Unix Timestamp, 옵셔널)
    let sunset: Int?                  // 일몰 시각 (Unix Timestamp, 옵셔널)
    let temp: Double                  // 현재 기온 (기본 단위: °C)
    let feelsLike: Double            // 체감 기온
    let pressure: Int                // 기압 (hPa)
    let humidity: Int                // 습도 (%)
    let uvi: Double                  // 자외선 지수
    let clouds: Int                 // 구름량 (%)
    let visibility: Int             // 가시거리 (미터)
    let windSpeed: Double           // 풍속 (m/s)
    let windDeg: Int                // 풍향 (도, 0~360)
    let weather: [WeatherDescription] // 날씨 설명 배열 (일반적으로 1개 포함)

    // MARK: - JSON 키 매핑
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity, uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
    }
}

