//
//  DailyWeatherCell.swift
//  WeatherApp
//
//  Created by 양원식 on 5/20/25.
//

import UIKit
import SnapKit

final class DailyWeatherCell: UICollectionViewCell {
    static let id = "DailyWeatherCell"
    
    private let weekdayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let weatherIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let popLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
    private let iconAndPopStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        return sv
    }()
    
    private let highTempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let lowTempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    let dailyTemperatureRange = DailyTemperatureRange()
    
    private let dailyTemperatureRangeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 4
        return sv
    }()
    
    private let fullStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [
            weatherIconImageView,
            popLabel
        ].forEach { iconAndPopStackView.addArrangedSubview($0) }
        
        [
            lowTempLabel,
            dailyTemperatureRange,
            highTempLabel
        ].forEach { dailyTemperatureRangeStackView.addArrangedSubview($0) }
        
        [
            weekdayLabel,
            iconAndPopStackView,
            dailyTemperatureRangeStackView
        ].forEach { fullStackView.addArrangedSubview($0) }

        addSubview(fullStackView)
    }
    
    private func setupConstraints() {
        weekdayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(28)
        }
        
        weatherIconImageView.snp.makeConstraints {
            $0.width.height.equalTo(40)
        }
        
        iconAndPopStackView.snp.makeConstraints {
            $0.leading.equalTo(weekdayLabel.snp.trailing)
        }
        
        dailyTemperatureRange.snp.makeConstraints {
            $0.width.equalTo(128)
            $0.height.equalTo(16)
        }
        
        dailyTemperatureRangeStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        fullStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(dailyWeather: DailyWeather, range: TemperatureRange) {
        weekdayLabel.text = Date.weekdayOrToday(from: TimeInterval(dailyWeather.dt))
        
        if let icon = dailyWeather.weather.first?.icon {
            if let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") {
                weatherIconImageView.kf.setImage(with: url)
            }
        }
        popLabel.text = "\(dailyWeather.pop)%"
        highTempLabel.text = "\(Int(dailyWeather.temp.max))"
        lowTempLabel.text = "\(Int(dailyWeather.temp.min))"
        
        dailyTemperatureRange.configure(
            min: dailyWeather.temp.min,
            max: dailyWeather.temp.max,
            globalMin: range.highestMinTemp,
            globalMax: range.highestMaxTemp
        )
    }
}
