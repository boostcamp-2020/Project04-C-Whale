//
//  CommentEndPoint.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/10.
//

import Foundation

enum CommentEndPoint {
    case get(taskId: String)
    case create(taskId: String, request: Data)
    case update(id: String, commentId: String, titleData: Data)
    case delete(id: String, commentId: String)
}

extension CommentEndPoint: EndPointType {

    var baseURL: URL {
        return URL(string: "http://101.101.210.222:3000/api")!
    }

    var path: String {
        switch self {
            case .get(let id): return "task/\(id)/comment"
            case .create(let id, _): return "task/\(id)/comment"
            case .update(let id, let commentId, _): return "task/\(id)/comment/\(commentId)"
            case .delete(let id, let commentId): return "task/\(id)/comment/\(commentId)"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
            case .get: return .get
            case .create: return .post
            case .update: return .put
            case .delete: return .delete
        }
    }

    var httpTask: HTTPTask {
        switch self {
            case .get: return (nil, nil)
            case .create(_, let body): return (body, nil)
            case .update(_, _, let comment): return (comment, nil)
            case .delete: return (nil, nil)
        }
    }

    var headers: HTTPHeaders? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(ProcessInfo.processInfo.environment["token"] ?? "")"
        ]
    }
}
