//
//  UIStackView+.swift
//  WeatherApp
//
//  Created by 송규섭 on 5/21/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(views: UIView...) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
