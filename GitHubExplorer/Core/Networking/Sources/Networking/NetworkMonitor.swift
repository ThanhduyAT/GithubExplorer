//
//  NetworkMonitor.swift
//  Networking
//
//  Created by Duy Thanh on 3/5/25.
//
import Foundation
import Network

@Observable
public class NetworkMonitor: @unchecked Sendable {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    public private(set) var isConnected = true
    public private(set) var connectionType: ConnectionType = .unknown

    public enum ConnectionType {
        case wifi
        case cellular
        case wired
        case unknown
    }

    public init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                self?.updateConnectionType(path)
            }
        }
        monitor.start(queue: queue)
    }

    private func updateConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .wired
        } else {
            connectionType = .unknown
        }
    }

    deinit {
        monitor.cancel()
    }
}
