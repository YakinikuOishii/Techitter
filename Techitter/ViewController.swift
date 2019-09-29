//
//  ViewController.swift
//  Techitter
//
//  Created by 笠原未来 on 2019/09/23.
//  Copyright © 2019 笠原未来. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet var userNameField: UITextField!
    
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func login() {
       performSegue(withIdentifier: "toTimeline", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! TweetViewController
        let userName: String!
        if userNameField.text!.isEmpty {
            userName = "匿名"
        }else{
            userName = userNameField.text
        }
        nextVC.userName = userName
    }

//    @IBAction func toNextVC() {
    
//    }
    
}

