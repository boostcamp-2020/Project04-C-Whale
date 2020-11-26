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
}

// MARK: - For PopoverViewModel

extension Priority {
    struct ViewModel: PopoverViewModelType {
        var title: String
        var tintColor: UIColor?
        var image: UIImage?
    }
    
    var viewModel: ViewModel {
        let image = UIImage(named: "flag")?.scaled(to: .init(width: 30, height: 30))
        switch self {
            case .one: return ViewModel(title: title, tintColor: .red, image: image)
            case .two: return ViewModel(title: title, tintColor: .blue, image: image)
            case .three: return ViewModel(title: title, tintColor: .orange, image: image)
            case .four: return ViewModel(title: title, tintColor: .black, image: image)
        }
    }
}
