//
//  TaskDetailModels.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/07.
//

import UIKit

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
            var taskVMs: [TaskListModels.TaskVM]
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
            var commentVMs: [ContentsVM]
        }
    }
    
    enum FetchBookmarks {
        struct Request {
            var id: String
        }
        
        struct Response {
            var bookmakrs: [Bookmark]
        }
        
        struct ViewModel {
            var bookmarkVMs: [ContentsVM]
        }
    }
    
    enum CreateComment {
        struct Request {
            var taskId: String
            var commentFields: CommentFields
        }
 
    }
    
    enum CreateBookmark {
        struct Request {
            var taskId: String
            var bookmarkFields: BookmarkFields
        }
    }
    
    // MARK: ViewModels
    
    struct ContentsVM: Hashable {
        
        var image: UIImage?
        var id: String
        var contents: String?
        
        init(comment: Comment) {
            self.id = comment.id
            self.contents = comment.content
        }
        
        init(bookmark: Bookmark) {
            self.id = bookmark.id
            self.contents = bookmark.url
            self.image = UIImage(systemName: "paperclip")
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func ==(lhs: Self, rhs: Self) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    struct CommentFields: Encodable {
        var content: String
    }
    
    struct BookmarkFields: Encodable {
        var url: String
    }
}
