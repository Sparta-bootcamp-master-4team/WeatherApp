//
//  ViewModelProtocol.swift
//  WeatherApp
//
//  Created by 권순욱 on 5/23/25.
//

import RxSwift

protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get }
}
