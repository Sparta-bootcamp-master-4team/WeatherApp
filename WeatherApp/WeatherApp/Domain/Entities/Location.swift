//
//  Location.swift
//  WeatherApp
//
//  Created by 양원식 on 5/20/25.
//

struct KakaoAddressResponse: Decodable {
    let documents: [KakaoDocument]
}

struct KakaoDocument: Decodable {
    let address: KakaoAddress?
}

struct KakaoAddress: Decodable {
    let addressName: String
    let x: String
    let y: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case x
        case y
    }
}

struct Location {
    let name: String
    let latitude: String
    let longitude: String
}
