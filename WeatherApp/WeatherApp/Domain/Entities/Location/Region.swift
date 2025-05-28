//
//  Region.swift
//  WeatherApp
//
//  Created by tlswo on 5/21/25.
//

import Foundation

// MARK: - RegionResponse

struct RegionResponse: Codable {
    let documents: [RegionDocument]
}

// MARK: - RegionDocument

struct RegionDocument: Codable {
    let addressName: String
    let regionTwoDepthName: String
    let regionThreeDepthName: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case regionTwoDepthName = "region_2depth_name"
        case regionThreeDepthName = "region_3depth_name"
    }
}
