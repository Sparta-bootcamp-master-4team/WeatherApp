//
//  WeatherCondition.swift
//  WeatherApp
//
//  Created by 송규섭 on 5/26/25.
//

import UIKit

enum WeatherCondition: String {
    case clear     // 맑음 (800)
    case rain     // 비 (500~531)
    case shower    // 소나기 (521, 520 등 일부 Rain 코드)
    case partlyCloudy // 구름 낌 (801)
    case cloudy    // 흐림 + 부서진 구름 (802~804)
    case fog      // 안개 (701~781 중 mist, smoke, haze, etc.)
    case thunderstorm // 뇌우 (200~232)
    case snow     // 눈 (600~622)

    init(from weatherId: Int) {
        switch weatherId {
        case 200...232:
            self = .thunderstorm
        case 300...321:
            self = .shower
        case 500...504, 520, 521, 522, 531:
            self = .rain
        case 511, 600...622:
            self = .snow
        case 701...781:
            self = .fog
        case 800:
            self = .clear
        case 801:
            self = .partlyCloudy
        case 802...804:
            self = .cloudy
        default:
            self = .clear // 알 수 없는 경우 기본값으로 맑음 처리
        }
    }

    var animatedIconCode: String {
        switch self {
        case .clear: return "clear"
        case .rain: return "rain"
        case .shower: return "shower"
        case .partlyCloudy: return "partlyCloudy"
        case .cloudy: return "cloudy"
        case .fog: return "fog"
        case .thunderstorm: return "thunderStorm"
        case .snow: return "snow"
        }
    }

    var icon: UIImage {
        switch self {
        case .clear:
            return .clear
        case .rain:
            return .rain
        case .shower:
            return .shower
        case .partlyCloudy:
            return .partlyCloudy
        case .cloudy:
            return .cloudy
        case .fog:
            return .fog
        case .thunderstorm:
            return .thunderStorm
        case .snow:
            return .snow
        }
    }
}
