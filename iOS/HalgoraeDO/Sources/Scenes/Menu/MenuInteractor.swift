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
        worker.request(endPoint: .getAll) { [weak self] (response: Response<[Project]>?) in
            let projects = response?.projectInfos ?? []
            self?.projects = projects
            self?.worker.updateProjects(projects)
            self?.presenter.presentProjects(response: .init(projects: projects))
        }
    }
    
    func createProject(request: MenuModels.CreateProject.Request) {
        guard let requestData = request.projectFields.encodeData else { return }
        worker.requestPostAndGet(post: ProjectEndPoint.create(request: requestData), get: ProjectEndPoint.getAll) { [weak self] (response: Response<[Project]>?) in
            let projects = response?.projectInfos ?? []
            self?.projects = projects
            self?.worker.updateProjects(projects)
            self?.presenter.presentProjects(response: .init(projects: projects))
        }
    }
    
    func updateProject(request: MenuModels.UpdateProject.Request) {
        var vmForFavorite = request.project
        vmForFavorite.id = vmForFavorite.id.replacingOccurrences(of: "+", with: "")
        guard let requestData = vmForFavorite.encodeData else { return }
        worker.requestPostAndGet(post: ProjectEndPoint.update(id: vmForFavorite.id, project: requestData), get: ProjectEndPoint.getAll) { [weak self] (response: Response<[Project]>?) in
            let projects = response?.projectInfos ?? []
            self?.projects = projects
            self?.worker.updateProjects(projects)
            self?.presenter.presentProjects(response: .init(projects: projects))
        }
    }
}

