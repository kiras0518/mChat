//
//  ChatViewController.swift
//  mChat
//
//  Created by Feng on 2017/3/26.
//  Copyright © 2017年 Fang. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import FirebaseAuth
import FirebaseDatabase

class ChatViewController: JSQMessagesViewController {
    
    var roomId: String!
    var roomName: String!
    var ref: FIRDatabaseReference!
    var messages: [[String: Any]] = []
    
    override func senderId() -> String {
        return FIRAuth.auth()!.currentUser!.uid
    }
    
    override func senderDisplayName() -> String {
        return FIRAuth.auth()!.currentUser!.email!
    }
    
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        let messageRef = self.ref.childByAutoId()
        messageRef.updateChildValues([
            "senderId": senderId,
            "senderDisplayName": senderDisplayName,
            "date": date.timeIntervalSince1970,
            "text": text
            ])
        self.finishSendingMessage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ref = FIRDatabase.database().reference().child("messages/\(roomId!)")
        
        self.collectionView?.collectionViewLayout.incomingAvatarViewSize = .zero
        self.collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
        
        self.ref.observe(.childAdded, with: { (snapshot) in
            guard let message = snapshot.value as? [String: Any] else { return }
            
            self.messages.append(message)
            self.finishReceivingMessage()
        })
        
    }

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

extension ChatViewController {
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        let message = messages[indexPath.row]
        guard let senderId = message["senderId"] as? String,
        let senderDisplayName = message["senderDisplayName"] as? String,
        let ts = message["date"] as? TimeInterval,
        let text = message["text"] as? String
            else {
               return JSQMessage(senderId: "", displayName: "", text: "")
        }
        //return JSQMessage(senderId: "", displayName: "", text: "")
         let date = Date(timeIntervalSince1970: ts)
        
        return JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource? {
        
        let message = messages[indexPath.row]
        
        if (message["senderId"] as? String) == senderId() {
            return createBubbleImage(isOutgoing: true)
        }
        
        return createBubbleImage(isOutgoing: false)
    }
    
    func createBubbleImage(isOutgoing: Bool) -> JSQMessageBubbleImageDataSource {
        let factory = JSQMessagesBubbleImageFactory()
        
        if isOutgoing {
            return factory.outgoingMessagesBubbleImage(with: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
        } else {
            return factory.outgoingMessagesBubbleImage(with: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1))
        }
    }
    
    
    
    
}
