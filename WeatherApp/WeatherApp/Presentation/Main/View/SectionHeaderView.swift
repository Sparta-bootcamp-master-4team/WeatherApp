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
        label.font = .nanumSquare(size: 14)
        return label
    }()
    
    private let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [
            titleLabel,
            bottomLine
        ].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
        
        bottomLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
