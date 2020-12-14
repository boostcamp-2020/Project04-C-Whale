//
//  ProjectStorage.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/12.
//

import CoreData

protocol ProjectStorageType: APIStorageType {
    func fetchProjectList(completion: @escaping ([Project]?, Error?) -> Void)
    func fetchProject(id: String) -> Project?
    func createProject(for projectFields: MenuModels.ProjectFields)
    func updateProject(id: String, for projectFields: MenuModels.ProjectFields)
    func updateProjects(to projects: [Project])
    func deleteProject(id: String)
    func deleteAll()
}

extension Storage: ProjectStorageType {
    
    func fetchProjectList(completion: @escaping ([Project]?, Error?) -> Void) {
        childContext.perform {
            let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
            do {
                let projectList = try self.childContext.fetch(fetchRequest)
                completion(projectList, nil)
            } catch let error {
                completion(nil, StorageError.read(error.localizedDescription))
            }
        }
    }
    
    func fetchProject(id: String) -> Project? {
        let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            return try self.childContext.fetch(fetchRequest).first
        } catch {
            #if DEBUG
            print("Failed fetch project id: \(id), \(error)")
            #endif
        }
        return nil
    }
    
    func createProject(for projectFields: MenuModels.ProjectFields) {
        let _ = Project(fields: projectFields, context: childContext)
        saveContext(context: childContext)
    }
    
    func updateProject(id: String, for projectFields: MenuModels.ProjectFields) {
        guard let project = fetchProject(id: id) else { return }
        project.configure(fields: projectFields)
        saveContext(context: childContext)
    }
    
    func updateProjects(to projects: [Project]) {
        deleteAll()
        self.saveContext(context: self.childContext)
        let _ = projects
        self.saveContext(context: self.childContext)
    }
    
    func deleteProject(id: String) {
        guard let project = fetchProject(id: id) else { return }
        childContext.delete(project)
        saveContext(context: childContext)
    }
    
    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Project")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try self.childContext.execute(deleteRequest)
            self.saveContext(context: self.childContext)
        } catch {
            #if DEBUG
            print(error)
            #endif
        }
    }
}
