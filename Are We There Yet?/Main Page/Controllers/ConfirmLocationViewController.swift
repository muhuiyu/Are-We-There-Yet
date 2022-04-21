//
//  ConfirmLocationViewController.swift
//  Are We There Yet?
//
//  Created by Mu Yu on 4/8/22.
//

import UIKit
import RxSwift

class ConfirmLocationViewController: ViewController {

    private let disposeBag = DisposeBag()
    
    private let backButton = IconButton(icon: UIImage(systemName: "chevron.backward"))
    private let selectedLocationView = SelectedLocationView()
    private let slider = UISlider()
    private let radiusLabel = UILabel()
    private let confirmButton = TextButton(frame: .zero, buttonType: .primary)
    
    var viewModel = ConfirmLocationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
        configureGestures()
        configureSignals()
    }
}
// MARK: - View Config
extension ConfirmLocationViewController {
    private func configureViews() {
        backButton.tapHandler = { [weak self] in
            self?.viewModel.didTapBackButton()
        }
        view.addSubview(backButton)
        view.addSubview(selectedLocationView)
        
        slider.value = 0
        slider.isContinuous = false
        slider.maximumValue = viewModel.sliderMaxValue
        slider.minimumValue = viewModel.sliderMinValue
        slider.addTarget(viewModel, action: #selector(viewModel.didChangeSliderValue(_:)), for: .valueChanged)
        view.addSubview(slider)
        
        radiusLabel.text = "Radius"
        radiusLabel.font = UIFont.body
        radiusLabel.textColor = .label
        view.addSubview(radiusLabel)
        
        confirmButton.text = viewModel.displayButtonText
        view.addSubview(confirmButton)
    }
    private func configureConstraints() {
        backButton.snp.remakeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide)
            make.leading.equalToSuperview()
            make.size.equalTo(Constants.iconButtonSize.large)
        }
        selectedLocationView.snp.remakeConstraints { make in
            make.top.equalTo(backButton.snp.bottom)
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
        slider.snp.remakeConstraints { make in
            make.top.equalTo(selectedLocationView.snp.bottom).offset(Constants.spacing.medium)
            make.leading.trailing.equalTo(selectedLocationView)
        }
        radiusLabel.snp.remakeConstraints { make in
            make.top.equalTo(slider.snp.bottom).offset(Constants.spacing.small)
            make.leading.trailing.equalTo(selectedLocationView)
        }
        confirmButton.snp.remakeConstraints { make in
            make.top.equalTo(radiusLabel.snp.bottom).offset(Constants.spacing.large)
            make.leading.trailing.equalTo(selectedLocationView)
        }
    }
    private func configureGestures() {
        
    }
    private func configureSignals() {
        viewModel.selectedLocation
            .asObservable()
            .subscribe(onNext: { value in
                if let value = value {
                    self.selectedLocationView.location = value
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.radius
            .asObservable()
            .subscribe(onNext: { value in
                self.radiusLabel.text = "Remind me within \(value) m"
            })
            .disposed(by: disposeBag)
    }
}

