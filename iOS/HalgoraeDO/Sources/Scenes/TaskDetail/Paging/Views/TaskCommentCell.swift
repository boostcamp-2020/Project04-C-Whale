//
//  TaskDetailCommentCell.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/09.
//

import UIKit

class TaskCommentCell: UICollectionViewCell {
    
    var viewModel: TaskDetailModels.CommentVM? {
        didSet {
            contentsLabel.text = viewModel?.contents
        }
    }
    
    let contentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure() {
        contentView.addSubview(contentsLabel)
        NSLayoutConstraint.activate([
            contentsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            contentsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        layoutIfNeeded()
    }
}

extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}
