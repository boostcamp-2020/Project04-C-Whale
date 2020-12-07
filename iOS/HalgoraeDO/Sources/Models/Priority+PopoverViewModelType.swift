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
    
    func viewModel(scaled size: CGSize = .init(width: 22, height: 22)) -> ViewModel {
        return ViewModel(title: title, tintColor: color, image: UIImage(systemName: "flag.fill")?.scaled(to: size))
    }
}
