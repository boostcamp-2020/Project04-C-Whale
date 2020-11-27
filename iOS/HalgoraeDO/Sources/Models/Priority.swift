//
//  Priority.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/26.
//

import UIKit

enum Priority: Int, CaseIterable {
    case one = 1
    case two
    case three
    case four
    
    var title: String {
        switch self {
            case .one: return "우선순위 1"
            case .two: return "우선순위 2"
            case .three: return "우선순위 3"
            case .four: return "우선순위 4"
        }
    }
    
    var color: UIColor {
        switch self {
            case .one: return .red
            case .two: return .blue
            case .three: return .orange
            case .four: return .black
        }
    }
}

// MARK: - For PopoverViewModel

extension Priority {
    struct ViewModel: PopoverViewModelType {
        var title: String
        var tintColor: UIColor?
        var image: UIImage?
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
