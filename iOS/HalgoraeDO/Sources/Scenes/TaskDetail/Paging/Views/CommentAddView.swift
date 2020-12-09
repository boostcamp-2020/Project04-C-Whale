//
//  CommentAddView.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/10.
//

import UIKit

class CommentAddView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var contentsTextView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        UINib(nibName: "\(CommentAddView.self)", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentsTextView.layer.cornerRadius = 10
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowColor = UIColor.lightGray.cgColor
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowOpacity = 0.4
    }
    
    @IBAction func didTapAddButton(_ sender: UIButton) {
        
    }
    @IBAction func didTapDoneButton(_ sender: UIButton) {
        
    }
}
