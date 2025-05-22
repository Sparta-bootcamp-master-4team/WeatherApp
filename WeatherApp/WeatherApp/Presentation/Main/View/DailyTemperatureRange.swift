//
//  DailyTemperatureRange.swift
//  WeatherApp
//
//  Created by shinyoungkim on 5/21/25.
//

import UIKit
import SnapKit

final class DailyTemperatureRange: UIView {
    private let backgroundBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 4
        return view
    }()
    private let barView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 4
        return view
    }()
    
    private var minTemp: CGFloat = 0
    private var maxTemp: CGFloat = 0
    private var globalMin: CGFloat = 0
    private var globalMax: CGFloat = 0
    private var isConfigured = false
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        [
            backgroundBarView,
            barView
        ].forEach { addSubview($0) }
        barView.layer.addSublayer(gradientLayer)
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
        guard isConfigured else { return }
        guard globalMax > globalMin else { return }
        
        let totalRange = globalMax - globalMin
        let leftOffsetRatio = (minTemp - globalMin) / totalRange
        let widthRatio = (maxTemp - minTemp) / totalRange

        let leftOffset = bounds.width * leftOffsetRatio
        let barWidth = bounds.width * widthRatio
        
        backgroundBarView.snp.remakeConstraints {
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(8)
        }

        barView.snp.remakeConstraints {
            $0.leading.equalToSuperview().offset(leftOffset)
            $0.width.equalTo(barWidth)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        gradientLayer.frame = barView.bounds
        let startColor = color(for: minTemp)
        let endColor = color(for: maxTemp)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 4
    }
    
    func color(for temperature: CGFloat) -> UIColor {
        switch temperature {
        case ..<0: return .systemIndigo
        case 0..<5: return .systemBlue
        case 5..<10: return .cyan
        case 10..<15: return .systemTeal
        case 15..<20: return .systemGreen
        case 20..<25: return .yellow
        case 25..<30: return .orange
        case 30..<35: return .red
        default: return .brown
        }
    }
}
