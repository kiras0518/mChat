//
//  ViewController.swift
//  mChat
//
//  Created by Feng on 2017/3/26.
//  Copyright © 2017年 Fang. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*
        if FIRAuth.auth()?.currentUser == nil {
            return
        }
        
        let user_b = (FIRAuth.auth()?.currentUser)!*/
              //如果不存在往後跑
        guard (FIRAuth.auth()?.currentUser) != nil else{
            //需要登入
            self.presentAuthView()
            return
        }
            //不需要登入
            self.presentRoomListView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentAuthView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController      //轉型
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func presentRoomListView() {
        print("show room list")
        let vc = storyboard?.instantiateViewController(withIdentifier: "RoomListViewController") as! RoomListViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }

    //override func prepare()
}

