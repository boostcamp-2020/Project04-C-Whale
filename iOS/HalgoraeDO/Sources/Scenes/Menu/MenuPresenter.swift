//
//  MenuPresenter.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/08.
//

import Foundation

protocol MenuPresentLogic {
    func presentProjects(response: MenuModels.FetchProjects.Response)
    func presentUpdatedProject(response: MenuModels.UpdateProject.Response)
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
    
    func presentUpdatedProject(response: MenuModels.UpdateProject.Response) {
        let vm = MenuModels.ProjectVM(project: response.project)
        let favorite = MenuModels.ProjectVM(project: response.project, makeFavorite: true)
        let viewModel = MenuModels.UpdateProject.ViewModel(favorite: favorite, project: vm)
        viewController?.displayUpdatedProject(viewModel: viewModel)
    }
}
