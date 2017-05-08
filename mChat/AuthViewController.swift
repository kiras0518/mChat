//
//  AuthViewController.swift
//  mChat
//
//  Created by Feng on 2017/3/26.
//  Copyright © 2017年 Fang. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class AuthViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "AUTH"
        self.navigationItem.hidesBackButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(_ sender: Any) {
        //欄位空不通過
        if emailField.text?.isEmpty ?? true || passwordField.text?.isEmpty ?? true {
            SVProgressHUD.showError(withStatus: "不可空白!")
            SVProgressHUD.dismiss(withDelay:5.0)
            return
        }
        SVProgressHUD.show(withStatus: "註冊中")
        
        FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user , error) in
        if let error = error {
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            SVProgressHUD.dismiss(withDelay:5.0)
            return
        }
            SVProgressHUD.dismiss()
            //self.authSuccess()
        })
    }
        
    
    
    @IBAction func login(_ sender: Any) {
        //欄位空不通過
        if emailField.text?.isEmpty ?? true || passwordField.text?.isEmpty ?? true {
            SVProgressHUD.showError(withStatus: "不可空白!")
            SVProgressHUD.dismiss(withDelay:5.0)
            return
        }

        SVProgressHUD.show(withStatus: "登入中")
        
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user , error) in
            if let error = error {
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                SVProgressHUD.dismiss(withDelay:5.0)
                return
            }
            SVProgressHUD.dismiss()
            //self.authSuccess()
        })
    }
    
    
    func authSuccess() {
        print ("show room list from authview")
    
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
