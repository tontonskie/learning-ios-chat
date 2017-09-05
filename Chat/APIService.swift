//
//  WebService.swift
//  Chat
//
//  Created by Anthony De Leon on 04/09/2017.
//  Copyright © 2017 Chenny Tech. All rights reserved.
//

import Foundation

class APIService {

    static func login(username: String, password: String, deviceId: String, callback: @escaping ([String: Any], HTTPURLResponse) -> Swift.Void) {
        let params = [
            "username": username,
            "password": password,
            "deviceId": deviceId,
            "deviceType": "ios"
        ]

        let url = URL(string: "\(Config.APIBaseURL)/users/login")
        var request = URLRequest(url: url!)
        request.timeoutInterval = 60.0 // TimeoutInterval in Second
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params)
        } catch {}

        URLSession.shared.dataTask(with: request) { data, response, error in
            do {

                let result = try JSONSerialization.jsonObject(with: data!) as! [String: Any]
                DispatchQueue.main.async(execute: {
                    callback(result, response as! HTTPURLResponse)
                })

            } catch {}
        }.resume()
    }

    static func getRooms(callback: @escaping ([String: Any], HTTPURLResponse) -> Swift.Void) {
        let url = URL(string: "\(Config.APIBaseURL)/chat-rooms")
        var request = URLRequest(url: url!)
        request.timeoutInterval = 60.0 // TimeoutInterval in Second
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let deviceId = UserDefaults.standard.string(forKey: "deviceId")!
        let token = UserDefaults.standard.string(forKey: "token")!
        request.addValue("Bearer ios \(deviceId) \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            do {

                let result = try JSONSerialization.jsonObject(with: data!) as! [String: Any]
                DispatchQueue.main.async(execute: {
                    callback(result, response as! HTTPURLResponse)
                })

            } catch {}
        }.resume()
    }

    static func getMessages(roomId: Int, callback: @escaping ([String: Any], HTTPURLResponse) -> Swift.Void) {
        let url = URL(string: "\(Config.APIBaseURL)/chat-rooms/\(roomId)/messages")
        var request = URLRequest(url: url!)
        request.timeoutInterval = 60.0 // TimeoutInterval in Second
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let deviceId = UserDefaults.standard.string(forKey: "deviceId")!
        let token = UserDefaults.standard.string(forKey: "token")!
        request.addValue("Bearer ios \(deviceId) \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            do {

                let result = try JSONSerialization.jsonObject(with: data!) as! [String: Any]
                DispatchQueue.main.async(execute: {
                    callback(result, response as! HTTPURLResponse)
                })

            } catch {}
        }.resume()
    }
}
