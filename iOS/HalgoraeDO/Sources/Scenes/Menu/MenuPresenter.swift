//
//  MenuPresenter.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/08.
//

import Foundation

protocol MenuPresentLogic {
    func presentProjects(response: MenuModels.FetchProjects.Response)
}

class MenuPresenter {
    
    weak var viewController: MenuDisplayLogic?
    
    init(viewController: MenuDisplayLogic) {
        self.viewController = viewController
    }
}

extension MenuPresenter: MenuPresentLogic {
    
    func presentProjects(response: MenuModels.FetchProjects.Response) {
        let viewModel = MenuModels.FetchProjects.ViewModel(projects: response.projects)
        viewController?.displayFetchedProjects(viewModel: viewModel)
    }
    