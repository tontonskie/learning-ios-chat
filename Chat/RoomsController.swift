//
//  ViewController.swift
//  Chat
//
//  Created by Anthony De Leon on 04/09/2017.
//  Copyright © 2017 Chenny Tech. All rights reserved.
//

import Foundation
import SocketIO
import UIKit

class RoomsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var roomsTableView: UITableView!

    var rooms: [[String: Any]] = []
    var connected: Bool = false;

    override func viewDidLoad() {
        super.viewDidLoad()

        SocketIOService.connect() { socket in
            self.connected = true
            APIService.getRooms() { result, response in
                self.rooms = result["data"] as! [[String: Any]]
                self.roomsTableView.reloadData()
            }
        }

        roomsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "room")
        roomsTableView.dataSource = self
        roomsTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "room", for: indexPath)
        cell.textLabel?.text = rooms[indexPath.row]["recentMessage"] as? String
        cell.isUserInteractionEnabled = connected
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if connected {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Messages") as! MessagesController
            viewController.setRoom(roomId: rooms[indexPath.row]["id"] as! Int)
            self.show(viewController, sender: self)
        }
    }
}
