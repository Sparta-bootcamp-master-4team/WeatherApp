//
//  SearchView.swift
//  WeatherApp
//
//  Created by 권순욱 on 5/21/25.
//

import UIKit
import SnapKit

class SearchView: UIView {
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchViewCell.self, forCellReuseIdentifier: SearchViewCell.reuseIdentifier)
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
        
        [searchBar, tableView].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
