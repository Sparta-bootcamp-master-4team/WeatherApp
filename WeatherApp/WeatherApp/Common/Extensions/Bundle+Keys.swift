//
//  Bundle+Keys.swift
//  WeatherApp
//
//  Created by tlswo on 5/21/25.
//

import Foundation

extension Bundle {
    var kakaoAPIKey: String {
        guard let key = object(forInfoDictionaryKey: "KAKAO_API_KEY") as? String else {
            fatalError("KAKAO_API_KEY not found")
        }
        return key
    }

    var weatherAPIKey: String {
        guard let key = object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String else {
            fatalError("WEATHER_API_KEY not found")
        }
        return key
    }
}
