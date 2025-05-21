//
//  SearchDongsUseCaseProtocol.swift
//  WeatherApp
//
//  Created by tlswo on 5/21/25.
//

protocol SearchDongsUseCaseProtocol {
    func execute(query: String) -> [String]
}
