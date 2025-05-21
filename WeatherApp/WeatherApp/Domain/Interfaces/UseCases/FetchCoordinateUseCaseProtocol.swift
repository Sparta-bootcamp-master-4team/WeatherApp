//
//  FetchCoordinateUseCaseProtocol.swift
//  WeatherApp
//
//  Created by tlswo on 5/21/25.
//

import RxSwift

protocol FetchCoordinateUseCaseProtocol {
    func execute(query: String) -> Single<Location?>
}
