//
//  TemperatureInfo.swift
//  WeatherApp
//
//  Created by 양원식 on 5/21/25.
//

import Foundation

// MARK: - 기온 정보 (일일)
struct TemperatureInfo: Decodable {
    let day: Double    // 낮 기온 (예: 오후 시간대 기준 평균 기온)
    let min: Double    // 일 최저 기온
    let max: Double    // 일 최고 기온
    let night: Double  // 밤 기온
    let eve: Double    // 저녁 기온
    let morn: Double   // 아침 기온
}
