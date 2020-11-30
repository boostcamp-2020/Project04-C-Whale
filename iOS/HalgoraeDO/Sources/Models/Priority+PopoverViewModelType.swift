//
//  Priority+ViewModelType.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/29.
//

import UIKit

// MARK: - For PopoverViewModel

extension Priority {
    struct ViewModel: PopoverViewModelType {
        var title: String
        var tintColor: UIColor?
        var image: UIImage?
    }
    
    var color: UIColor {
        switch self {
            case .one: return .red
            case .two: return .blue
            case .three: return .orange
            case .four: return .black
        }
    }
    
    var viewModel: ViewModel {
        let image = UIImage(systemName: "flag.fill")?.scaled(to: .init(width: 30, height: 30))
        switch self {
            case .one: return ViewModel(title: title, tintColor: color, image: image)
            case .two: return ViewModel(title: title, tintColor: color, image: image)
            case .three: return ViewModel(title: title, tintColor: color, image: image)
            case .four: return ViewModel(title: title, tintColor: color, image: image)
        }
    }
}
