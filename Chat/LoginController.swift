//
//  LoginController.swift
//  Chat
//
//  Created by Anthony De Leon on 04/09/2017.
//  Copyright © 2017 Chenny Tech. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func enterButtonPressed(_ sender: Any) {
        let deviceId = UIDevice.current.identifierForVendor?.uuidString;
        APIService.login(username: emailTextField.text!, password: passwordTextField.text!, deviceId: deviceId!) { result, response in

            if result["error"] != nil {
                return
            }

            let preferences = UserDefaults.standard
            let data = result["data"] as! [String: Any]
            preferences.set(data["token"], forKey: "token")
            preferences.set((data["user"] as! [String: Any])["id"], forKey: "userId")
            preferences.set(data["deviceId"], forKey: "deviceId")
            preferences.synchronize()

            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Rooms")
            self.present(viewController!, animated: true, completion: nil)
        }
    }
}
