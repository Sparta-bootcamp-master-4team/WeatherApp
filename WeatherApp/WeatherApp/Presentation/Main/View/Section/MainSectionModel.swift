//
//  MainSectionModel.swift
//  WeatherApp
//
//  Created by 송규섭 on 5/22/25.
//

import Foundation
import RxDataSources

enum MainSectionModel {
    case daily(items: [SectionItem])
    case hourly(items: [SectionItem])
}

extension MainSectionModel: SectionModelType {
    var items: [SectionItem] {
        switch self {
        case .daily(let items): return items
        case .hourly(let items): return items
        }
    }
    
    init(original: MainSectionModel, items: [SectionItem]) {
        switch original {
        case .daily: self = .daily(items: items)
        case .hourly: self = .hourly(items: items)
        }
    }
    
    typealias Item = SectionItem
}
