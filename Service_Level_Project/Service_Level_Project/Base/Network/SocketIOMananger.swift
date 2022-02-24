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
        
        let URL = Point.sendChat.url
        
        manager = SocketManager(socketURL: URL, config: [
            .compress
        ])
        
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in
            let myUid = UserDefaults.standard.string(forKey: UserDefaultsManager.uid)
            
            if let uid = myUid {
                self.socket.emit("changesocketid", uid)
            }
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
//            print("SOCKET IS DISCONNECTED: ", data, ack)
        }
        
        self.socket.on("chat") { dataArray, ack in
            let data = dataArray.first as! NSDictionary
            let chat = data["chat"] as! String
            let id = data["_id"] as! String
            let creatAt = data["createdAt"] as! String
            let from = data["from"] as! String
            let to = data["to"] as! String
            
            NotificationCenter.default.post(name: NSNotification.Name(NotificationCenterName.getMessage), object: self, userInfo: ["chat": chat, "id": id, "creatAt": creatAt, "from": from, "to": to])
        }
        
    }
    
    func establishConnection(completion: @escaping ()-> ()) {
        socket.connect()
        completion()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
}
