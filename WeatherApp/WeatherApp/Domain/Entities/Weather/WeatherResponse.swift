//
//  Weather.swift
//  WeatherApp
//
//  Created by 양원식 on 5/21/25.
//

import Foundation

// MARK: - 날씨 응답 모델 (One Call API 전체 응답)
struct WeatherResponse: Decodable {
    let lat: Double                   // 위도
    let lon: Double                   // 경도
    let timezone: String             // 시간대 (예: Asia/Seoul)
    let timezoneOffset: Int          // 시간대 오프셋 (초 단위)
    let current: CurrentWeather      // 현재 날씨
    let hourly: [HourlyWeather]      // 시간별 날씨
    let daily: [DailyWeather]        // 일일 날씨

    // MARK: - JSON 키 매핑
    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly, daily
    }
}

