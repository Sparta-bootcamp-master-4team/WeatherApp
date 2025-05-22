//
//  ListView.swift
//  WeatherApp
//
//  Created by 권순욱 on 5/22/25.
//

import UIKit
import SnapKit

class ListView: UIView {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListViewCell.self, forCellReuseIdentifier: ListViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setSubviews()
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubviews() {
        backgroundColor = .white
        
        [tableView].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalTo(safeAreaLayoutGuide.snp.verticalEdges)
        }
    }
}
