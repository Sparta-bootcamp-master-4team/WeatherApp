//
//  DailyTemperatureRange.swift
//  WeatherApp
//
//  Created by shinyoungkim on 5/21/25.
//

import UIKit
import SnapKit

final class DailyTemperatureRange: UIView {
    private let barView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        addSubview(barView)
        barView.backgroundColor = .systemBlue
        barView.layer.cornerRadius = 4
    }
    
    func configure(min: CGFloat, max: CGFloat, globalMin: CGFloat, globalMax: CGFloat) {
        let totalRange = globalMax - globalMin
        let leftOffsetRatio = (min - globalMin) / totalRange
        let widthRatio = (max - min) / totalRange
        
        barView.snp.remakeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(8)
            $0.leading.equalToSuperview().offset(bounds.width * leftOffsetRatio)
            $0.width.equalTo(bounds.width * widthRatio)
        }
    }
}
