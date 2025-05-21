//
//  UIView+.swift
//  WeatherApp
//
//  Created by 송규섭 on 5/21/25.
//

import UIKit

extension UIView {
    func addSubviews(views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}
