//
//  HourlyWeatherCell.swift
//  WeatherApp
//
//  Created by 양원식 on 5/20/25.
//

import UIKit
import SnapKit
import Kingfisher

final class HourlyWeatherCell: UICollectionViewCell {
    static let id = "HourlyWeatherCell"
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
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
            timeLabel,
            weatherIconImageView,
            temperatureLabel
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        weatherIconImageView.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(weatherIconImageView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configure(with hourlyWeather: HourlyWeather) {
        timeLabel.text = "\(hourlyWeather.dt)"
        if let icon = hourlyWeather.weather.first?.icon {
            if let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") {
                weatherIconImageView.kf.setImage(with: url)
            }
        }
        temperatureLabel.text = "\(Int(hourlyWeather.temp))°C"
    }
    
//    func configure(with dummyWeather: DummyHourlyWeather) {
//        timeLabel.text = dummyWeather.time
//        if let url = URL(string: "https://openweathermap.org/img/wn/\(dummyWeather.weatherIcon)@2x.png") {
//            weatherIconImageView.kf.setImage(with: url)
//        }
//        temperatureLabel.text = "\(dummyWeather.temperature)°C"
//    }
}
