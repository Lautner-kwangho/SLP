//
//  ReviewViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/12.
//

import UIKit

final class ReviewViewController: BaseViewController {
    
    let reviewTableView = UITableView().then {
        $0.register(ReviewTableCell.self, forCellReuseIdentifier: ReviewTableCell.reuseIdentifier)
    }
    var reviewList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        view.backgroundColor = SacColor.color(.white)
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        reviewTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func setConstraints() {
        view.addSubview(reviewTableView)
        reviewTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableCell.reuseIdentifier, for: indexPath) as? ReviewTableCell else {return UITableViewCell()}
        
        cell.selectionStyle = .none
        cell.review.text = reviewList[indexPath.row]
        
        return cell
    }
    
    
}
