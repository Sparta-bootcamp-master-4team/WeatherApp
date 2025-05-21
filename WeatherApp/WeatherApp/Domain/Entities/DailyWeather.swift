//
//  DailyWeather.swift
//  WeatherApp
//
//  Created by 양원식 on 5/21/25.
//

import Foundation

// MARK: - 일일 날씨
struct DailyWeather: Decodable {
    let dt: Int                        // 날짜 (Unix Timestamp, 예: 해당 날짜의 12:00:00 기준)
    let sunrise: Int                  // 일출 시각 (Unix Timestamp)
    let sunset: Int                   // 일몰 시각 (Unix Timestamp)
    let temp: TemperatureInfo         // 시간대별 기온 정보 (아침, 낮, 저녁, 밤 등)
    let weather: [WeatherDescription] // 해당 날짜의 날씨 설명 (보통 1개 요소)
}
