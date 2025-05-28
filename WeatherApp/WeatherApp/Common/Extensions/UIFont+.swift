//
//  UIFont+.swift
//  WeatherApp
//
//  Created by 송규섭 on 5/21/25.
//

import UIKit

extension UIFont {
    static func nanumSquare(size: CGFloat, weight: String = "R") -> UIFont {
        let name = "NanumSquare" + weight
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
