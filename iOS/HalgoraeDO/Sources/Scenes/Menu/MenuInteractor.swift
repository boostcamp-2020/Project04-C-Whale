//
//  MenuInteractor.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/08.
//

import Foundation

protocol MenuBusinessLogic {
    func fetchProjects()
    func createProject(request: MenuModels.CreateProject.Request)
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
        worker.request(endPoint: .getAll) { [weak self] (projects: [Project]?) in
            let projects = projects ?? []
            self?.projects = projects
            self?.presenter.presentProjects(response: .init(projects: projects))
        }
    }
    
    func createProject(request: MenuModels.CreateProject.Request) {
        guard let requestData = request.projectFields.encodeData else { return }
        worker.request(endPoint: .create(request: requestData)) { [weak self] (projects: [Project]?) in
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

        let vmForFavorite = MenuModels.ProjectVM(projectVM: request.project)
        guard let requestData = vmForFavorite.encodeData else { return }
        worker.request(endPoint: .update(id: vmForFavorite.id, project: requestData)) { (projects: [Project]?) in return }
    }
}

