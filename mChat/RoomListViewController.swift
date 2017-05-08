//
//  RoomListViewController.swift
//  mChat
//
//  Created by Feng on 2017/3/26.
//  Copyright © 2017年 Fang. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RoomListViewController: UIViewController {
    let ref = FIRDatabase.database().reference().child("rooms")
    var rooms : [[String: Any]] = []
    
    @IBOutlet weak var outButton: UIButton!
    @IBAction func logOut(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil   {
            do {
                try FIRAuth.auth()?.signOut()
                let vca = self.storyboard?.instantiateViewController(withIdentifier: "logOut")//轉型
                self.navigationController?.pushViewController(vca!, animated: true)
                           } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.keyboardDismissMode = .onDrag //滾動收鍵盤
        
        // Do any additional setup after loading the view.
        self.title = "Room"
        self.navigationItem.hidesBackButton = true
        
        ref.observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value as? [String:String] else {
                return
            }
            guard let name = value["name"] else {
                return
            }
            let key = snapshot.key
            //self.rooms.append([ "id": key , "name": name])
            self.tableView.reloadData()
        })
    }

    @IBAction func create(_ sender: Any) {
        guard !(roomNameField.text?.isEmpty ?? true) else {
            return
        }
        
        let roomName = roomNameField.text!
        let roomRef = ref.childByAutoId()
        roomRef.updateChildValues(["name": roomName])
        
        roomNameField.text = nil
    }
    @IBOutlet weak var roomNameField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RoomListViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView:UITableView,numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomItemCell", for: indexPath)
        cell.textLabel?.text = rooms[indexPath.row]["name"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
