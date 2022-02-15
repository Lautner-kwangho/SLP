//
//  SocketIOMananger.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/14.
//

import Foundation
import SocketIO

class SocketIOMananger: NSObject {
    static let shared = SocketIOMananger()
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    override init() {
        super.init()
        manager = SocketManager(socketURL: URL(string: URL.SesacURL)!, config: [
            .log(true),
            .compress
        ])
        
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED: ", data, ack)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED: ", data, ack)
        }
        
        socket.on("chat") { dataArray, ack in
            print("SeSAC RECEIVED", dataArray, ack)
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
}
