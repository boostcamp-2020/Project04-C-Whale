//
//  TaskDetailModels.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/07.
//

import Foundation

enum TaskDetailModels {
    
    // MARK: - Usecases
    
    enum FetchSubTasks {
        struct Request {
            var id: String
        }
        
        struct Response {
            var tasks: [Task]
        }
        
        struct ViewModel {
            var taskVMs: [TaskListModels.DisplayedTask]
        }
    }
    
    enum FetchComments {
        struct Request {
            
        }
        
        struct Response {
            
        }
        
        struct ViewModel {
            
        }
    }
    
    enum FetchBookmarks {
        struct Request {
            
        }
        
        struct Response {
            
        }
        
        struct ViewModel {
            
        }
    }
}
