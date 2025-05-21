//
//  FetchCoordinateUseCaseProtocol.swift
//  WeatherApp
//
//  Created by tlswo on 5/21/25.
//

import RxSwift

// MARK: - FetchCoordinateUseCaseProtocol

protocol FetchCoordinateUseCaseProtocol {

    // MARK: - UseCase Execution

    func execute(query: String) -> Single<Location?>
}
