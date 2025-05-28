//
//  UICollectionView+.swift
//  WeatherApp
//
//  Created by 송규섭 on 5/23/25.
//

import UIKit

extension UICollectionView {
    static func withCompositionalLayout() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) in
            if let section = Section(sectionIndex) {
                return section.layoutSection
            }
            return nil
        }
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
}
