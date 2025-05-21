//
//  SectionHeaderView.swift
//  WeatherApp
//
//  Created by shinyoungkim on 5/21/25.
//

import UIKit
import SnapKit

final class SectionHeaderView: UICollectionReusableView {
    static let id = "SectionHeaderView"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
