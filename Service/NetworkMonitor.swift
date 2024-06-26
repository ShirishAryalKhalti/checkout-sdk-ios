//
//  NetworkMonitor.swift
//  KhaltiCheckout
//
//  Created by Mac on 6/19/24.

import Network

@available(iOS 12.0, *)
class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    var isConnected: Bool = false
    var connectionType: NWInterface.InterfaceType?
    
    private init() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            self.connectionType = path.availableInterfaces.filter {
                path.usesInterfaceType($0.type)
            }.first?.type
        }
        
    }
    
    func startMonitoring(){
        monitor.start(queue: queue)
    }
    
    func removeMonitoring(){
        monitor.cancel()
    }
}

