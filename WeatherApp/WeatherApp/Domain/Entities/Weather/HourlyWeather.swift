//
//  HourlyWeather.swift
//  WeatherApp
//
//  Created by 양원식 on 5/21/25.
//

import Foundation

// MARK: - 시간별 날씨
struct HourlyWeather: Decodable {
    let dt: Int                        // 시간 (Unix Timestamp 형식)
    let temp: Double                   // 해당 시간의 기온
    let weather: [WeatherDescription]  // 해당 시간의 날씨 상태 (배열 형태이지만 보통 1개만 포함됨)
}
