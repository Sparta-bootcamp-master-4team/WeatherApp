//
//  SearchDongsUseCaseProtocol.swift
//  WeatherApp
//
//  Created by tlswo on 5/21/25.
//

// MARK: - SearchDongsUseCaseProtocol

protocol SearchDongsUseCaseProtocol {

    // MARK: - UseCase Execution

    func execute(query: String) -> [String]
}
