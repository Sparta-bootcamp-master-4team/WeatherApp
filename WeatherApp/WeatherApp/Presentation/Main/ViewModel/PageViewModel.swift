//
//  PageViewModel.swift
//  WeatherApp
//
//  Created by 송규섭 on 5/21/25.
//

import Foundation
import RxCocoa

final class PageViewModel {
    let currentPage = BehaviorRelay<Int>(value: 0)
}
