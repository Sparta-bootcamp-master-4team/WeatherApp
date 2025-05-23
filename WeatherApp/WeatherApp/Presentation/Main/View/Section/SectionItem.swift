//
//  SectionItem.swift
//  WeatherApp
//
//  Created by 송규섭 on 5/22/25.
//

import Foundation

enum SectionItem {
    case dailyWeatherListItem(DailyWeatherAndTemperatureRange)
    case hourlyWeatherItem(HourlyWeather)
}
