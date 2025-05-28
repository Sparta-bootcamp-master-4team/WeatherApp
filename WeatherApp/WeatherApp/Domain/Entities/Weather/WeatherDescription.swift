//
//  WeatherDescription.swift
//  WeatherApp
//
//  Created by 양원식 on 5/21/25.
//

import Foundation

// MARK: - 날씨 설명 (아이콘, 상태 등)
struct WeatherDescription: Decodable {
    let id: Int              // 날씨 상태 코드 (예: 800 = 맑음)
    let main: String         // 주요 날씨 그룹 (예: Clear, Clouds, Rain 등)
    let description: String  // 자세한 날씨 설명 (예: '약한 비') → lang=kr로 한국어 반환 가능
    let icon: String         // 아이콘 코드 (예: "01d", "03n" 등, 이미지 URL에 사용)
}
