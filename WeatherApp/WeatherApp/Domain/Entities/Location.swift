//
//  Location.swift
//  WeatherApp
//
//  Created by 양원식 on 5/20/25.
//

struct LocationAPIResponse: Codable {
    let documents: [Location]
}

struct Location: Codable {
    let addressName: String
    let longitude: String
    let latitude: String
}
