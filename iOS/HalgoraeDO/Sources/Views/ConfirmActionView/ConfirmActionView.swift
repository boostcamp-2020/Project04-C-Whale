//
//  ConfirmActionView.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/30.
//

import UIKit

class ConfirmActionView: UIView {
    
    // MARK: - Properties
    
    var backHandler: (() -> Void)?
    
    // MARK: - Views

    @IBOutlet private(set) var contentView: UIView!
    @IBOutlet private(set) weak var backButton: UIButton!
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var descriptionLabel: UILabel!
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        UINib(nibName: String(describing: ConfirmActionView.self), bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.layer.cornerRadius = 10
    }
    
    // MARK: - Methods
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        backHandler?()
    }
}
