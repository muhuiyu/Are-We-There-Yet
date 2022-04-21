//
//  SelectedLocationView.swift
//  Are We There Yet?
//
//  Created by Mu Yu on 4/8/22.
//

import UIKit

class SelectedLocationView: UIView {
    
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let bookmarkButton = IconButton(icon: UIImage(systemName: "bookmark") ?? UIImage())
    
    var location: Location? {
        didSet {
            guard let location = location else { return }
            titleLabel.text = location.title
            location.getAddress(completion: { address, error in
                if let error = error {
                    print(error)
                    return
                }
                guard let address = address else { return }
                self.subtitleLabel.text = address
            })
        }
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
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
extension SelectedLocationView {
    private func configureViews() {
        iconView.image = UIImage(systemName: "mappin.circle.fill")
        iconView.tintColor = .systemPink
        iconView.contentMode = .scaleAspectFit
        addSubview(iconView)
        
        titleLabel.text = "text"
        titleLabel.textColor = UIColor.label
        titleLabel.font = UIFont.bodyHeavy
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        
        subtitleLabel.text = "subtitle"
        subtitleLabel.textColor = UIColor.secondaryLabel
        subtitleLabel.font = UIFont.small
        subtitleLabel.textAlignment = .left
        subtitleLabel.numberOfLines = 0
        addSubview(subtitleLabel)
        
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 4
    }
    private func configureConstraints() {
        iconView.snp.remakeConstraints { make in
            make.leading.equalTo(layoutMarginsGuide)
            make.centerY.equalToSuperview()
            make.size.equalTo(Constants.iconButtonSize.small)
        }
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(layoutMarginsGuide)
            make.leading.equalTo(iconView.snp.trailing).offset(Constants.spacing.medium)
            make.trailing.equalTo(layoutMarginsGuide)
        }
        subtitleLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.spacing.trivial)
            make.bottom.equalTo(layoutMarginsGuide)
            make.leading.trailing.equalTo(titleLabel)
        }
    }
    private func configureGestures() {
        
    }
    private func configureSignals() {
        
    }
}

