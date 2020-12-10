//
//  CommentAddView.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/10.
//

import UIKit

class CommentAddView: UIView {
    
    // MARK: - Properties
    
    var maxHeight: CGFloat = 140
    var doneHandler: ((String) -> Void)?
    @IBOutlet weak var textViewHeighConstraint: NSLayoutConstraint!
    
    // MARK: - Views
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak private(set) var contentsTextView: UITextView!
    
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
        contentsTextView.delegate = self
    }
    
    @IBAction private func didTapDoneButton(_ sender: UIButton) {
        doneHandler?(contentsTextView.text)
    }
}

extension CommentAddView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        guard textView.intrinsicContentSize.height < maxHeight else { return }
        textViewHeighConstraint.constant = textView.contentSize.height
    }
}
