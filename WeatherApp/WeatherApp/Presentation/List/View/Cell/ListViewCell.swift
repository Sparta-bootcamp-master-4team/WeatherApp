//
//  ListViewCell.swift
//  WeatherApp
//
//  Created by 권순욱 on 5/22/25.
//

import UIKit
import SnapKit

class ListViewCell: UITableViewCell {
    static let reuseIdentifier = "ListViewCell"
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 16
        stackView.backgroundColor = .systemGray6
        return stackView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = .label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(label)
        
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.height.equalTo(80)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(text: String) {
        label.text = text
    }
}
