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
    
    private var minTemp: CGFloat = 0
    private var maxTemp: CGFloat = 0
    private var globalMin: CGFloat = 0
    private var globalMax: CGFloat = 0
    private var isConfigured = false
    
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
        self.minTemp = min
        self.maxTemp = max
        self.globalMin = globalMin
        self.globalMax = globalMax
        self.isConfigured = true
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("📏 DailyTemperatureRange width:", bounds.width, "height:", bounds.height)
        guard isConfigured else { return }
        guard globalMax > globalMin else { return }
        
        let totalRange = globalMax - globalMin
        let leftOffsetRatio = (minTemp - globalMin) / totalRange
        let widthRatio = (maxTemp - minTemp) / totalRange

        let leftOffset = bounds.width * leftOffsetRatio
        let barWidth = bounds.width * widthRatio

        barView.snp.remakeConstraints {
            $0.leading.equalToSuperview().offset(leftOffset)
            $0.width.equalTo(barWidth)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(8)
        }
    }
}
