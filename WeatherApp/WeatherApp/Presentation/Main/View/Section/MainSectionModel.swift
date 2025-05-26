//
//  MainSectionModel.swift
//  WeatherApp
//
//  Created by 송규섭 on 5/22/25.
//

import Foundation
import RxDataSources

enum MainSectionModel {
    case daily(items: [SectionItem], header: String)
    case hourly(items: [SectionItem], header: String)
}

extension MainSectionModel: SectionModelType {
    var items: [SectionItem] {
        switch self {
        case .daily(let items, _): return items
        case .hourly(let items, _): return items
        }
    }
    
    init(original: MainSectionModel, items: [SectionItem]) {
        switch original {
        case .daily(_, let header): self = .daily(items: items, header: header)
        case .hourly(_, let header): self = .hourly(items: items, header: header)
        }
    }
    
    typealias Item = SectionItem
}
