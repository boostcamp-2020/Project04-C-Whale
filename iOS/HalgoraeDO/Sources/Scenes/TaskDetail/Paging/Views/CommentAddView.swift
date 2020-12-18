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
        contentView.shadow()
        contentsTextView.delegate = self
    }
    
    @IBAction private func didTapDoneButton(_ sender: UIButton) {
        doneHandler?(contentsTextView.text)
        contentsTextView.text = ""
    }
}

extension CommentAddView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        guard textView.intrinsicContentSize.height < maxHeight else { return }
        textViewHeighConstraint.constant = textView.contentSize.height
    }
}
