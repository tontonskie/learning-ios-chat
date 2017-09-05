//
//  MessagesController.swift
//  Chat
//
//  Created by Anthony De Leon on 04/09/2017.
//  Copyright © 2017 Chenny Tech. All rights reserved.
//

import UIKit

class MessagesController: UIViewController, UITextFieldDelegate, UITableViewDataSource {

    var roomId: Int!
    var messages: [[String: Any]] = []

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        messagesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "message")
        messagesTableView.dataSource = self

        messageTextField.delegate = self
    }

    func setRoom(roomId: Int) {
        let socket = SocketIOService.getSocket()
        if self.roomId != nil {
            socket.off("chatRoom:\(self.roomId!):newMessage")
        }

        self.roomId = roomId
        socket.on("chatRoom:\(self.roomId!):newMessage") { data, ack in
            self.messages.append(data[0] as! [String: Any])
            self.messagesTableView.reloadData()
        }

        APIService.getMessages(roomId: self.roomId) { result, response in
            self.messages = result["data"] as! [[String: Any]]
            self.messagesTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath)
        cell.textLabel?.text = messages[indexPath.row]["text"] as? String
        return cell
    }

    @IBAction func sendButtonPressed(_ sender: Any) {
        let socket = SocketIOService.getSocket()
        socket.emit("newMessage", [ "chatRoomId": roomId, "text": messageTextField.text!])
        messageTextField.text = ""
    }
}
