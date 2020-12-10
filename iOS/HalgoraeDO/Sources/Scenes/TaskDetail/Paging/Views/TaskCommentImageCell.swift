//
//  ImageCommentCell.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/09.
//

import UIKit

class TaskCommentImageCell: UICollectionViewCell {
    
    var viewModel: TaskDetailModels.CommentVM? {
        didSet {
            // TODO: set Image
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        contentView.layer.borderWidth = 0.5
        contentView.layer.cornerRadius = 10
    }
    
}
