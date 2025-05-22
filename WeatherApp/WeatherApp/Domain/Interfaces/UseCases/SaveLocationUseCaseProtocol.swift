//
//  SaveLocationUseCaseProtocol.swift
//  WeatherApp
//
//  Created by tlswo on 5/22/25.
//

import RxSwift

// MARK: - SaveLocationUseCaseProtocol

protocol SaveLocationUseCaseProtocol {
    
    // MARK: - UseCase Execution

    func execute(_ location: Location) -> Completable
}
