//
//  MenuInteractor.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/08.
//

import Foundation

protocol MenuBusinessLogic {
    func fetchProjects()
    func updateProject(request: MenuModels.UpdateProject.Request)
}

protocol MenuDataStore {
    var projects: [Project] { get set }
}

class MenuInteractor: MenuDataStore {
    
    let presenter: MenuPresentLogic
    let worker: MenuWorker
    var projects: [Project] = []
    
    init(presenter: MenuPresentLogic, worker: MenuWorker) {
        self.presenter = presenter
        self.worker = worker
    }
}

extension MenuInteractor: MenuBusinessLogic {

    func fetchProjects() {
        worker.request(endPoint: .getAll) { [weak self] (projects: [Project]?, error) in
            let projects = projects ?? []
            self?.projects = projects
            self?.presenter.presentProjects(response: .init(projects: projects))
        }
    }
    
    func updateProject(request: MenuModels.UpdateProject.Request) {
        let vm = request.project
        let vmId = vm.id.replacingOccurrences(of: "+", with: "")
        if let index = projects.firstIndex(where: { $0.id == vmId }) {
            projects[index].isFavorite = !vm.isFavorite
            presenter.presentUpdatedProject(response: .init(project: projects[index]))
        }
    }
}

