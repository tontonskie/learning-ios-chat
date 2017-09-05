//
//  SocketIOService.swift
//  Chat
//
//  Created by Anthony De Leon on 04/09/2017.
//  Copyright © 2017 Chenny Tech. All rights reserved.
//

import SocketIO
import Foundation

class SocketIOService {

    private static var socketIOClient: SocketIOClient!

    static func connect(onConnectCallback: @escaping (SocketIOClient) -> Swift.Void) {
        if socketIOClient != nil {
            onConnectCallback(socketIOClient)
            return
        }

        let preferences = UserDefaults.standard
        let deviceId = preferences.string(forKey: "deviceId")!
        let token = preferences.string(forKey: "token")!

        let socket = SocketIOClient(socketURL: URL(string: Config.SocketIOBaseURL)!, config: [
            .log(true), .compress, .extraHeaders(["Authorization" : "Bearer ios \(deviceId) \(token)"])
        ])
    
        socket.on(clientEvent: .connect) {data, ack in
            SocketIOService.socketIOClient = socket
            onConnectCallback(socket)
        }
    
        socket.connect()
    }

    static func getSocket() -> SocketIOClient {
        return SocketIOService.socketIOClient
    }
}
