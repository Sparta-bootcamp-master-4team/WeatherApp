//
//  NoResultsView.swift
//  WeatherApp
//
//  Created by 권순욱 on 5/21/25.
//

import UIKit
import SnapKit

class NoResultsView: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과 없음"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과가 여기에 표시됩니다."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [imageView, titleLabel, descriptionLabel].forEach {
            addSubview($0)
        }
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(64)
            $0.width.height.equalTo(64)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(8)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }
    
    func update(searchText: String) {
        if searchText == "" {
            descriptionLabel.text = "검색 결과가 여기에 표시됩니다."
        } else {
            descriptionLabel.text = "\"\(searchText)\"에 대한 검색 결과가 없습니다."
        }
    }
}
