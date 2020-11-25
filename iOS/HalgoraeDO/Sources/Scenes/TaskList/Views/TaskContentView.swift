//
//  TaskContentView.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/24.
//

import UIKit

class TaskContentView: UIView, UIContentView {
    
    // MARK: - Properties
    
    private var currentConfiguration: TaskContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? TaskContentConfiguration else {
                return
            }
            
            apply(configuration: newConfiguration)
        }
    }
    var completeHandler: ((Bool) -> Void)?
    
    // MARK: - Views
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        
        return stackView
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "check_empty"), for: .normal)
        button.setImage(UIImage(named: "check"), for: .selected)
        button.addTarget(self, action: #selector(didTapCompleteButton(_:)), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.masksToBounds = false
        
        return button
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - Initialize

    init(configuration: TaskContentConfiguration) {
        super.init(frame: .zero)
        setupViews()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
    }
    
    // MARK:  - Selectors
    
    @objc private func didTapCompleteButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        completeHandler?(sender.isSelected)
    }
}

private extension TaskContentView {
    
    private func setupViews() {
        
        addSubview(stackView)
        stackView.addArrangedSubview(completeButton)
        stackView.addArrangedSubview(contentView)
        contentView.addSubview(titleLabel)
        
        let completeButtonHeight = completeButton.heightAnchor.constraint(equalToConstant: 30)
        completeButtonHeight.priority = UILayoutPriority(rawValue: 750)
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            completeButtonHeight,
            completeButton.widthAnchor.constraint(equalToConstant: 30),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    private func apply(configuration: TaskContentConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }
        
        titleLabel.text = configuration.title
        completeButton.isSelected = configuration.isCompleted ?? false
        currentConfiguration = configuration
        
    }
}
