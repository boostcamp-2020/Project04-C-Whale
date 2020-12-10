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
            var id: String
        }
        
        struct Response {
            var comments: [Comment]
        }
        
        struct ViewModel {
            var commentVMs: [CommentVM]
    
    enum CreateComment {
        struct Request {
            var commentFields: CommentFields
        }
        
        struct Response {
            var comments: [Comment]
        }
        
        struct ViewModel {
            var comments: [ContentsVM]
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
    
    struct CommentVM: Hashable {
        
        var id: String
        var contents: String?
        var isImage: Bool = false
        
        init(comment: Comment) {
            self.id = comment.id
            self.contents = comment.contents
            self.isImage = comment.isImage
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func ==(lhs: Self, rhs: Self) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    struct CommentFields {
        var taskId: String
        var text: String
    }
}
