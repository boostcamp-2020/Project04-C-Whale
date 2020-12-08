//
//  MenuPresenter.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/08.
//

import Foundation

protocol MenuPresentLogic {
    
}

class MenuPresenter {
    
    weak var viewController: MenuDisplayLogic?
    
    init(viewController: MenuDisplayLogic) {
        self.viewController = viewController
    }
}

extension MenuPresenter: MenuPresentLogic {
    
}
