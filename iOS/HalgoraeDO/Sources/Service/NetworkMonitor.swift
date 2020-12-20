//
//  NetworkMonitor.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/13.
//

import Network

class NetworkMonitor {
    
    enum ConnectionType {
        case wifi
        case ethernet
        case cellular
        case unknown
    }
    
    static public let shared = NetworkMonitor()
    let monitor: NWPathMonitor
    let queue: DispatchQueue
    let networkManager: NetworkDispatcher
    var connectionType: ConnectionType = .unknown
    var isAvailable: Bool {
        return monitor.currentPath.status == .satisfied
    }
    var storage: EndPointStorageType {
        return Storage()
    }
 
    private init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue.global(qos: .background)
        self.monitor.start(queue: queue)
        self.networkManager = NetworkManager(sessionManager: SessionManager(configuration: .default))
    }
 
    func startMonitoring() {
        self.monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.connectionType = self.checkConnectionTypeForPath(path)
            
            guard self.isAvailable else { return }
            self.requestEndPointsInStorage()
        }
    }
 
    func stopMonitoring() {
        self.monitor.cancel()
    }
 
    func checkConnectionTypeForPath(_ path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        }
        return .unknown
    }
    
    private func requestEndPointsInStorage() {
        storage.fetchEndPoints { [weak self] (endPoints, error) in
            for endPoint in endPoints {
                self?.networkManager.fetchData(endPoint.endPoint) { (response: Response<String>?, error) in
                    guard error == nil else {
                        #if DEBUG
                        print("Fail request endPoint: \(error!)")
                        #endif
                        return
                    }
                }
                self?.storage.deleteEndPoint(endPoint)
            }
        }
    }
}
