//
//  SearchViewController.swift
//  Are We There Yet?
//
//  Created by Mu Yu on 4/5/22.
//

import UIKit
import CoreLocation
import RxSwift

class SearchViewController: ViewController {
    private let disposeBag = DisposeBag()
    
    private let labelLabel = UILabel()
    private let textField = UITextField()
    private let tableView = UITableView()
    
    var locations = [Location]()
    var viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
        configureGestures()
        bindViews()
    }
}

// MARK: - View Config
extension SearchViewController {
    private func configureViews() {
        labelLabel.text = viewModel.title
        labelLabel.font = UIFont.h3
        view.addSubview(labelLabel)
        
        textField.placeholder = viewModel.textFieldPlaceholder
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.backgroundColor = .secondarySystemBackground
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        view.addSubview(textField)
        
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseID)
        view.addSubview(tableView)
    }
    private func configureConstraints() {
        labelLabel.snp.remakeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide).inset(Constants.spacing.medium)
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
        textField.snp.remakeConstraints { make in
            make.top.equalTo(labelLabel.snp.bottom).offset(Constants.spacing.medium)
            make.height.equalTo(Constants.textField.height)
            make.leading.trailing.equalTo(labelLabel)
        }
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(Constants.spacing.medium)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func configureGestures() {
        
    }
    private func bindViews() {
        textField.rx
            .text
            .orEmpty
            .bind(to: self.viewModel.searchObserver)
            .disposed(by: disposeBag)
        
        textField.rx
            .controlEvent(.editingDidEnd)
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.textField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .content
            .drive(tableView.rx.items(cellIdentifier: SearchResultCell.reuseID)) { indexPath, item, cell in
                guard let cell = cell as? SearchResultCell else { return }
                cell.viewModel.location.accept(item)
            }
            .disposed(by: disposeBag)
        
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Location.self))
            .subscribe { indexPath, item in
                self.viewModel.didSelectLocation(item)
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
