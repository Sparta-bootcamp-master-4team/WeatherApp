//
//  GetDailyWeatherAndTemperaturnRangeUseCaseProtocol.swift
//  WeatherApp
//
//  Created by 양원식 on 5/23/25.
//

import RxSwift

protocol GetDailyWeatherAndTemperaturnRangeUseCaseProtocol {
    
    func execute(lat: Double, lon: Double) -> Single<DailyWeatherAndTemperaturnRange>
}
