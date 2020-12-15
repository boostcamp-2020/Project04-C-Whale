//
//  BookmarkEndPoint.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/10.
//

import Foundation

enum BookmarkEndPoint {
    case get(taskId: String)
    case create(taskId: String, request: Data)
    case update(id: String, bookmarkId: String, titleData: Data)
    case delete(id: String, bookmarkId: String)
}

extension BookmarkEndPoint: EndPointType {

    var baseURL: URL {
        return URL(string: "http://101.101.210.222:3000/api")!
    }

    var path: String {
        switch self {
            case .get(let id): return "task/\(id)/bookmark"
            case .create(let id, _): return "task/\(id)/bookmark"
            case .update(let id, let commentId, _): return "task/\(id)/bookmark/\(commentId)"
            case .delete(let id, let commentId): return "task/\(id)/bookmark/\(commentId)"
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
            case .update(_, _, let bookmark): return (bookmark, nil)
            case .delete: return (nil, nil)
        }
    }

    var headers: HTTPHeaders? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(AuthManager.shared.userToken ?? "")"
        ]
    }
}
