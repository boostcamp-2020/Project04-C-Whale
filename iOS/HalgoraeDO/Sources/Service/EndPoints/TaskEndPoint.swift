//
//  TaskEndPoint.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/08.
//

import Foundation

enum TaskEndPoint {
    case get(taskId: Int)
    case create(request: Data)
    case titleUpdate(id: Int, titleData: Data)
    case update(id: Int, project: Data)
    case delete(id: Int)
}

extension TaskEndPoint: EndPointType {

    var baseURL: URL {
        return URL(string: "http://101.101.210.222:3000/api")!
    }

    var path: String {
        switch self {
            case .get(let id): return "task/\(id)"
            case .create: return "task"
            case .titleUpdate(let id, _): return "\(id)"
            case .update(let id, _): return "\(id)"
            case .delete(let id): return "\(id)"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
            case .get: return .get
            case .create: return .post
            case .titleUpdate: return .patch
            case .update: return .put
            case .delete: return .delete
        }
    }

    var httpTask: HTTPTask {
        switch self {
            case .get: return (nil, nil)
            case .create(let body): return (body, nil)
            case .titleUpdate(_, let titleData): return (titleData, nil)
            case .update(_, let project): return (project, nil)
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
