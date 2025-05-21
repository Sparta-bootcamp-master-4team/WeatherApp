//
//  Location.swift
//  WeatherApp
//
//  Created by 양원식 on 5/20/25.
//

// MARK: - KakaoAddressResponse (Top-level Kakao API Response)

struct KakaoAddressResponse: Decodable {
    let documents: [KakaoDocument]
}

// MARK: - KakaoDocument (Intermediate Response Structure)

struct KakaoDocument: Decodable {
    let address: KakaoAddress?
}

// MARK: - KakaoAddress (Address Information)

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

// MARK: - Location (Internal App Model)

struct Location {
    let name: String
    let latitude: String
    let longitude: String
}
