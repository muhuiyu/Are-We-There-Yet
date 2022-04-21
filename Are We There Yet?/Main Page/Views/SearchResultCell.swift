//
//  SearchResultCell.swift
//  Are We There Yet?
//
//  Created by Mu Yu on 4/6/22.
//

import UIKit
import RxSwift

class SearchResultCell: UITableViewCell {
    private let titleLabel = UILabel()
    static let reuseID = NSStringFromClass(SearchResultCell.self)
    
    var viewModel = SearchResultViewModel()
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        configureConstraints()
        configureGestures()
        configureSignals()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK: - View Config
extension SearchResultCell {
    private func configureViews() {
        titleLabel.text = "default"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.body
        contentView.addSubview(titleLabel)
        
        contentView.backgroundColor = .secondarySystemBackground
        backgroundColor = .secondarySystemBackground
    }
    private func configureConstraints() {
        titleLabel.snp.remakeConstraints { make in
            make.leading.top.bottom.trailing.equalTo(contentView.layoutMarginsGuide)
        }
    }
    private func configureGestures() {
        
    }
    private func configureSignals() {
        viewModel.displayTitle.subscribe(onNext: { value in
            self.titleLabel.text = value
        }).disposed(by: disposeBag)

    }
}
